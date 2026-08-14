;;; my-agent-shell-perf-fix.el --- Agent-shell performance fixes -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Two independent layers:
;;
;; 1. ALWAYS-ON OPTIMIZATIONS (behavior-preserving; the one perf-mode-
;;    gated exception, FONTIFIED TAGGING, is noted below)
;;    el-patch of agent-shell.el + agent-shell-ui.el.  Each
;;    optimization targets a per-chunk cost on the streaming path: a
;;    single agent turn streams dozens to hundreds of chunks, and the
;;    buffer grows monotonically, so anything O(buffer) per chunk is
;;    O(n^2) over the session.  The per-chunk hot path is
;;    `agent-shell-ui-update-fragment' (called once per chunk via
;;    `agent-shell--update-fragment'), plus
;;    `agent-shell--refresh-activity-group-header' (once per tool and
;;    thought chunk) and the markdown renderer (per chunk).
;;
;;    - FRAGMENT INDEX (agent-shell-ui.el): replaces the per-chunk
;;      `text-property-search-*' scans with an O(1) marker index keyed
;;      by qualified-id.  The backward-from-`point-max' scan cost is
;;      proportional to how far the target sits from the buffer end:
;;      cheap for the streaming tail message (a few interval steps past
;;      the input area), but O(buffer) for the activity-group header at
;;      the top and for mid-buffer tool updates.  The group header is
;;      relabeled on every tool and thought chunk, so that one lookup
;;      alone was O(buffer) per chunk -- O(n^2) over a session.
;;      `agent-shell-ui-update-fragment', `agent-shell-ui--replace-label',
;;      `agent-shell-ui-delete-fragment' and `agent-shell-ui-update-text'
;;      each ran one such scan per call, and `agent-shell-ui--block-range'
;;      ran a bidirectional one; a chunk touching a block paid several
;;      full-buffer walks.
;;
;;    - SECTION INDEX (agent-shell-ui.el): the same index entry also
;;      caches the body/label-left/label-right section starts, so the
;;      per-chunk `agent-shell-ui--nearest-range-matching-property'
;;      searches (backward + forward `text-property-search-*' over the
;;      block, run for the body lookup and again for each of the three
;;      return-value section ranges) become O(1) lookups verified
;;      against the buffer's `agent-shell-ui-section' property.
;;      Section ends are re-derived from the buffer and capped at the
;;      block end; stale entries fall back to the original search.
;;      A missing or stale entry re-discovers its section markers on
;;      the next update (`agent-shell-ui--self-heal-sections').
;;      Deriving the end as "the end of the section's first run from its
;;      registered start" is safe because the body's
;;      `agent-shell-ui-section' run stays contiguous across markdown
;;      rendering: every render pass reuses `buffer-substring' text
;;      (which copies text properties) or explicitly carries caller
;;      properties onto inserted chars (fenced blocks and images -- the
;;      image pass in agent-shell-markdown.el documents this invariant
;;      in its placeholder-property comment).  A future render pass
;;      that broke contiguity would truncate the indexed section end,
;;      and the start-marker verification would not catch it -- keep
;;      this invariant in mind when the renderer changes.
;;
;;    - LABEL SKIP (agent-shell-ui--replace-label): every tool-call
;;      update rewrote the label even when it had not changed -- a
;;      delete + insert + re-propertize on the hot path.  When the new
;;      label text equals the label already in the buffer, the rewrite
;;      is skipped entirely.  Labels are deterministic renderings of
;;      the caller's state (same text, same properties), so skipping
;;      changes nothing visible.  The comparison is text-only: a
;;      caller that changed only properties (e.g. a face) while
;;      keeping the text identical would be silently dropped; none of
;;      the current callers do this.
;;
;;    - GROUP-HEADER GATING (agent-shell--refresh-activity-group-header):
;;      the function relabels the activity-group header on every tool
;;      and thought chunk; the recomputed label usually equals the one
;;      already rendered, so the fragment update is skipped unless the
;;      label or the above-last-prompt placement actually changed.
;;      Label and placement are cached per group in the state alist.
;;
;;    - APPEND-BODY TAIL CLEAR (agent-shell-ui--append-body): the
;;      whole-body `remove-text-properties' invisible-clear on every
;;      chunk is scoped to the trailing-whitespace tail -- the only
;;      place `invisible' can live in a visible body
;;      (`agent-shell-markdown' never sets it).  Same result, no
;;      whole-body interval walk.
;;
;;    - BLOCK-END THREADING (agent-shell-ui--indexed-section-match):
;;      the per-chunk section lookups accept the caller's already-
;;      derived block end instead of each re-walking the interval
;;      tree.  An append chunk derived the block end on every
;;      `--block-range' call and again inside each section lookup;
;;      threading removes the per-section derivations.  The
;;      `--block-range' calls remain, of which the padding-end and
;;      final-result ones return the same value and could be merged --
;;      left separate for clarity.
;;
;;    - FONTIFIED TAGGING (agent-shell-ui--apply-body-section-properties,
;;      agent-shell-ui--replace-label, agent-shell-ui--insert-fragment,
;;      agent-shell-ui-update-text): in perf mode new body/label chars
;;      are marked `fontified' so jit-lock never re-runs over streaming
;;      chunks.  `agent-shell-markdown-replace-markup' already does this
;;      when rendering; with the renderer set to `#'ignore' nothing did,
;;      so every chunk paid font-lock region extension plus the buffer's
;;      goto-address pass (shell-maker enables `goto-address-mode') at
;;      the next redisplay.  Gated on perf mode, so default rendering
;;      behavior is untouched.
;;
;;    Every lookup keeps the original search as fallback: a stale index
;;    entry (block deleted/moved/recreated) fails the start-marker
;;    property check and falls through to the exact original scan.
;;    A missing or stale entry re-discovers its sections on the next
;;    update (`agent-shell-ui--self-heal-sections'); see SECTION INDEX
;;    above.  The block end is re-derived from the buffer
;;    (`next-single-property-change', a single interval step), so
;;    appends and label-length changes are always reflected and end
;;    markers can never drift.  Results are identical in every case
;;    except one deliberate improvement: on a block whose state run was
;;    split into adjacent runs by `agent-shell-ui-update-text' appends,
;;    `agent-shell-ui-delete-fragment' and the update-text replace path
;;    remove the WHOLE entry, where the original backward search matched
;;    only the last run and orphaned the earlier runs' text.  Callers
;;    intend whole-entry removal; the original left dead text behind.
;;    The perf-mode-gated `fontified' tag is display-only and changes
;;    nothing else.  Run `M-x el-patch-validate-all' (or `make check'
;;    in .emacs.d, which also runs the test suite) after any package
;;    update.
;;
;; 2. PERF-FIX TOGGLE (user-space, feature tradeoffs)
;;    `tl/agent-shell-perf-fix-toggle', ON by default.
;;    - markdown rendering off (raw text, no per-chunk passes)
;;    - activity groups expanded (skips the per-chunk group-collapse
;;      re-derivation; only groups CREATED while perf mode is on start
;;      expanded -- one already collapsed when the toggle is enabled
;;      keeps its fold state and its members keep paying the collapse
;;      re-apply until re-expanded)
;;    - busy indicator off (no 10 Hz heartbeat redraw)
;;    - shell-maker auto-scroll off (a plain `disable' function; the
;;      toggle `advice-add's it as `:around' on enable and
;;      `advice-remove's it on disable -- the advice name is the
;;      function name, so re-enabling replaces cleanly and the
;;      original function is restored on disable; verified in batch)
;;
;; 3. PRETTIFY (user-space command)
;;    `tl/agent-shell-prettify': render markdown in the selected
;;    region as if the toggle were disabled -- the real renderer runs on
;;    the fragment-block portion regardless of perf-mode state; images on
;;    (concordance with the default look); frozen spans skipped
;;    (idempotent); non-fragment slivers untouched.

;;; Code:


(require 'cl-lib)
(require 'map)
(require 'el-patch)
(require 'my-mk-toggle)
;; Toplevel `require' (not eval-when-compile): this file el-patches
;; agent-shell, so agent-shell must be loaded at runtime anyway, and a
;; toplevel require also records agent-shell's functions in the
;; byte-compiler's `byte-compile-new-defuns' (an eval-when-compile
;; require does not -- its handler insulates that list), which
;; suppresses "might not be defined at runtime" for the el-patch
;; bodies in any compile order.
(require 'agent-shell)
(declare-function agent-shell-ui--replace-label "agent-shell-ui"
                  (qualified-id section new-text block-start block-end))
(declare-function agent-shell-viewport--buffer "agent-shell-viewport"
                  (&key shell-buffer existing-only))
(declare-function agent-shell-viewport-refresh "agent-shell-viewport" ())

(defun my/agent-shell/perf-fix--render-off-p ()
  "Return non-nil when perf mode has disabled markdown rendering.
Perf mode (`my/agent-shell/perf-fix') sets
`agent-shell-markdown-render-function' to `#'ignore'; this predicate
is the signal the jit-lock-skip optimizations key on.  It tracks the
actual render state, so it stays correct regardless of how the toggle
was reached."
  (eq agent-shell-markdown-render-function #'ignore))

;;;; 1. Always-on optimizations -- fragment/section index, label skip,
;;;;    append tail clear, block-end threading, fontified tagging
;;;;    (perf-mode-gated; the one non-pure item in this layer)


(el-patch-feature agent-shell-ui)
(el-patch-feature agent-shell)

(defvar-local my/agent-shell-ui--fragment-index nil
  "Buffer-local index: qualified-id -> entry alist.

An entry holds the block start marker plus optional section start
markers:

  ((:start . START-MARKER)
   (body . BODY-START-MARKER)
   (label-left . LABEL-LEFT-START-MARKER)
   (label-right . LABEL-RIGHT-START-MARKER))

Lets `agent-shell-ui-update-fragment' locate a block (and its body and
label sections) in O(1) instead of scanning the buffer on every chunk.
Only the starts are stored; ends are re-derived from the buffer, so
appends and label-length changes are always reflected and nothing can
drift.  Entries are verified against the buffer before use and
re-registered on miss, so stale entries self-heal.")

;; --- Helpers (new symbols; plain definitions, no el-patch) ---


(defun my/agent-shell-ui--fragment-index-table ()
  "Return the buffer-local fragment index hash table, creating it if needed."
  (or my/agent-shell-ui--fragment-index
      (setq my/agent-shell-ui--fragment-index (make-hash-table :test #'equal))))

(defun my/agent-shell-ui--index-fragment (qualified-id start &optional body-start label-left-start label-right-start)
  "Register fragment QUALIFIED-ID starting at START in the index.

Optional BODY-START, LABEL-LEFT-START and LABEL-RIGHT-START register the
section starts so `agent-shell-ui--indexed-section-match' can resolve
sections in O(1).  When no section starts are given, an existing entry
keeps its cached sections (the block-start refresh path in
`agent-shell-ui-update-fragment'); a fresh entry is created section-less
\(e.g. plain text entries, which have no sections)."
  (let* ((table (my/agent-shell-ui--fragment-index-table))
         (entry (or (gethash qualified-id table)
                    (list (cons :start nil)
                          (cons 'body nil)
                          (cons 'label-left nil)
                          (cons 'label-right nil)))))
    ;; `setf' + `alist-get' rather than `map-put!': the entry may be a
    ;; foreign alist (e.g. hand-built by a test or left over from a
    ;; corrupt index) missing some keys, and `map-put!' refuses to add
    ;; keys to an alist (`map-not-inplace').
    (setf (alist-get :start entry) (copy-marker start))
    (when body-start
      (setf (alist-get 'body entry) (copy-marker body-start)))
    (when label-left-start
      (setf (alist-get 'label-left entry) (copy-marker label-left-start)))
    (when label-right-start
      (setf (alist-get 'label-right entry) (copy-marker label-right-start)))
    (puthash qualified-id entry table)))

(defun my/agent-shell-ui--indexed-entry (qualified-id)
  "Return the verified index entry for QUALIFIED-ID, or nil.
An entry is valid only while the buffer still shows that fragment at the
indexed position; any delete/move fails the start-marker property check
and returns nil, forcing the caller's search fallback."
  (when-let* ((entry (gethash qualified-id (my/agent-shell-ui--fragment-index-table)))
              (start (map-elt entry :start))
              ((markerp start))
              ((eq (current-buffer) (marker-buffer start)))
              (start-pos (marker-position start))
              (state (get-text-property start-pos 'agent-shell-ui-state))
              ((equal qualified-id (map-elt state :qualified-id))))
    entry))

(defun my/agent-shell-ui--indexed-match (qualified-id)
  "Return a prop-match for QUALIFIED-ID from the index, nil when stale.
A match is valid only while the buffer still shows that fragment at the
indexed position; any delete/move fails the property check and forces
the caller's search fallback.  The block end is re-derived from the
buffer with `next-single-property-change' (a single interval step), so
appends and label-length changes are always reflected and the end can
never drift."
  (when-let* ((entry (my/agent-shell-ui--indexed-entry qualified-id))
              (start-pos (marker-position (map-elt entry :start))))
    (let ((end-pos (or (next-single-property-change
                        start-pos 'agent-shell-ui-state nil (point-max))
                       (point-max))))
      ;; `agent-shell-ui-update-text' appends can split a block into
      ;; adjacent runs; extend across any further runs carrying the qid.
      (while (equal qualified-id
                    (map-elt (get-text-property end-pos 'agent-shell-ui-state)
                             :qualified-id))
        (setq end-pos (or (next-single-property-change
                           end-pos 'agent-shell-ui-state nil (point-max))
                          (point-max))))
      (make-prop-match :beginning start-pos :end end-pos
                       :value qualified-id))))

(defun my/agent-shell-ui--indexed-section-match (qualified-id section &optional block-end)
  "Return a range alist for SECTION of QUALIFIED-ID, or nil when stale.
SECTION is one of `body', `label-left' or `label-right'.  The section
start comes from the index entry (registered by
`agent-shell-ui--insert-fragment'), verified against the buffer's
`agent-shell-ui-section' property; the end is re-derived with a single
`next-single-property-change' step, searched to `point-max' and capped
at the block end, so a stale marker can never extend a section past
its block.  Returns
nil when the entry, the section, or the verification is missing, so
callers fall back to the exact original search.  A missing or stale
entry re-discovers its sections on the next update
\(`agent-shell-ui--self-heal-sections').

BLOCK-END, when given, is the caller's already-derived block end (e.g.
from `agent-shell-ui--block-range'), skipping this lookup's own
`next-single-property-change' walk.  The per-chunk hot path re-derives
the same block end for every section lookup; threading it through turns
those walks into a single derivation per `agent-shell-ui-update-fragment'
call."
  (when-let* ((entry (my/agent-shell-ui--indexed-entry qualified-id))
              (start-pos (marker-position (map-elt entry :start)))
              (block-end (or block-end
                             (or (next-single-property-change
                                  start-pos 'agent-shell-ui-state nil (point-max))
                                 (point-max)))))
    (when-let* ((sec-marker (map-elt entry section))
                ((markerp sec-marker))
                (sec-pos (marker-position sec-marker))
                ((and (>= sec-pos start-pos) (< sec-pos block-end)))
                ((eq (get-text-property sec-pos 'agent-shell-ui-section) section)))
      (let ((sec-end (or (next-single-property-change
                          sec-pos 'agent-shell-ui-section nil (point-max))
                         (point-max))))
        (list (cons :start sec-pos)
              (cons :end (min sec-end block-end)))))))

;; --- Self-heal: after an index loss, re-discover section markers ---
;;
;; `my/agent-shell-ui--index-fragment' re-registers only the block start
;; on the refresh path; a fresh entry is created section-less and the
;; section lookups would fall back to a bounded search on every chunk
;; until the block is regenerated.  These helpers close that gap: one
;; bounded interval walk, run only when the entry was missing or
;; stale, restores the section markers so the lookups stay O(1).

(defun my/agent-shell-ui--section-marker-valid-p (entry section)
  "Non-nil when ENTRY's marker for SECTION points at a real SECTION run."
  (when-let* ((marker (map-elt entry section))
              ((markerp marker))
              (pos (marker-position marker)))
    (eq (get-text-property pos 'agent-shell-ui-section) section)))

(defun my/agent-shell-ui--self-heal-sections (qualified-id block-start block-end)
  "Register the section markers of the block at [BLOCK-START, BLOCK-END).
Discovers the body/label-left/label-right section starts with one
bounded interval walk and registers them on the index entry.  Used
right after `my/agent-shell-ui--index-fragment' re-creates a fresh entry
following an index loss; the healthy path costs a single O(1) guard in
`agent-shell-ui-update-fragment' and never reaches the walk."
  (when-let* ((entry (gethash qualified-id (my/agent-shell-ui--fragment-index-table)))
              (start (map-elt entry :start))
              ((markerp start))
              ((or (not (my/agent-shell-ui--section-marker-valid-p entry 'body))
                   (not (my/agent-shell-ui--section-marker-valid-p entry 'label-left))
                   (not (my/agent-shell-ui--section-marker-valid-p entry 'label-right)))))
    (let ((body-start nil)
          (label-left-start nil)
          (label-right-start nil)
          (pos block-start))
      (while (and pos (< pos block-end))
        (let ((section (get-text-property pos 'agent-shell-ui-section)))
          (pcase section
            ('body (setq body-start pos))
            ('label-left (setq label-left-start pos))
            ('label-right (setq label-right-start pos))))
        (setq pos (next-single-property-change
                   pos 'agent-shell-ui-section nil block-end)))
      (my/agent-shell-ui--index-fragment qualified-id block-start
                                         body-start label-left-start label-right-start))))

(defun my/agent-shell-ui--section-absent-p (qualified-id section)
  "Non-nil when QUALIFIED-ID's verified entry carries no marker for SECTION.
A verified entry (valid start marker) whose SECTION marker is missing
means the section does not exist in the buffer: sections are created
only by `agent-shell-ui--insert-fragment' (which registers them) or by
`my/agent-shell-ui--self-heal-sections', so a verified entry's marker set
is complete.  Callers use this to skip the search fallback, which
cannot succeed for a section the verified entry does not know."
  (when-let* ((entry (my/agent-shell-ui--indexed-entry qualified-id)))
    (not (map-elt entry section))))
(defun my/agent-shell-ui--nearest-range-indexed (property value qid to)
  "Indexed fast path for `agent-shell-ui--nearest-range-matching-property'.
Returns the range for QID when PROPERTY/VALUE are indexed, `:absent'
when a verified entry carries no such section, else nil (fall through
to the original search).  Only `agent-shell-ui-state' and the
body/label-left/label-right `agent-shell-ui-section' values are
indexed; anything else returns nil."
  (pcase property
    ('agent-shell-ui-state
     (when-let* ((match (or (my/agent-shell-ui--indexed-match qid)
                            (save-excursion
                              (goto-char (point-max))
                              (text-property-search-backward
                               'agent-shell-ui-state nil
                               (lambda (_ state)
                                 (equal (map-elt state :qualified-id) qid))
                               t)))))
       (list (cons :start (prop-match-beginning match))
             (cons :end (prop-match-end match)))))
    ('agent-shell-ui-section
     (when (memq value '(body label-left label-right))
       (or (my/agent-shell-ui--indexed-section-match qid value to)
           (and (my/agent-shell-ui--section-absent-p qid value) :absent))))
    (_ nil)))


(with-eval-after-load 'agent-shell-ui
  ;; --- agent-shell-ui--replace-label: tag rewritten labels `fontified'
  ;;     in perf mode.  (Upstream now resolves the block via caller-
  ;;     passed BLOCK-START/BLOCK-END and skips unchanged labels itself
  ;;     -- `agent-shell-ui--label-rendered-p' -- absorbing this patch's
  ;;     earlier index threading and label-skip; only the fontified tag
  ;;     remains ours.) ---

  (el-patch-defun agent-shell-ui--replace-label (qualified-id section new-text block-start block-end)
    "Replace the SECTION region of fragment QUALIFIED-ID with NEW-TEXT.

SECTION is one of `label-left' or `label-right'.  Only the named label
region is rewritten — the other label, the indicator, and the body of
the same block stay untouched, so block tagging and fragment identity
are preserved across label updates.

BLOCK-START and BLOCK-END bound QUALIFIED-ID's block, as the caller
already resolved it.  Labels sit at the top of a block, so searching
down from BLOCK-START lands on one within a few intervals.  Locating the
block here instead meant walking back from `point-max' over everything
below it, and an activity group's header, relabeled on every chunk, sits
above its group's whole accumulated body (issue #757).  BLOCK-END is
read at the point of use, so a marker following the edits made here can
be handed in."
    (when (stringp new-text)
      (when-let* ((region
                   (save-excursion
                     (goto-char block-start)
                     (when-let* ((m (text-property-search-forward
                                     'agent-shell-ui-section section t t)))
                       (when (<= (prop-match-end m) block-end)
                         (cons (prop-match-beginning m)
                               (prop-match-end m))))))
                  ;; Skip the rewrite when the label already renders
                  ;; identically: tool-call updates re-send unchanged
                  ;; status/title labels on every chunk, and the rewrite
                  ;; (delete + insert + re-propertize) is pure waste.  A
                  ;; guard clause returning nil makes the whole `when-let*`
                  ;; short-circuit so the rewrite body never runs.
                  ((not (agent-shell-ui--label-rendered-p
                         new-text section (car region) (cdr region)))))
        (let* ((region-start (car region))
               (region-end (cdr region))
               (state (get-text-property region-start 'agent-shell-ui-state)))
          (delete-region region-start region-end)
          (goto-char region-start)
          (let ((insert-start (point)))
            (insert (agent-shell-ui-make-foldable-text
                     :text new-text
                     :hint "toggle"))
            (let ((insert-end (point)))
              (add-text-properties insert-start insert-end
                                   `(agent-shell-ui-section ,section
                                                            help-echo ,(agent-shell-ui--fragment-help-echo qualified-id)
                                                            read-only t
                                                            front-sticky (read-only)))
              ;; With the markdown renderer disabled (perf mode), nothing
              ;; marks new chars `fontified', so jit-lock would re-fontify
              ;; each rewritten label at the next redisplay.  The real
              ;; renderer marks its own output fontified; mirror that
              ;; here, gated on the same render state so default
              ;; rendering is untouched.
              (el-patch-add
                (when (my/agent-shell/perf-fix--render-off-p)
                  (put-text-property insert-start insert-end 'fontified t)))
              (when state
                (put-text-property insert-start insert-end
                                   'agent-shell-ui-state state))))))))

  ;; --- agent-shell-ui--apply-body-section-properties: in perf mode, tag
  ;;     new body chars `fontified' so jit-lock skips them entirely ---
  ;;
  ;; The streaming append path inserts a chunk and immediately applies
  ;; section properties; every such property change fires
  ;; `after-change-functions' (hence `jit-lock-after-change'), and with
  ;; `font-lock-mode' on, the un-marked chunk gets re-fontified at the
  ;; next redisplay -- font-lock region extension plus the buffer's
  ;; `goto-address-mode' pass -- on every chunk.
  ;; `agent-shell-markdown-replace-markup' already marks its output
  ;; `fontified' (so this never happens with markdown rendering on); perf
  ;; mode replaces the renderer with `#'ignore' and never marks, leaving
  ;; the whole per-chunk cost in place.  Marking here restores the same
  ;; guarantee.  Gated on perf mode so default rendering behavior is
  ;; untouched; re-rendering (prettify, expand) operates on the buffer
  ;; directly and is unaffected by the tag.

  (el-patch-defun agent-shell-ui--apply-body-section-properties (start end qualified-id state body-invisible)
    "Apply body-section text properties to chars in [START, END).
QUALIFIED-ID and STATE feed the help-echo and agent-shell-ui-state
properties.  BODY-INVISIBLE non-nil means the existing body region
is currently hidden (collapsed label-ful fragment); new chars must
match.  Explicit `invisible' assignment overrides any value the
new chars might have inherited via rear-stickiness from preceding
trailing-whitespace chars."
    ;; Each property op below is a no-op on the buffer's text, so it can
    ;; run under `with-silent-modifications' (its documented use): no
    ;; after-change event fires, so jit-lock does no per-chunk dispatch,
    ;; and the `fontified' tag set here is not stripped by
    ;; `jit-lock-after-change' -- the chunk is never re-visited at
    ;; redisplay.  The properties still apply; only their hooks are
    ;; suppressed, and `buffer-modified-p' is preserved.
    (el-patch-wrap 1 0
      (with-silent-modifications
        (add-text-properties start end
                             `(agent-shell-ui-section body
                                                      help-echo ,(agent-shell-ui--fragment-help-echo qualified-id)
                                                      read-only t
                                                      front-sticky (read-only)))))
    ;; With the markdown renderer disabled (perf mode), nothing marks new
    ;; chars `fontified', so jit-lock would re-fontify each streamed
    ;; chunk at the next redisplay.  The real renderer marks its own
    ;; output fontified; mirror that here, gated on the same render
    ;; state so default rendering is untouched.  Silent, so the tag
    ;; survives the chunk's remaining property ops.
    (el-patch-add
      (with-silent-modifications
        (when (my/agent-shell/perf-fix--render-off-p)
          (put-text-property start end 'fontified t))))
    (el-patch-wrap 1 0
      (with-silent-modifications
        (when state
          (put-text-property start end 'agent-shell-ui-state state))))
    (el-patch-wrap 1 0
      (with-silent-modifications
        (put-text-property start end 'invisible (if body-invisible t nil)))))

  ;; --- agent-shell-ui--apply-trailing-whitespace-invisible: silent
  ;;     property op (no after-change event, no fontified strip) ---

  (el-patch-defun agent-shell-ui--apply-trailing-whitespace-invisible (body-start body-end)
    "Hide trailing whitespace within [BODY-START, BODY-END) via invisible property.
Marks the hidden chars `rear-nonsticky' for `invisible' so chars later
inserted at BODY-END don't silently inherit `invisible t' from the
trailing-whitespace tail."
    (save-excursion
      (goto-char body-end)
      (when (re-search-backward "[^ \t\n]" body-start t)
        (forward-char 1)
        (when (< (point) body-end)
          ;; Property-only op: `with-silent-modifications' is the
          ;; documented use for a no-op-on-text change -- no
          ;; after-change event, no jit-lock dispatch, no `fontified'
          ;; strip on the tail.  The invisible property still applies.
          (el-patch-wrap 1 0
            (with-silent-modifications
              (add-text-properties (point) body-end
                                   '(invisible t rear-nonsticky (invisible)))))))))


  ;; --- agent-shell-ui--append-body: scope the per-chunk invisible-clear
  ;;     to the trailing-whitespace tail instead of the whole body ---

  (el-patch-defun agent-shell-ui--append-body (body-range chunk qualified-id _collapsed)
    "Append CHUNK to the body region described by BODY-RANGE.

BODY-RANGE is an alist with `:start' and `:end' marking the existing
body section.  Existing body chars stay in place — `agent-shell-markdown'
frozen tags and per-char faces survive across streaming chunks, no
re-rendering needed.  QUALIFIED-ID is the fragment identifier used to
tag the new chars so the body's section property and help-echo line up
with the rest of the block.

_COLLAPSED is intentionally unused: visibility for new chars is derived
from the current visibility of the existing body, not from caller-supplied
state, because label-less fragments don't follow `state :collapsed'
\(their bodies stay visible regardless of how `:collapsed' was stored)."
    (when (and (stringp chunk) (not (string-empty-p chunk)))
      (let* ((body-start (map-elt body-range :start))
             (body-end (map-elt body-range :end))
             (state (get-text-property (max body-start (1- body-end))
                                       'agent-shell-ui-state))
             (body-invisible (agent-shell-ui--body-invisible-p body-start body-end)))
        ;; Trailing-whitespace invisibility on the old tail may no longer
        ;; apply once the chunk lands -- clear and re-derive.  Only when
        ;; the body is visible; for a hidden body the existing invisible
        ;; spans the whole body and must stay.
        (unless body-invisible
          ;; `invisible' can only sit on the trailing-whitespace tail of
          ;; a visible body (`agent-shell-markdown' never sets it), so
          ;; clearing the tail alone is equivalent to clearing the whole
          ;; body -- without walking its property intervals on every
          ;; chunk.
          (el-patch-swap
            (remove-text-properties body-start body-end '(invisible nil))
            (when (and (< body-start body-end)
                       (eq (get-text-property (1- body-end) 'invisible) t))
              (let ((tail-start (or (previous-single-property-change
                                     body-end 'invisible nil body-start)
                                    body-start)))
                (remove-text-properties tail-start body-end '(invisible nil))))))
        (goto-char body-end)
        (let ((insert-start (point)))
          (insert (agent-shell-ui--indent-text
                   chunk (concat (or (map-elt state :group-indent) "") "  ")))
          (let ((insert-end (point)))
            (agent-shell-ui--apply-body-section-properties
             insert-start insert-end qualified-id state body-invisible)
            (agent-shell-ui--apply-trailing-whitespace-invisible
             body-start insert-end)
            ;; The insert's after-change (real text, not suppressible)
            ;; makes `jit-lock-after-change' strip `fontified' back to
            ;; the line start, wiping the already-streamed body.  In
            ;; perf mode, re-tag the whole body silently so jit-lock
            ;; never re-visits any of it at redisplay.  Property-only,
            ;; so the documented `with-silent-modifications' use
            ;; applies; the tag is uniform, so the interval update
            ;; merges into one run.
            (el-patch-add
              (with-silent-modifications
                (when (my/agent-shell/perf-fix--render-off-p)
                  (put-text-property body-start insert-end 'fontified t))))
            ;; The append finished at INSERT-END -- the body's new end,
            ;; known here and nowhere else cheaply.  Return it so the
            ;; caller skips re-deriving the block end via the index on
            ;; this chunk (padding-end and the returned :block/:body
            ;; ranges reuse it).  The function previously returned nil;
            ;; only the body-edit caller in
            ;; `agent-shell-ui-update-fragment' reads the new value.
            (el-patch-add insert-end))))))

  ;; --- agent-shell-ui--replace-body: return the post-edit body end ---
  ;;
  ;; Same contract as the append-body change: the caller's body-edit
  ;; cond captures the post-edit end once and reuses it, skipping the
  ;; per-chunk index re-derivations.  The function previously returned
  ;; nil; only the body-edit caller reads the new value.

  (el-patch-defun agent-shell-ui--replace-body (body-range new-body qualified-id _collapsed)
    "Replace the body region described by BODY-RANGE with NEW-BODY.

BODY-RANGE is an alist with `:start' and `:end'.  Only the body chars
are touched — the surrounding label, indicator, and padding stay put,
so block-id and section tagging on the rest of the block are preserved.
QUALIFIED-ID is the fragment identifier used to tag the inserted chars.

_COLLAPSED is intentionally unused: visibility on the inserted chars
matches the body's current visibility, not caller-supplied state."
    (let* ((body-start (map-elt body-range :start))
           (body-end (map-elt body-range :end))
           (state (get-text-property (max body-start (1- body-end))
                                     'agent-shell-ui-state))
           (body-invisible (agent-shell-ui--body-invisible-p body-start body-end)))
      (delete-region body-start body-end)
      (goto-char body-start)
      (when (and (stringp new-body) (not (string-empty-p new-body)))
        (let ((trimmed new-body))
          (when (string-prefix-p "\n" trimmed)
            (setq trimmed (string-trim-left trimmed "\n")))
          (when (string-suffix-p "\n\n" trimmed)
            (setq trimmed (concat (string-trim-right trimmed) "\n\n")))
          (let ((insert-start (point)))
            (insert (agent-shell-ui--indent-text
                     (string-remove-prefix "  " trimmed)
                     (concat (or (map-elt state :group-indent) "") "  ")))
            (let ((insert-end (point)))
              (agent-shell-ui--apply-body-section-properties
               insert-start insert-end qualified-id state body-invisible)
              (agent-shell-ui--apply-trailing-whitespace-invisible
               insert-start insert-end)
              ;; The replacement finished at INSERT-END -- the body's new
              ;; end, known here and nowhere else cheaply.  Return it so
              ;; the caller skips re-deriving the block end via the index
              ;; on this chunk.  The empty-new-body case (defensive: the
              ;; caller never sends an empty body) leaves the body
              ;; deleted, so the function returns nil there and the
              ;; caller falls back to its derivation.
              (el-patch-add insert-end)))))))

  (el-patch-cl-defun agent-shell-ui--nearest-range-matching-property (&key property value (predicate t) from to)
    "Return nearest range where PREDICATE is non-nil for PROPERTY and VALUE."
    ;; This shared lookup is the per-chunk hot path: block-range and the
    ;; body/label section lookups each run several buffer searches per
    ;; chunk, O(buffer) per chunk over a session.  Answer from the O(1)
    ;; fragment/section index first: `agent-shell-ui-state' searches
    ;; carry the qualified-id as VALUE, section searches derive it from
    ;; the fragment at FROM/point.  `:absent' means the verified entry
    ;; has no such section (answer nil, skip the search); any other miss
    ;; falls through to the untouched upstream bidirectional search, so
    ;; the index only ever shortcuts an equivalent result.
    (el-patch-add
      (when-let* ((qid (or (and (eq property 'agent-shell-ui-state) value)
                           ;; Section lookups: qid from the fragment at
                           ;; FROM/point (state searches pass the qualified-id
                           ;; as VALUE, so they resolve regardless of point).
                           (map-elt (get-text-property (or from (point)) 'agent-shell-ui-state)
                                    :qualified-id)))
                  (result (my/agent-shell-ui--nearest-range-indexed property value qid to)))
        (cond ((eq result :absent)
               (cl-return-from agent-shell-ui--nearest-range-matching-property nil))
              (result
               (cl-return-from agent-shell-ui--nearest-range-matching-property result)))))
    (save-mark-and-excursion
      (save-restriction
        (when (and from to)
          (narrow-to-region from to))
        (let ((backward-match (or (text-property-search-backward property value predicate)
                                  (progn
                                    (unless (eobp)
                                      (forward-char 1))
                                    (text-property-search-backward property value predicate))))
              (forward-match (text-property-search-forward property value predicate)))
          (when (or backward-match forward-match)
            `((:start . ,(if backward-match
                             (prop-match-beginning backward-match)
                           (prop-match-beginning forward-match)))
              (:end . ,(if forward-match
                           (prop-match-end forward-match)
                         (prop-match-end backward-match)))))))))

  ;; --- agent-shell-ui--group-header-range: index first (group headers
  ;;     are fragments too), forward-from-point-min scan as fallback ---

  (el-patch-defun agent-shell-ui--group-header-range (group-qualified-id)
    "Return (:start :end) of the group header GROUP-QUALIFIED-ID, or nil."
    ;; The group header is looked up on every tool and thought chunk;
    ;; the index answers it in O(1) (headers are fragments, registered
    ;; like any other).  The original forward-from-point-min scan with
    ;; a group-kind check stays as the fallback -- it is the exact
    ;; upstream search, and for a header at the top of the buffer it is
    ;; short, unlike a backward scan from point-max.  The new form is
    ;; the indexed lookup with the same kind check, falling back to the
    ;; upstream scan.

    (el-patch-swap
      (save-mark-and-excursion
        (goto-char (point-min))
        (when-let* ((match (text-property-search-forward
                            'agent-shell-ui-state nil
                            (lambda (_ state)
                              (and (equal (map-elt state :qualified-id) group-qualified-id)
                                   (eq (map-elt state :kind) 'group)))
                            t)))
          (agent-shell-ui--block-range :position (prop-match-beginning match))))
      (or (when-let* ((match (my/agent-shell-ui--indexed-match group-qualified-id))
                      (state (get-text-property (prop-match-beginning match)
                                                'agent-shell-ui-state))
                      ((eq (map-elt state :kind) 'group)))
            (list (cons :start (prop-match-beginning match))
                  (cons :end (prop-match-end match))))
          (save-mark-and-excursion
            (goto-char (point-min))
            (when-let* ((match (text-property-search-forward
                                'agent-shell-ui-state nil
                                (lambda (_ state)
                                  (and (equal (map-elt state :qualified-id) group-qualified-id)
                                       (eq (map-elt state :kind) 'group)))
                                t)))
              (agent-shell-ui--block-range :position (prop-match-beginning match)))))))

  ;; --- agent-shell-ui-delete-fragment: indexed lookup + entry removal ---

  (el-patch-cl-defun agent-shell-ui-delete-fragment (&key namespace-id block-id no-undo)
    "Delete fragment with NAMESPACE-ID and BLOCK-ID.

When NO-UNDO is non-nil, disable undo recording for this operation."
    (save-mark-and-excursion
      (let* ((inhibit-read-only t)
             (buffer-undo-list (if no-undo t buffer-undo-list))
             (qualified-id (format "%s-%s" namespace-id block-id))
             (match
              ;; Index first: the O(1) fragment lookup answers most
              ;; chunks; the backward-from-point-max scan is the exact
              ;; upstream fallback for a stale/missing entry.  The wrap
              ;; trims `or' and the indexed call off the new form to
              ;; recover the upstream search verbatim as the original.
              (el-patch-wrap 2 0
                (or (my/agent-shell-ui--indexed-match qualified-id)
                    (save-mark-and-excursion
                      (goto-char (point-max))
                      (text-property-search-backward
                       'agent-shell-ui-state nil
                       (lambda (_ state)
                         (equal (map-elt state :qualified-id) qualified-id))
                       t))))))
        (when match
          (let ((block-start (prop-match-beginning match))
                (block-end (prop-match-end match)))
            ;; Remove trailing vertical space that's part of the block, but
            ;; stop at the next fragment's content.  The next fragment's
            ;; leading indicator (e.g. the "  " collapse placeholder) is
            ;; whitespace too, so a plain `skip-chars-forward' would swallow
            ;; it and misalign that fragment.  Its chars carry an
            ;; `agent-shell-ui-state', which the inter-block separators do not.
            (goto-char block-end)
            (while (and (not (eobp))
                        (memq (char-after) '(?\s ?\t ?\n))
                        (not (get-text-property (point) 'agent-shell-ui-state)))
              (forward-char 1))
            (setq block-end (point))
            (delete-region block-start block-end)
            ;; The fragment is gone from the buffer; drop its index
            ;; entry so a later update for the same qualified-id doesn't
            ;; trust a stale marker and fall through to a full scan on
            ;; every chunk.

            (el-patch-add
              (remhash qualified-id (my/agent-shell-ui--fragment-index-table))))))))

  ;; --- agent-shell-ui-update-text (user-message echo path): indexed lookup
  ;;     + registration on new entries ---

  (el-patch-cl-defun agent-shell-ui-update-text (&key namespace-id block-id text append create-new no-undo)
    "Update or insert a plain text entry identified by NAMESPACE-ID and BLOCK-ID.

TEXT is the string to insert or append.
When APPEND is non-nil, append TEXT to existing entry.
When CREATE-NEW is non-nil, always create a new entry.
When NO-UNDO is non-nil, disable undo recording."
    (save-mark-and-excursion
      (let* ((inhibit-read-only t)
             (buffer-undo-list (if no-undo t buffer-undo-list))
             (qualified-id (format "%s-%s" namespace-id block-id))
             (props `(agent-shell-ui-state ((:qualified-id . ,qualified-id))
                                           read-only t
                                           front-sticky (read-only)))
             (match
              ;; Index first: the O(1) fragment lookup answers most
              ;; chunks; the backward-from-point-max scan is the exact
              ;; upstream fallback for a stale/missing entry.  The wrap
              ;; trims `or' and the indexed call off the new form to
              ;; recover the upstream search verbatim as the original.
              (el-patch-wrap 2 0
                (or (my/agent-shell-ui--indexed-match qualified-id)
                    (save-mark-and-excursion
                      (goto-char (point-max))
                      (text-property-search-backward
                       'agent-shell-ui-state nil
                       (lambda (_ state)
                         (equal (map-elt state :qualified-id) qualified-id))
                       t))))))
        ;; With the markdown renderer disabled (perf mode), nothing marks
        ;; the appended chars `fontified', so jit-lock would re-fontify
        ;; the user-message echo at the next redisplay.  The real
        ;; renderer marks its own output fontified; mirror that here,
        ;; gated on the same render state so default rendering is
        ;; untouched.
        (el-patch-add
          (when (my/agent-shell/perf-fix--render-off-p)
            (setq props (append props '(fontified t)))))
        (when text
          (cond
           ;; Append to existing entry.
           ((and match (not create-new) append)
            (goto-char (prop-match-end match))
            (insert (apply #'propertize text props))
            (list (cons :block (list (cons :start (prop-match-beginning match))
                                     (cons :end (point))))
                  (cons :padding (list (cons :start (prop-match-beginning match))
                                       (cons :end (point))))))
           ;; Replace existing entry.
           ((and match (not create-new))
            (let ((padding-start (save-excursion
                                   (goto-char (prop-match-beginning match))
                                   (skip-chars-backward "\n")
                                   (point))))
              (delete-region (prop-match-beginning match) (prop-match-end match))
              (goto-char (prop-match-beginning match))
              (insert (apply #'propertize text props))
              (list (cons :block (list (cons :start (prop-match-beginning match))
                                       (cons :end (point))))
                    (cons :padding (list (cons :start padding-start)
                                         (cons :end (point)))))))
           ;; New entry.
           (t
            (goto-char (point-max))
            (let ((padding-start (point)))
              (agent-shell-ui--insert-read-only (agent-shell-ui--required-newlines 2))
              (let ((block-start (point)))
                (insert (apply #'propertize text props))
                ;; New plain-text entries get an index entry so
                ;; update-text appends and deletes locate them in O(1)
                ;; instead of scanning backward from point-max.

                (el-patch-add
                  (my/agent-shell-ui--index-fragment qualified-id block-start))
                (list (cons :block (list (cons :start block-start)
                                         (cons :end (point))))
                      (cons :padding (list (cons :start padding-start)
                                           (cons :end (point)))))))))))))

  ;; --- agent-shell-ui--insert-fragment: register every new block ---

  (el-patch-defun agent-shell-ui--insert-fragment (model qualified-id &optional expanded navigation)
    "Insert fragment from MODEL with QUALIFIED-ID text properties.
EXPANDED determines initial state (default nil for collapsed).
NAVIGATION controls navigability:

 `never' (not navigatable)
 `auto' (navigatable if body and indicator present)
 `always' (always navigatable).

A group header (MODEL `:kind' `group') gets a fold triangle and no body of
its own; its children render below it as separate fragments tagged with its
qualified-id via `:group-qualified-id'.  MODEL `:group-indent' visually
indents a child's header line under its group header."
    (let* ((block-start (point))
           (kind (map-elt model :kind))
           (group (eq kind 'group))
           (group-indent (or (map-elt model :group-indent) ""))
           (group-qualified-id (map-elt model :group-qualified-id))
           (body-indent (concat group-indent "  "))
           (label-left (map-elt model :label-left))
           (label-right (map-elt model :label-right))
           (body (unless group (map-elt model :body)))
           (need-space nil)
           (indicator-start)
           (indicator-end)
           (label-left-start)
           (label-left-end)
           (label-right-start)
           (label-right-end)
           (body-start)
           (body-end)
           (collapsable))

      ;; Insert collapse indicator.  A body (or a group header, whose children
      ;; are its collapsible content) gets a fold triangle; a plain labels-only
      ;; fragment reserves two columns so it aligns and doesn't jump when a
      ;; body arrives later.
      (when-let* ((has-labels (or label-left label-right)))
        (if (or body group)
            (progn
              (setq collapsable (and body has-labels))
              (setq indicator-start (point))
              (insert (agent-shell-ui-make-foldable-text
                       :text (if expanded "▼ " "▶ ")
                       :hint "toggle"))
              (setq indicator-end (point))
              (add-text-properties indicator-start indicator-end
                                   `(agent-shell-ui-section indicator
                                                            read-only t
                                                            front-sticky (read-only))))
          (setq collapsable nil)
          (setq indicator-start (point))
          ;; Reserving the space for expand indicators enables
          ;; aligning columns but also avoids text jumping when
          ;; body arrives later on.
          ;;
          ;; For example:
          ;;
          ;; "   [ completed ] [ read ] Read agent-shell/README.org"
          ;;
          ;; vs
          ;;
          ;; "▼  [ completed ] [ read ] Read agent-shell/README.org"
          (insert "  ") ;; "▶ "
          (setq indicator-end (point))))

      (when label-left
        (setq label-left-start (point))
        (insert (agent-shell-ui-make-foldable-text
                 :text label-left
                 :hint "toggle"))
        (setq label-left-end (point))
        (add-text-properties label-left-start label-left-end
                             `(agent-shell-ui-section label-left
                                                      help-echo ,(agent-shell-ui--fragment-help-echo qualified-id)
                                                      read-only t
                                                      front-sticky (read-only)))
        (setq need-space t))

      (when label-right
        (when need-space
          (insert " "))
        (setq label-right-start (point))
        (insert (agent-shell-ui-make-foldable-text
                 :text label-right
                 :hint "toggle"))
        (setq label-right-end (point))
        (add-text-properties label-right-start label-right-end
                             `(agent-shell-ui-section label-right
                                                      help-echo ,(agent-shell-ui--fragment-help-echo qualified-id)
                                                      read-only t
                                                      front-sticky (read-only))))

      (when body
        (when (or label-left label-right)
          (insert "\n\n"))
        ;; Drop any leading body newlines as newlines are
        ;; already inserted between labels and body.
        (when (string-prefix-p "\n" body)
          (setq body (string-trim-left body "\n")))
        ;; Never leave more than two trailing newlines.
        (when (string-suffix-p "\n\n" body)
          (setq body (concat (string-trim-right body) "\n\n")))
        (setq body-start (point))
        (let ((clean-body (string-remove-prefix "  " body)))
          (insert (agent-shell-ui--indent-text clean-body body-indent)))
        (setq body-end (point))
        (add-text-properties body-start body-end
                             `(agent-shell-ui-section body
                                                      help-echo ,(agent-shell-ui--fragment-help-echo qualified-id)
                                                      read-only t
                                                      front-sticky (read-only))))
    ;; Indent a group child's header line under its group header.  The
    ;; body already carries its own (deeper) `line-prefix' from above.
    ;; A child with neither label has no header line to indent (the
    ;; indicator is only reserved alongside labels), so there is no end
    ;; position and nothing to do.  A tool call carrying only a
    ;; `toolCallId' renders that way: `agent-shell-make-tool-call-label'
    ;; has no status, kind, title or description to work with and returns
    ;; nil for both labels.
    (when-let* (((not (string-empty-p group-indent)))
                (header-end (or label-right-end label-left-end indicator-end)))
      (add-text-properties block-start header-end
                           `(line-prefix ,group-indent wrap-prefix ,group-indent)))
      ;; Include the newlines before the body in the invisible region
      (when collapsable
        (add-text-properties (or label-right-end label-left-end)
                             body-end
                             `(invisible ,(if expanded nil t))))
      ;; Hide trailing whitespace (don't delete) in body using text properties.
      (when body
        (save-mark-and-excursion
          (goto-char body-end)
          (when (re-search-backward "[^ \t\n]" body-start t)
            (forward-char 1)
            (when (< (point) body-end)
              (add-text-properties (point) body-end
                                   '(invisible t))))))
      (put-text-property
       block-start (or body-end label-right-end label-left-end)
       'agent-shell-ui-state (list
                              (cons :qualified-id qualified-id)
                              (cons :kind kind)
                              (cons :group-id group-qualified-id)
                              (cons :group-indent group-indent)
                              (cons :collapsed (not expanded))
                              (cons :navigatable (cond
                                                  ((eq navigation 'never) nil)
                                                  ((eq navigation 'always) t)
                                                  (group t)
                                                  ((eq navigation 'auto)
                                                   (and body indicator-start))
                                                  (t
                                                   ;; Default to auto
                                                   (and body indicator-start))))))
      (put-text-property block-start (or body-end label-right-end label-left-end) 'read-only t)
      (put-text-property block-start (or body-end label-right-end label-left-end) 'front-sticky '(read-only))
      ;; Every new block registers its start (and body/label section
      ;; starts) in the index; without this the per-chunk lookups for
      ;; the block would fall back to full-buffer scans.  In perf mode
      ;; the block is also marked `fontified' so jit-lock skips it at
      ;; the next redisplay (the renderer would otherwise do this; with
      ;; rendering off nothing does).
      ;; The function also now returns the body's end (nil for
      ;; body-less fragments): the body-edit cond in
      ;; `agent-shell-ui-update-fragment' captures it as the post-edit
      ;; block end, skipping the index re-derivation.  The return value
      ;; is a new contract -- upstream returned an incidental
      ;; `put-text-property' result -- and every other caller ignores
      ;; it.
      (el-patch-add
        (my/agent-shell-ui--index-fragment qualified-id block-start
                                           body-start label-left-start label-right-start)
        (when (my/agent-shell/perf-fix--render-off-p)
          (put-text-property block-start (or body-end label-right-end label-left-end)
                             'fontified t))
        ;; Final value: the body end, or nil when the model had no body.
        body-end)))

  ;; --- agent-shell-ui-update-fragment: O(1) block lookup, threaded into
  ;;     the label replacements, index refresh on the existing-block path ---

  (el-patch-cl-defun agent-shell-ui-update-fragment (model &key append create-new on-post-process navigation expanded no-undo)
    "Update or add a fragment using MODEL.

When APPEND is non-nil, append to body instead of replacing.
When CREATE-NEW is non-nil, create new block.
When ON-POST-PROCESS is non-nil, call this function after updating.
When NAVIGATION is `never', block won't be TAB navigatable.
When NAVIGATION is `auto', block is navigatable if non-empty body.
When NAVIGATION is `always', block is always TAB navigatable.
When EXPANDED is non-nil, body will be expanded by default.
When NO-UNDO is non-nil, disable undo recording for this operation.

For existing blocks, the current expansion state is preserved unless overridden.

Updates to existing blocks are applied per section: a body append
inserts the new chunk at the end of the body region without disturbing
already-rendered content, so `agent-shell-markdown' frozen ranges
stay intact and streaming append is O(new-chunk) rather than
O(accumulated-body).  Label-only updates leave the body untouched."
    (let* ((window (get-buffer-window (current-buffer)))
           (saved-window-start (and window (window-start window))))
      (unwind-protect
          (save-mark-and-excursion
            (let* ((inhibit-read-only t)
                   (buffer-undo-list (if no-undo t buffer-undo-list))
                   (namespace-id (map-elt model :namespace-id))
                   (qualified-id (format "%s-%s" namespace-id (map-elt model :block-id)))
                   (new-label-left (map-elt model :label-left))
                   (new-label-right (map-elt model :label-right))
                   (new-body (map-elt model :body))
                   (group-member-id (map-elt model :group-id))
                   (effective-expanded (if (eq (map-elt model :kind) 'group)
                                           (map-elt model :expanded)
                                         expanded))
                   (block-start nil)
                   (padding-start nil)
                   (padding-end nil)
                   (group-header nil)
                   (match
                    ;; Index first: the O(1) fragment lookup answers most
                    ;; chunks; the backward-from-point-max scan is the exact
                    ;; upstream fallback for a stale/missing entry.  The wrap
                    ;; trims `or' and the indexed call off the new form to
                    ;; recover the upstream search verbatim as the original.
                    (el-patch-wrap 2 0
                      (or (my/agent-shell-ui--indexed-match qualified-id)
                          (save-mark-and-excursion
                            (goto-char (point-max))
                            (text-property-search-backward
                             'agent-shell-ui-state nil
                             (lambda (_ state)
                               (equal (map-elt state :qualified-id) qualified-id))
                             t))))))
              ;; header (auto-create) and routes into the group's region.  An
              ;; EXISTING member keeps whatever group it already belongs to;
              ;; an update must never create a header or re-route, otherwise a
              ;; caller whose group-id advanced (e.g. a message streamed between
              ;; a tool call and its completion) would spawn an empty group.
              ;; Either way the resolved parent qualified-id and indent are
              ;; recorded on the model so insertion and body regeneration nest.
              (cond
               ((and match (not create-new))
                (when-let* ((state (get-text-property (prop-match-beginning match)
                                                      'agent-shell-ui-state))
                            (existing-group (map-elt state :group-id)))
                  (setq model (append model
                                      (list (cons :group-qualified-id existing-group)
                                            (cons :group-indent
                                                  (or (map-elt state :group-indent) "  ")))))))
               (group-member-id
                (setq group-header (agent-shell-ui--insert-group-header
                                    :namespace-id namespace-id
                                    :group-id group-member-id
                                    :group-label (map-elt model :group-label)
                                    :expanded (map-elt model :group-expanded)
                                    :navigation navigation))
                (setq model (append model
                                    (list (cons :group-qualified-id (map-elt group-header :qualified-id))
                                          (cons :group-indent "  "))))))
              (when (or new-label-left new-label-right new-body)
                (cond
                 ;; Existing block -- apply edits per changed section.
                 ((and match (not create-new))
                  (let* ((state (get-text-property (prop-match-beginning match)
                                                   'agent-shell-ui-state))
                         (collapsed (map-elt state :collapsed))
                         ;; NEW-BODY-END: the body's end after this chunk's
                         ;; edit, returned by the edit functions below
                         ;; (append-body/replace-body: insert-end;
                         ;; insert-fragment: body-end) and captured so
                         ;; padding-end and the returned ranges reuse it
                         ;; instead of re-deriving the block end via the
                         ;; index.  nil until the body edit runs.
                         (el-patch-add (new-body-end nil)))
                    (setq block-start (prop-match-beginning match))
                    ;; The branch-entry match may have come from the
                    ;; search fallback after an index miss (e.g. a block
                    ;; recreated by delete-and-regenerate).  Only then
                    ;; does the entry need re-registering; a valid
                    ;; entry's marker already tracks the block (markers
                    ;; follow edits), so skip the redundant per-chunk
                    ;; `copy-marker'.  A freshly-created entry also needs
                    ;; its section markers discovered once (self-heal)
                    ;; so the section lookups stay O(1) instead of
                    ;; searching every chunk.
                    (el-patch-add
                      (unless (my/agent-shell-ui--indexed-entry qualified-id)
                        (my/agent-shell-ui--index-fragment qualified-id block-start)
                        (my/agent-shell-ui--self-heal-sections
                         qualified-id block-start (prop-match-end match))))
                    (save-excursion
                      (goto-char block-start)
                      (skip-chars-backward "\n")
                      (setq padding-start (point)))
                    ;; Thread the branch-entry block bounds (O(1) indexed,
                    ;; or the search fallback) into the label rewrite, as
                    ;; the new `agent-shell-ui--replace-label' contract
                    ;; expects caller-resolved BLOCK-START/BLOCK-END.

                    (when new-label-left
                      (agent-shell-ui--replace-label
                       qualified-id 'label-left new-label-left
                       (el-patch-add block-start (prop-match-end match))))
                    (when new-label-right
                      ;; The label-left replacement above may have changed the
                      ;; block's length, moving label-right past the stale end
                      ;; of the branch-entry match.  `agent-shell-ui--replace-label'
                      ;; bounds its section search by that end; a stale
                      ;; end silently drops the label-right update for this
                      ;; chunk.  Re-derive the block from the index (O(1)) for
                      ;; the bounds.
                      (agent-shell-ui--replace-label
                       qualified-id 'label-right new-label-right
                       (el-patch-add block-start
                                     (prop-match-end (or (my/agent-shell-ui--indexed-match qualified-id)
                                                         match)))))
                    ;; The body edit's three branches each return the
                    ;; post-edit body end (append-body/replace-body:
                    ;; insert-end; insert-fragment: body-end).  Capture it
                    ;; as NEW-BODY-END so padding-end and the returned
                    ;; ranges reuse it instead of re-deriving the block
                    ;; end via the index on every chunk.  The wrap's
                    ;; original is the bare `when' form (trimming `setq'
                    ;; and `new-body-end' recovers upstream), so the
                    ;; when/let*/cond text appears once.
                    (el-patch-wrap 2 0
                      (setq new-body-end
                        (when new-body
                          ;; Re-derive the block extent and body range here,
                          ;; after the label replacements.  `agent-shell-ui--replace-label'
                          ;; can change a label's length, which shifts everything
                          ;; below it -- a range captured before the replacements
                          ;; would point at the wrong chars (e.g. handing
                          ;; `replace-body' a stale range corrupts the body
                          ;; boundary and leaks its content past the collapse).
                          (let* ((current-block-end
                                  (or (map-elt (agent-shell-ui--block-range :position block-start)
                                               :end)
                                      (prop-match-end match)))
                                 (existing-body-range
                                  (agent-shell-ui--nearest-range-matching-property
                                   :property 'agent-shell-ui-section :value 'body
                                   :from block-start
                                   :to current-block-end)))
                            (cond
                             ;; Append to existing body -- preserves rendered content.
                             ((and append existing-body-range)
                              (agent-shell-ui--append-body
                               existing-body-range new-body qualified-id collapsed))
                             ;; Replace existing body in place.
                             (existing-body-range
                              (agent-shell-ui--replace-body
                               existing-body-range new-body qualified-id collapsed))
                             ;; Body arriving for the first time on a labels-only
                             ;; block -- fall back to delete-and-regenerate so the
                             ;; indicator transitions from placeholder to triangle
                             ;; and the labels↔body separator is inserted.  Labels
                             ;; are recovered from the buffer (no cache).
                             (t
                              (let* ((existing-labels
                                      (agent-shell-ui--read-fragment-labels
                                       block-start current-block-end))
                                     (final-model
                                      (list (cons :namespace-id namespace-id)
                                            (cons :block-id (map-elt model :block-id))
                                            (cons :label-left
                                                  (or new-label-left
                                                      (map-elt existing-labels :label-left)))
                                            (cons :label-right
                                                  (or new-label-right
                                                      (map-elt existing-labels :label-right)))
                                            (cons :body new-body)
                                            ;; Preserve group membership + indent so
                                            ;; the regenerated member stays nested.
                                            (cons :group-qualified-id
                                                  (map-elt model :group-qualified-id))
                                            (cons :group-indent
                                                  (map-elt model :group-indent)))))
                                (delete-region block-start current-block-end)
                                (goto-char block-start)
                                (agent-shell-ui--insert-fragment
                                 final-model qualified-id (not collapsed) navigation))))))))
                    (setq padding-end
                          (or (el-patch-add new-body-end)
                              (when-let* ((block-range
                                           (agent-shell-ui--block-range :position block-start)))
                                (map-elt block-range :end))
                              (point)))))
                 ;; New group member, inserted into the group's region.  The
                 ;; group's trailing separator (after the header) already sits
                 ;; below, so no trailing newlines are added here.
                 ((map-elt model :group-qualified-id)
                  (goto-char (agent-shell-ui--group-insertion-point
                              :group-qualified-id (map-elt model :group-qualified-id)))
                  (setq padding-start (point))
                  (agent-shell-ui--insert-read-only (agent-shell-ui--required-newlines 2))
                  (setq block-start (point))
                  (agent-shell-ui--insert-fragment model qualified-id effective-expanded navigation)
                  ;; The group's trailing separator (the header's `\n\n', inserted
                  ;; once) now sits right after this last member; fold it into
                  ;; this member's padding so it is not stranded outside every
                  ;; block's range.
                  (skip-chars-forward "\n")
                  (setq padding-end (point)))
                 ;; New block.
                 (t
                  (goto-char (point-max))
                  (setq padding-start (point))
                  (agent-shell-ui--insert-read-only (agent-shell-ui--required-newlines 2))
                  (setq block-start (point))
                  (agent-shell-ui--insert-fragment model qualified-id effective-expanded navigation)
                  (agent-shell-ui--insert-read-only "\n\n")
                  (setq padding-end (point)))))
              ;; A collapsed group's members must stay hidden across updates.
              ;; A member's own edit path (insert, or replace-label/body on an
              ;; update) restores visibility from the member's own state, which
              ;; would reveal it under a folded header; re-apply the group
              ;; collapse so updates don't leak members onto the header line.
              (when-let* ((group-qid (map-elt model :group-qualified-id))
                          (header (agent-shell-ui--group-header-range group-qid))
                          (header-state (get-text-property (map-elt header :start)
                                                           'agent-shell-ui-state))
                          ((map-elt header-state :collapsed)))
                (agent-shell-ui--set-group-collapsed group-qid t))
              (when on-post-process
                (funcall on-post-process))
              (when-let* ((block-range
                           ;; Body-edit chunks (existing block with a body:
                           ;; MATCH non-nil, CREATE-NEW nil, NEW-BODY
                           ;; non-nil -- all bound here): PADDING-END was
                           ;; set from the edit's known end, so reuse it
                           ;; instead of re-deriving via the index.  The
                           ;; fallback (the upstream derivation) covers
                           ;; label-only and new-block chunks.
                           (el-patch-swap
                             (agent-shell-ui--block-range :position block-start)
                             (or (and match (not create-new) new-body
                                      (list (cons :start block-start)
                                            (cons :end padding-end)))
                                 (agent-shell-ui--block-range :position block-start)))))
                (list (cons :block block-range)
                      (cons :body (agent-shell-ui--nearest-range-matching-property
                                   :property 'agent-shell-ui-section :value 'body
                                   :from (map-elt block-range :start)
                                   :to (map-elt block-range :end)))
                      (cons :label-left (agent-shell-ui--nearest-range-matching-property
                                         :property 'agent-shell-ui-section :value 'label-left
                                         :from (map-elt block-range :start)
                                         :to (map-elt block-range :end)))
                      (cons :label-right (agent-shell-ui--nearest-range-matching-property
                                          :property 'agent-shell-ui-section :value 'label-right
                                          :from (map-elt block-range :start)
                                          :to (map-elt block-range :end)))
                      (cons :padding (when (and padding-start padding-end)
                                       (list (cons :start padding-start)
                                             (cons :end padding-end))))
                      (cons :group-header (map-elt group-header :range))))))
        (when window
          (set-window-start window saved-window-start t))))))

;;;; 1b. Group-header relabel gating -- always-on pure optimization
;;
;; `agent-shell--refresh-activity-group-header' runs on every tool and
;; thought chunk.  The recomputed label
;; usually equals the one already rendered -- only status/title changes
;; alter it -- so cache the label and the above-last-prompt placement per
;; group in the state alist and skip the whole fragment update when
;; neither changed.

(defun my/agent-shell/perf-fix--group-header-cache-changed-p (state group-id label)
  "Non-nil when GROUP-ID's header needs relabeling: its label or
above-last-prompt placement differs from what's cached.  Stores the new
values before answering so the cache tracks the rendered header."
  (let* ((above-last-prompt (not (agent-shell--active-requests-p state)))
         (labels (or (map-elt state :group-header-labels)
                     ;; `map-put!' refuses new keys on an alist
                     ;; (map-not-inplace); append the pair in place so
                     ;; the cache survives across calls.
                     (let ((cache (make-hash-table :test 'equal)))
                       (setcdr (last state)
                               (list (cons :group-header-labels cache)))
                       cache)))
         (cached (gethash group-id labels)))
    (if (and cached
             (equal label (map-elt cached :label))
             (eq above-last-prompt (map-elt cached :above-last-prompt)))
        nil
      (puthash group-id
               (list (cons :label label)
                     (cons :above-last-prompt above-last-prompt))
               labels)
      t)))

(with-eval-after-load 'agent-shell

  (el-patch-defun agent-shell--refresh-activity-group-header (state group-id)
    "Relabel GROUP-ID's header in STATE from its tool calls and thoughts.
Delegates to `agent-shell-activity-group-header-label-function'.
No-op while that function has nothing to summarize (an empty group)."
    (when-let* ((label (funcall agent-shell-activity-group-header-label-function
                                (list (cons :state state)
                                      (cons :group-id group-id))))
                ;; The header is relabeled on every tool and thought
                ;; chunk, but the recomputed label usually equals the one
                ;; already rendered.  Skip the fragment update when
                ;; nothing changed: this clause passes (non-nil) only
                ;; when the helper found the label or its
                ;; above-last-prompt placement different, which is
                ;; exactly when the update would change the screen.
                (el-patch-add
                  ((my/agent-shell/perf-fix--group-header-cache-changed-p state group-id label))))
      (agent-shell--update-fragment
       :state state
       :block-id group-id
       :label-left label
       :above-last-prompt (not (agent-shell--active-requests-p state)))))

  ;; --- agent-shell--update-fragment: silent field-output props ---
  ;;
  ;; The field-output property ops (marking the block/padding as comint
  ;; field output) are property-only; running them under
  ;; `with-silent-modifications' (the documented use for no-op-on-text
  ;; changes) suppresses their after-change events -- no jit-lock
  ;; dispatch, no `fontified' strip on the padding region.  The `field'
  ;; property still applies, so `comint-next-prompt' etc. behave as
  ;; before.

  (el-patch-cl-defun agent-shell--update-fragment (&key state namespace-id block-id label-left label-right
                                             body append create-new navigation expanded
                                             render-body-images above-last-prompt
                                             group-id group-label (group-expanded t))
  "Update fragment in the shell buffer.

Creates or updates existing dialog using STATE's request count as namespace
unless NAMESPACE-ID (rarely needed).  Rely on count is possible.

BLOCK-ID uniquely identifies the block.

Dialog can have LABEL-LEFT, LABEL-RIGHT, and BODY.

Optional flags: APPEND text to existing content, CREATE-NEW block,
NAVIGATION for navigation style, EXPANDED to show block expanded
by default, RENDER-BODY-IMAGES to enable inline image rendering in
body, ABOVE-LAST-PROMPT to land content above the active prompt
instead of after it (typical for notifications arriving out of
turn).  Programmatic fragment updates do not enter undo history.

GROUP-ID nests this block under a collapsible group header, materialized
from GROUP-LABEL on first use (see `agent-shell-ui-make-fragment-model'),
with GROUP-EXPANDED as the group's initial fold state."
  (when label-right
    (setq label-right (string-trim label-right)))
  ;; Convert non-standard multiline single-backtick code spans to fenced
  ;; code blocks so the markdown renderer can recognize them as source
  ;; blocks, but only for labels that start with `.
  (when (and label-right
             (not (string-match-p (rx "```") label-right))
             (string-match-p
              (rx "`" (zero-or-more (not (any "\n`")))
                  "\n")
              label-right))
    (setq label-right
          (replace-regexp-in-string
           (rx "`"
               (group (zero-or-more (not (any "\n`"))) "\n"
                      (*? (seq (zero-or-more (not (any "\n"))) "\n"))
                      (zero-or-more (not (any "\n`"))))
               "`")
           "Snippet\n\n```\n\\1\n```\n"
           label-right)))
  (when-let* (((map-elt state :buffer))
              (viewport-buffer (agent-shell-viewport--buffer
                                :shell-buffer (map-elt state :buffer)
                                :existing-only t))
              ((with-current-buffer viewport-buffer
                 (derived-mode-p 'agent-shell-viewport-view-mode))))
    (with-current-buffer viewport-buffer
      (let ((buffer-undo-list t)
            (inhibit-read-only t)
            (auto-scroll (shell-maker--should-auto-scroll-p)))
        (when-let* ((range (agent-shell-ui-update-fragment
                            (agent-shell-ui-make-fragment-model
                             :namespace-id (or namespace-id
                                               (map-elt state :request-count))
                             :block-id block-id
                             :label-left label-left
                             :label-right label-right
                             :body body
                             :group-id group-id
                             :group-label group-label
                             :group-expanded group-expanded)
                            :navigation navigation
                            :append append
                            :create-new create-new
                            :expanded expanded
                            :no-undo t))
                    (padding-start (map-nested-elt range '(:padding :start)))
                    (padding-end (map-nested-elt range '(:padding :end)))
                    (block-start (map-nested-elt range '(:block :start)))
                    (block-end (map-nested-elt range '(:block :end))))
          ;; Restore point after narrowing to prevent scrolling
          (save-excursion
            ;; Apply markdown to body.
            (save-restriction
              (when-let* ((body-start (map-nested-elt range '(:body :start)))
                          (body-end (map-nested-elt range '(:body :end))))
                (narrow-to-region body-start body-end)
                ;; Skip rendering when body is collapsed; it will be
                ;; rendered on expand via
                ;; `agent-shell-ui-post-expand-fragment-at-point-hook'.
                (unless (agent-shell-ui--body-invisible-p (point-min) (point-max))
                  (agent-shell--render-markdown :render-images render-body-images))))
            ;; Note: For now, we're skipping applying markdown
            ;; on left labels as they currently carry propertized text
            ;; for statuses (ie. boxed).
            ;;
            ;; Apply markdown to right label.
            (save-restriction
              (when-let* ((label-right-start (map-nested-elt range '(:label-right :start)))
                          (label-right-end (map-nested-elt range '(:label-right :end))))
                (narrow-to-region label-right-start label-right-end)
                (agent-shell--render-markdown :render-images nil))))
          (when auto-scroll
            (goto-char (point-max)))))))
  (with-current-buffer (map-elt state :buffer)
    (unless (and (derived-mode-p 'agent-shell-mode)
                 (equal (current-buffer)
                        (map-elt state :buffer)))
      (error "Editing the wrong buffer: %s" (current-buffer)))
    (let* ((buffer-undo-list t)
           (window (get-buffer-window (current-buffer)))
           (auto-scroll (eobp))
           ;; Use a marker to ensure point restoration
           ;; lands point after the inserted text.
           (saved-point (copy-marker (point)))
           (saved-mark (mark t))
           (saved-mark-active mark-active)
           (saved-window-start (and window (window-start window)))
           ;; Caller is asking us to land content above the active
           ;; prompt (typical for notifications arriving after
           ;; `end_turn').  Narrow above the prompt so the fragment
           ;; system inserts there, and flip the prompt-start marker's
           ;; insertion-type so it advances past the new text rather
           ;; than ending up stranded inside it.  Anchor on the
           ;; prompt-start so unsubmitted typed input is pushed down with
           ;; the prompt.  Falls back to the normal in-line path when no
           ;; live input prompt sits at the buffer end.
           (late-prompt-start (and above-last-prompt
                                   comint-last-prompt
                                   (marker-position (car comint-last-prompt))
                                   (agent-shell--live-input-prompt-p comint-last-prompt)
                                   (car comint-last-prompt)))
           (orig-insertion-type (and late-prompt-start
                                     (marker-insertion-type late-prompt-start))))
      (when late-prompt-start
        (set-marker-insertion-type late-prompt-start t))
      (unwind-protect
       (save-restriction
        (when late-prompt-start
          (narrow-to-region (point-min) (marker-position late-prompt-start)))
        (shell-maker-with-auto-scroll-edit
         (when-let* ((range (agent-shell-ui-update-fragment
                             (agent-shell-ui-make-fragment-model
                              :namespace-id (or namespace-id
                                                (map-elt state :request-count))
                              :block-id block-id
                              :label-left label-left
                              :label-right label-right
                              :body body
                              :group-id group-id
                              :group-label group-label
                              :group-expanded group-expanded)
                             :navigation navigation
                             :append append
                             :create-new create-new
                             :expanded expanded
                             :no-undo t))
                   (padding-start (map-nested-elt range '(:padding :start)))
                   (padding-end (map-nested-elt range '(:padding :end)))
                   (block-start (map-nested-elt range '(:block :start)))
                   (block-end (map-nested-elt range '(:block :end))))
         (save-restriction
           ;; TODO: Move this to shell-maker?
           (let ((inhibit-read-only t))
             ;; comint relies on field property to
             ;; derive `comint-next-prompt'.
             ;; Marking as field output to avoid false positives in
             ;; `agent-shell-next-item' and `agent-shell-previous-item'.
             (el-patch-wrap 1 0
               (with-silent-modifications
                 (add-text-properties (or padding-start block-start)
                                      (or padding-end block-end) '(field output))))
             ;; Same for group header (mark as field output).
             (when (map-elt range :group-header)
               (el-patch-wrap 1 0
                 (with-silent-modifications
                   (add-text-properties (map-nested-elt range '(:group-header :start))
                                        (map-nested-elt range '(:group-header :end))
                                        '(field output)))))
             ;; Apply markdown to body.  `inhibit-read-only' must
             ;; wrap the render call too — chars in the body carry
             ;; `read-only t' from `agent-shell-ui--insert-fragment',
             ;; and `agent-shell-markdown' modifies buffer chars
             ;; (unlike the overlay renderer which only adds overlays).
             (when-let* ((body-start (map-nested-elt range '(:body :start)))
                         (body-end (map-nested-elt range '(:body :end))))
               (narrow-to-region body-start body-end)
               ;; Skip rendering when body is collapsed; it will be
               ;; rendered on expand via
               ;; `agent-shell-ui-post-expand-fragment-at-point-hook'.
               (unless (agent-shell-ui--body-invisible-p (point-min) (point-max))
                 (agent-shell--render-markdown))
               (widen))
             ;;
             ;; Note: For now, we're skipping applying markdown
             ;; on left labels as they currently carry propertized text
             ;; for statuses (ie. boxed).
             ;;
             ;; Apply markdown to right label.
             (when-let* ((label-right-start (map-nested-elt range '(:label-right :start)))
                         (label-right-end (map-nested-elt range '(:label-right :end))))
               (narrow-to-region label-right-start label-right-end)
               (agent-shell--render-markdown :render-images nil)
               (widen))))
         (run-hook-with-args 'agent-shell-section-functions range))))
       (when late-prompt-start
         (set-marker-insertion-type late-prompt-start orig-insertion-type)))
      ;; Late-arrival inserts run under a narrow that ends at
      ;; `comint-last-prompt'.  The auto-scroll branch of
      ;; `shell-maker-with-auto-scroll-edit' goes to the narrowed
      ;; `point-max' (= prompt-start position), leaving point stranded
      ;; on the prompt's first char after the narrowing is dropped.
      ;; When the user was at absolute eob (i.e. in the input area),
      ;; restore them there instead.
      (when (and late-prompt-start auto-scroll)
        (goto-char (point-max)))
      (unless auto-scroll
        (goto-char saved-point)
        (when saved-mark
          (set-marker (mark-marker) saved-mark))
        (setq mark-active saved-mark-active)
        (when window
          (set-window-start window saved-window-start t)))
      (set-marker saved-point nil))))
)



;;;; 2. Perf-fix toggle -- user-space feature tradeoffs

;; Performance mode: `tl/agent-shell-perf-fix-toggle', ON by default.
;;   - markdown rendering off (raw text, no per-chunk passes)
;;   - activity groups expanded (skips the per-chunk group-collapse
;;     re-derivation, part of the fragment-search hot spot)
;;   - busy indicator off (no 10 Hz heartbeat redraw)
;;   - shell-maker auto-scroll off (a plain `disable' function; the
;;     toggle `advice-add's it as `:around' on enable and
;;     `advice-remove's it on disable -- same name, so re-enabling
;;     replaces cleanly; original restored on disable, verified in
;;     batch)

(defgroup my-agent-shell-perf-fix nil
  "Performance fixes for agent-shell."
  :group 'external)

(defcustom my/agent-shell/perf-fix-default-on t
  "Whether perf mode starts enabled when this file is loaded.
Set this before the file loads (e.g. in init.el) to start with perf
mode off; the toggle command flips it at runtime."
  :type 'boolean
  :group 'my-agent-shell-perf-fix)

(defcustom my/agent-shell/perf-fix-prettify-on-turn-complete t
  "Prettify the turn's final agent message on `turn-complete'.
Only effective while perf mode is on (markdown rendering disabled), so
the final message gets the default rendered look without any per-chunk
render cost during the turn."
  :type 'boolean
  :group 'my-agent-shell-perf-fix)

(defcustom my/agent-shell/perf-fix-prettify-images t
  "Whether prettify renders (and fetches) remote images in bodies.
Matches the package default rendering, which passes `render-images' t
for bodies; nil leaves remote image markup as links and never fetches."
  :type 'boolean
  :group 'my-agent-shell-perf-fix)


;; The toggle owns the auto-scroll advice: a plain function, added as
;; `:around' on enable and removed on disable.  No load-time
;; `:override' -- `my/mk-toggle' applies `:enable' at definition time,
;; so a same-named override would be installed and immediately
;; replaced (advice names are unique per function).
(defun shell-maker--should-auto-scroll-p@disable (&rest _)
  "Disable for performance reasons."
  nil)

;; The toggle's `:init' reads agent-shell defcustoms and its `:enable'
;; writes them, so it must not run until agent-shell has loaded:
;; `my/mk-toggle' applies the initial sequence at definition time.
;; The toplevel `(require 'agent-shell)' above guarantees agent-shell
;; is loaded before this runs, so the after-load fires immediately;
;; keeping the definition deferred is harmless belt-and-suspenders
;; (the toggle is meaningless before a shell exists anyway).
(with-eval-after-load 'agent-shell
  (defvar my/agent-shell/perf-fix--saved nil
    "Original values, captured once by the toggle's `:init'.
With `:initial-p' t the capture happens when agent-shell first loads,
so the pre-perf values are what perf mode restores on disable.")

  (my/mk-toggle my/agent-shell/perf-fix
    :toggle-name tl/agent-shell-perf-fix-toggle
    :initial-p my/agent-shell/perf-fix-default-on
    :init
    (progn
      (unless my/agent-shell/perf-fix--saved
        (setopt my/agent-shell/perf-fix--saved
                `((agent-shell-markdown-render-function . ,agent-shell-markdown-render-function)
                  (agent-shell-activity-group-expand-by-default . ,agent-shell-activity-group-expand-by-default)
                  (agent-shell-show-busy-indicator . ,agent-shell-show-busy-indicator)))))
    :enable
    (progn
      (advice-add 'shell-maker--should-auto-scroll-p
                  :around
                  #'shell-maker--should-auto-scroll-p@disable)
      (setopt agent-shell-markdown-render-function #'ignore
              agent-shell-activity-group-expand-by-default t
              agent-shell-show-busy-indicator nil))
    :disable
    (progn
      (advice-remove 'shell-maker--should-auto-scroll-p
                     #'shell-maker--should-auto-scroll-p@disable)
      (dolist (pair my/agent-shell/perf-fix--saved)
        (set (car pair) (cdr pair))))))

;;;; 3. Prettify -- the toggle's inverse
;;
;; Interactive markdown rendering regardless of perf-mode state: runs the
;; real renderer (`agent-shell-markdown-replace-markup') as if the perf
;; toggle were disabled.  With an active region, prettifies the
;; fragment-block portion of it; with no region, prettifies the whole
;; block at point.

(defun my/agent-shell/prettify--render (start end images)
  "Run the real markdown renderer over START..END.
IMAGES non-nil embeds images.  Already-rendered (frozen) spans are
skipped, so re-rendering is idempotent."
  (save-excursion
    (save-restriction
      (narrow-to-region start end)
      (let ((inhibit-read-only t))
        (agent-shell-markdown-replace-markup
         :render-images images
         :highlight-blocks agent-shell-highlight-blocks
         :image-cache-directory (agent-shell-cache-dir "content"))))))

(defun my/agent-shell/prettify--region (beg end)
  "Prettify the fragment-block runs overlapping BEG..END.
Non-fragment slivers (padding, prompt text, the input area) are left
untouched.  Blocks are rendered last-to-first so earlier positions stay
valid as each render shrinks its text."
  (let ((ranges nil)
        (pos beg))
    (while (< pos end)
      (let* ((run-end (or (next-single-property-change
                           pos 'agent-shell-ui-state nil end)
                          end))
             (state (get-text-property pos 'agent-shell-ui-state)))
        (when (and state (map-elt state :qualified-id))
          (push (cons pos run-end) ranges))
        (setq pos run-end)))
    (if (null ranges)
        (message "No agent-shell fragments in region")
      (dolist (range (nreverse ranges))
        (my/agent-shell/prettify--render (car range) (cdr range)
                                         my/agent-shell/perf-fix-prettify-images)))))

(defun my/agent-shell/prettify--block ()
  "Prettify the fragment block at point.
Renders the body with images (per `my/agent-shell/perf-fix-prettify-images')
and the right label without, mirroring the package's per-chunk passes;
the left label is left untouched, matching the package default, which
never markdown-renders it (it carries caller-propertized status text).
No-op with a message when point is not inside a block."
  (when-let* ((block (agent-shell-ui--block-range :position (point)))
              (qualified-id (map-elt (get-text-property (map-elt block :start)
                                                        'agent-shell-ui-state)
                                     :qualified-id)))
    (let ((sections (list (cons 'label-right (my/agent-shell-ui--indexed-section-match
                                              qualified-id 'label-right))
                          (cons 'body (my/agent-shell-ui--indexed-section-match
                                       qualified-id 'body)))))
      ;; Render later sections first so earlier captured positions stay
      ;; valid as each render shrinks its text.
      (dolist (section (reverse sections))
        (when-let* ((range (cdr section)))
          (my/agent-shell/prettify--render (map-elt range :start)
                                           (map-elt range :end)
                                           (and (eq (car section) 'body)
                                                my/agent-shell/perf-fix-prettify-images)))))))

(defun tl/agent-shell-prettify (&optional beg end)
  "Render markdown as if perf mode were disabled.

With an active region (or explicit BEG/END), prettifies the
fragment-block portion of the region; without one, prettifies the whole
fragment block at point (works on collapsed blocks: the body is hidden,
not gone, so it still renders -- including image fetches per
`my/agent-shell/perf-fix-prettify-images').  Runs the real
markdown renderer (`agent-shell-markdown-replace-markup'), bypassing the
perf-mode `#'ignore' render function, whether the toggle is on or off.
Images are rendered in bodies per
`my/agent-shell/perf-fix-prettify-images' (default on, concordance with
the default look); already-rendered (frozen) spans are skipped, so
re-running is idempotent."
  (interactive)
  (if (or (and beg end) (use-region-p))
      (my/agent-shell/prettify--region (or beg (region-beginning))
                                       (or end (region-end)))
    (my/agent-shell/prettify--block)))

;;; 3b. Turn-complete prettify -- prettify the final agent message once,
;;      after the turn, keeping the streaming path raw
;;
;; Perf mode keeps rendering off during the turn (the streaming hot
;; path); this re-enables it for exactly one block once the agent
;; finishes, so the final message gets the default rendered look
;; without any per-chunk cost.  Gated on perf mode being on -- outside
;; perf mode the message was already rendered.  `turn-complete' fires
;; once per agent turn, synchronously, from the request's on-success
;; (agent-shell.el); a subscription is pure event dispatch -- no timer,
;; no polling, zero cost between events.
;;
;; After rendering the shell buffer, the handler ALSO refreshes the
;; associated viewport buffer.  The viewport is a separate buffer (not an
;; indirect buffer) whose copy of the response was left raw during the
;; turn; agent-shell refreshes viewport CONTENT only on explicit
;; navigation -- never on turn-complete (it updates only the header
;; there, agent-shell.el ~line 7613).  Without the refresh the rendered
;; shell buffer is invisible to a user looking at the viewport, the
;; default surface under `agent-shell-prefer-viewport-interaction'.
;; `shell-maker--command-and-response-at-point' extracts the response
;; with `buffer-substring' (preserves text properties), so the rendered
;; faces carry over.

(defun my/agent-shell/perf-fix--prettify-last-message (event)
  "Prettify the turn's final agent message, when the turn finished normally.
Locates the last `agent_message_chunk' fragment and prettifies it via
`my/agent-shell/prettify--block'.  Thoughts use `agent_thought_chunk' and tool
calls their toolCallId as block-id, so the scan can only match real
messages.  No-op unless the turn ended normally -- an interrupted,
token-limited turn leaves a partial message that stays raw -- and
`my/agent-shell/perf-fix-prettify-on-turn-complete' is non-nil and the
buffer is in perf mode.  OMP's `omp acp' reports a normal finish as the
stop-reason `stop' (not the ACP-canonical `end_turn'); both are accepted
so the gate also holds under a canonical-ACP backend.

This handler runs in the comint shell buffer (its `turn-complete'
subscription is registered from `agent-shell-mode-hook').  After
rendering the shell buffer's final message it ALSO refreshes the
associated viewport buffer: the viewport is a separate buffer whose
copy of the response was left raw during the turn (perf mode kept
rendering off), and agent-shell refreshes viewport CONTENT only on
explicit navigation -- never on turn-complete (it updates only the
header there).  Without this refresh the rendered shell buffer is
invisible to a user looking at the viewport, which is the default
surface under `agent-shell-prefer-viewport-interaction'."
  (when (and my/agent-shell/perf-fix-prettify-on-turn-complete
             (my/agent-shell/perf-fix--render-off-p)
             (member (map-nested-elt event '(:data :stop-reason))
                     '("stop" "end_turn")))
    (let ((shell-buffer (current-buffer)))
      (save-excursion
        (goto-char (point-max))
        (when-let* ((match (text-property-search-backward
                            'agent-shell-ui-state nil
                            (lambda (_ state)
                              (and state
                                   (string-match-p "agent_message_chunk"
                                                   (or (map-elt state :qualified-id) ""))))
                            t))
                    (block (agent-shell-ui--block-range
                            :position (prop-match-beginning match))))
          (goto-char (map-elt block :start))
          ;; Call `prettify--block' directly: `prettify' would honor an
          ;; active region and prettify the user's selection instead of
          ;; the turn's final message.
          (my/agent-shell/prettify--block)))
      ;; The viewport mirrors the shell's response but is never
      ;; refreshed on turn-complete (only its header is).  Re-extract
      ;; the now-rendered response so the viewport shows it;
      ;; `shell-maker--command-and-response-at-point' preserves text
      ;; properties, so the rendered faces carry over.  Skip edit mode
      ;; (mid-compose) and a missing viewport.
      (when-let* ((viewport-buffer (agent-shell-viewport--buffer
                                     :shell-buffer shell-buffer
                                     :existing-only t)))
        (with-current-buffer viewport-buffer
          (when (derived-mode-p 'agent-shell-viewport-view-mode)
            (agent-shell-viewport-refresh)
            ;; `refresh' leaves point at the top; the user was watching
            ;; the stream at the bottom, so reseat at the end and follow
            ;; in any visible viewport window.
            (goto-char (point-max))
            (when-let* ((win (get-buffer-window viewport-buffer)))
              (set-window-point win (point-max))
              (with-selected-window win (recenter -1)))))))))

(defun my/agent-shell/perf-fix--subscribe-turn-complete ()
  "Subscribe this shell buffer's `turn-complete' to the prettify handler."
  (agent-shell-subscribe-to
   :shell-buffer (current-buffer)
   :event 'turn-complete
   :on-event #'my/agent-shell/perf-fix--prettify-last-message))

(add-hook 'agent-shell-mode-hook #'my/agent-shell/perf-fix--subscribe-turn-complete)

;;; my-agent-shell-perf-fix.el ends here


(provide 'my-agent-shell-perf-fix)

