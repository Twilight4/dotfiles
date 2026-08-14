;;; my-agent-shell-perf-fix.el --- Agent-shell performance fixes -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; Two layers: (1) el-patches of agent-shell/agent-shell-ui that upstream
;; still lacks, and (2) user-space perf toggle + prettify commands.
;;
;; 1. REMAINING EL-PATCHES
;;
;;    Upstream's issue-#757 series absorbed most of what this module
;;    originally patched (the fragment/section index became the block
;;    cache, unchanged labels are skipped by `agent-shell-ui--label-rendered-p',
;;    block bounds are threaded by callers, whole-range field tagging
;;    became `agent-shell--tag-untagged-output's untagged-tail pass, and
;;    append/replace-body return their new range).  What remains:
;;
;;    - FONTIFIED TAGGING (perf mode): with the markdown renderer
;;      disabled (`agent-shell-markdown-render-function' = `ignore'),
;;      nothing marks new chars `fontified', so jit-lock re-fontifies
;;      every streamed chunk at the next redisplay (font-lock region
;;      extension plus the buffer's `goto-address-mode' pass).
;;      `agent-shell-markdown-replace-markup' marks its own output;
;;      these patches mirror that tag, gated on the render state, so
;;      default rendering is untouched:
;;      `agent-shell-ui--apply-body-section-properties',
;;      `agent-shell-ui--append-body', `agent-shell-ui--replace-label',
;;      `agent-shell-ui--insert-fragment', `agent-shell-ui-update-text'.
;;
;;    - SILENT PROPERTY OPS: `agent-shell-ui--apply-body-section-properties'
;;      and `agent-shell-ui--apply-trailing-whitespace-invisible' run
;;      property-only changes per chunk under
;;      `with-silent-modifications' (the documented use): no
;;      after-change event, no jit-lock dispatch, no `fontified' strip.
;;
;;    - GROUP-HEADER GATING (`agent-shell--refresh-activity-group-header'):
;;      the function relabels the activity-group header on every tool
;;      and thought chunk; the recomputed label usually equals the one
;;      already rendered, so the fragment update is skipped unless the
;;      label or the above-last-prompt placement actually changed.
;;
;;    Run `M-x el-patch-validate-all' (or `make check' in .emacs.d, which
;;    also runs the test suite) after any package update.
;;
;; 2. PERF-FIX TOGGLE (user-space, feature tradeoffs)
;;    `tl/agent-shell-perf-fix-toggle', ON by default.
;;    - markdown rendering off (raw text, no per-chunk passes)
;;    - activity groups left at their agent-shell default (collapsed by
;;      default; upstream issue #757's wrote-hidden skip keeps streaming
;;      appends into collapsed groups cheap)
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
`agent-shell-markdown-render-function' to `#'ignore', so that value is
the signal.  The toggle's `:init' also runs on load with perf mode
starting on, so `nil' there means the toggle's initial state was reached."
  (eq agent-shell-markdown-render-function #'ignore))

(el-patch-feature agent-shell-ui)
(el-patch-feature agent-shell)

(with-eval-after-load 'agent-shell-ui

  ;; --- agent-shell-ui--apply-body-section-properties: silent property
  ;;     ops + `fontified' tag in perf mode ---
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

  ;; --- agent-shell-ui--append-body: `fontified' re-tag in perf mode ---

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
        ;; apply once the chunk lands — clear and re-derive.  Only when
        ;; the body is visible; for a hidden body the existing invisible
        ;; spans the whole body and must stay.
        ;;
        ;; `invisible' can only sit on the trailing-whitespace tail of a
        ;; visible body (`agent-shell-markdown' never sets it mid-body), so
        ;; clearing just the tail is equivalent to clearing the whole body
        ;; without walking every property interval on each chunk (the whole
        ;; body grows, so a full clear is O(body) per chunk).
        (unless body-invisible
          (when (and (< body-start body-end)
                     (eq (get-text-property (1- body-end) 'invisible) t))
            (let ((tail-start (or (previous-single-property-change
                                   body-end 'invisible nil body-start)
                                  body-start)))
              (remove-text-properties tail-start body-end '(invisible nil)))))
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
            ;; The body grew by exactly what we inserted, so the caller can
            ;; take the new range from here instead of searching the block's
            ;; accumulated intervals for it again (issue #757).
            (list (cons :start body-start)
                  (cons :end insert-end)))))))

  ;; --- agent-shell-ui--replace-label: tag rewritten labels `fontified'
  ;;     in perf mode (upstream resolves the block via caller-passed
  ;;     BLOCK-START/BLOCK-END and skips unchanged labels itself; only
  ;;     the fontified tag remains ours) ---

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
                  ;; guard clause returning nil makes the whole `when-let*'
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

  ;; --- agent-shell-ui--insert-fragment: `fontified' tag in perf mode ---

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
      ;; With the markdown renderer disabled (perf mode), nothing marks
      ;; the new block's chars `fontified', so jit-lock would re-fontify
      ;; each new block at the next redisplay.  Mirror the renderer's
      ;; tag here, gated on the same render state so default rendering is
      ;; untouched.
      (el-patch-add
        (when (my/agent-shell/perf-fix--render-off-p)
          (put-text-property block-start (or body-end label-right-end label-left-end)
                             'fontified t)))))

  ;; --- agent-shell-ui-update-text (user-message echo path): `fontified'
  ;;     tag in perf mode ---

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
             (match (save-mark-and-excursion
                      (goto-char (point-max))
                      (text-property-search-backward
                       'agent-shell-ui-state nil
                       (lambda (_ state)
                         (equal (map-elt state :qualified-id) qualified-id))
                       t))))
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
                (list (cons :block (list (cons :start block-start)
                                         (cons :end (point))))
                      (cons :padding (list (cons :start padding-start)
                                           (cons :end (point))))))))))))))

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
       :above-last-prompt (not (agent-shell--active-requests-p state))))))

;;;; 2. Perf-fix toggle -- user-space feature tradeoffs

;; Performance mode: `tl/agent-shell-perf-fix-toggle', ON by default.
;;   - markdown rendering off (raw text, no per-chunk passes)
;;   - activity groups left at the agent-shell default (collapsed by default)
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
                  (agent-shell-show-busy-indicator . ,agent-shell-show-busy-indicator)))))
    :enable
    (progn
      (advice-add 'shell-maker--should-auto-scroll-p
                  :around
                  #'shell-maker--should-auto-scroll-p@disable)
      (setopt agent-shell-markdown-render-function #'ignore
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
  (when-let* ((block (agent-shell-ui--block-range :position (point))))
    (let ((sections (list (cons 'label-right (agent-shell-ui--nearest-range-matching-property
                                              :property 'agent-shell-ui-section
                                              :value 'label-right
                                              :from (map-elt block :start)
                                              :to (map-elt block :end)))
                          (cons 'body (agent-shell-ui--nearest-range-matching-property
                                       :property 'agent-shell-ui-section
                                       :value 'body
                                       :from (map-elt block :start)
                                       :to (map-elt block :end))))))
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
