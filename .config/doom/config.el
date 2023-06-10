(map! :map evil-window-map "SPC" #'rotate-layout
      ;; Navigation
      "<left>"     #'evil-window-left
      "<down>"     #'evil-window-down
      "<up>"       #'evil-window-up
      "<right>"    #'evil-window-right
      ;; Swapping windows
      "C-<left>"       #'+evil/window-move-left
      "C-<down>"       #'+evil/window-move-down
      "C-<up>"         #'+evil/window-move-up
      "C-<right>"      #'+evil/window-move-right)

;; Disable default keybindings for window switching
(global-set-key (kbd "C-j") nil)

;; Define custom functions to switch to different windows
(defun switch-to-right-window ()
  (interactive)
  (other-window 1))

(defun switch-to-left-window ()
  (interactive)
  (other-window -1))

(defun switch-to-up-window ()
  (interactive)
  (windmove-up))

(defun switch-to-down-window ()
  (interactive)
  (windmove-down))

;; Bind the custom functions to the respective key combinations
(global-set-key (kbd "C-l") 'switch-to-right-window)
(global-set-key (kbd "C-h") 'switch-to-left-window)
(global-set-key (kbd "C-k") 'switch-to-up-window)

;; Define a custom function to create a new vertical window
(defun create-vertical-window ()
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

;; Bind the custom function to the new key combination
(global-set-key (kbd "C-S-n") 'create-vertical-window)

;; Define a custom function to close the current window
(defun close-current-window ()
  (interactive)
  (delete-window)
  (balance-windows))

;; Bind the custom function to the new key combination
(global-set-key (kbd "C-S-w") 'close-current-window)
(delq! t custom-theme-load-path)

(setq doom-theme 'doom-ayu-mirage)
;; Commented out bcs doesn't make difference
;;(map! :leader
;;      :desc "Load new theme" "h t" #'counsel-load-theme)

(setq bookmark-default-file "~/.config/doom/bookmarks")
(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-set
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

(setq doom-font (font-spec :family "JetBrains Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 15)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

(map! :leader
      (:prefix ("e" . "open file")
       :desc "Edit repeaters file"   "r" #'(lambda () (interactive) (find-file "~/documents/Org/repeaters.org"))
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/documents/Org/agenda.org"))
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit inbox file"       "i" #'(lambda () (interactive) (find-file "~/documents/Org/inbox.org"))
       :desc "Edit projects file"    "p" #'(lambda () (interactive) (find-file "~/documents/Org/projects.org"))
       :desc "Edit emacs cheatsheet" "s" #'(lambda () (interactive) (find-file "~/workspace/dotfiles/.config/doom/README.org"))))

(after! org
  (setq org-emphasis-alist
  '(("*" (bold :slant italic :weight black ))
    ("/" (italic :foreground "dark salmon" ))
    ("_" (underline :foreground "cyan" ))
    ("=" (:foreground "slate blue" ))
    ("~" (:foreground "dim gray" ))   ;; Other colors could be: snow1, PaleGreen1
    ("+" (:strike-through nil :foreground "PaleGreen1" )))))

;; Define the custom function to surround the word with asteriks.
(defun surround-with-bold ()
  (interactive)
  (when (evil-visual-state-p) ;; Enter visual mode
    (let ((region-start (region-beginning))
          (region-end (region-end)))
    (goto-char region-end)
    (insert "*")
    (goto-char region-start)
    (insert "*"))))

;; Map the custom function to "m" key while in visual mode
(eval-after-load 'org
     (define-key evil-visual-state-map (kbd "m") 'surround-with-bold))

;; Define the custom function to surround the word with slashes.
(defun surround-with-italic ()
  (interactive)
  (when (evil-visual-state-p) ;; Enter visual mode
    (let ((region-start (region-beginning))
          (region-end (region-end)))
    (goto-char region-end)
    (insert "/")
    (goto-char region-start)
    (insert "/"))))

;; Map the custom function to "/" key while in visual mode
(define-key evil-visual-state-map (kbd "/") 'surround-with-italic)

;; Define the custom function to surround the word with pluses.
(defun surround-with-green ()
  (interactive)
  (when (evil-visual-state-p) ;; Enter visual mode
    (let ((region-start (region-beginning))
          (region-end (region-end)))
    (goto-char region-end)
    (insert "+")
    (goto-char region-start)
    (insert "+"))))

;; Map the custom function to "." key while in visual mode
(define-key evil-visual-state-map (kbd ".") 'surround-with-green)

(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :config
  (setq org-modern-star '("◉" "○" "◆" "●" "○" "◆" "●")
        org-modern-list '((45 . "➤")
                          (43 . "–")
                          (42 . "•"))
        org-list-demote-modify-bullet '(("+" . "-") ("-" . "*") ("*" . "+") ("1." . "a."))
        org-modern-table-vertical 1
        org-modern-table-horizontal 0.2
        org-modern-todo-faces
        '(("TODO" :inverse-video t :inherit org-todo)
          ("PROJ" :inverse-video t :inherit +org-todo-project)
          ("[-]"  :inverse-video t :inherit +org-todo-active)
          ("NEXT" :inverse-video t :inherit +org-todo-active)
          ("DONE" :inverse-video t :inherit +org-todo-cancel)
          ("WAIT" :inverse-video t :inherit +org-todo-onhold)
          ("[?]"  :inverse-video t :inherit +org-todo-onhold))
        org-modern-footnote
        (cons nil (cadr org-script-display))
        org-modern-block-fringe nil
                org-modern-block-name
        '((t . t)
          ("src" "»" "«")
          ("example" "»–" "–«")
          ("quote" "❝" "❞")
          ("export" "⏩" "⏪"))
        org-modern-progress nil
        org-modern-horizontal-rule (make-string 36 ?─)
        ;; Edit org settings
        org-directory "~/documents/Org/"
        org-auto-align-tags nil
        org-export-with-sub-superscripts '{}
        org-export-allow-bind-keywords t
        org-tags-column 0
        org-use-property-inheritance t
        org-catch-invisible-edits 'smart
        org-image-actual-width '(0.9))
        org-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-pretty-entities t

        ;; Agenda styling
        org-agenda-tags-column 0
        org-agenda-block-separator ?─
        org-agenda-time-grid
        '((daily today require-timed)
          (800 1000 1200 1400 1600 1800 2000)
          " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "⭠ now ─────────────────────────────────────────────────")

        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-log-done 'time
        org-hide-emphasis-markers t ;; hides the emphasis markers
        ;; ex. of org-link-abbrev-alist in action
        ;; [[arch-wiki:Name_of_Page][Description]]
        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
          '(("google" . "http://www.google.com/search?q=")
            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
            ("ddg" . "https://duckduckgo.com/?q=")
            ("wiki" . "https://en.wikipedia.org/wiki/"))
        org-table-convert-region-max-lines 20000
  (custom-set-faces! '(org-modern-statistics :inherit org-checkbox-statistics-todo))

;(map! :leader
;      :desc "Org babel tangle" "m B" #'org-babel-tangle)
;(after! org
;  (setq org-directory "~/documents/Org/"
;        org-default-notes-file (expand-file-name "notes.org" org-directory)
;        org-ellipsis " ▼ "
;        org-superstar-headline-bullets-list '("◉" "○" "◆" "●" "○" "◆" "●")
;        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
;        org-log-done 'time
;        org-hide-emphasis-markers t ;; hides the emphasis markers
;        ;; ex. of org-link-abbrev-alist in action
;        ;; [[arch-wiki:Name_of_Page][Description]]
;        org-link-abbrev-alist    ; This overwrites the default Doom org-link-abbrev-list
;          '(("google" . "http://www.google.com/search?q=")
;            ("arch-wiki" . "https://wiki.archlinux.org/index.php/")
;            ("ddg" . "https://duckduckgo.com/?q=")
;            ("wiki" . "https://en.wikipedia.org/wiki/"))
;        org-table-convert-region-max-lines 20000
;        org-todo-keywords         ; This overwrites the default Doom org-todo-keywords
;          '((sequence
;             "INPROGGRESS(i)"     ; A task is in proggress
;             "WAITING(w)"         ; Something is holding up this task
;             "GYM(g)"             ; Things to accomplish at the gym
;             "PROJ(p)")           ; A project that contains other tasks
;             (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
;             (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))) ; The pipe necessary to separate "active" states and "inactive" states

(evil-define-command +evil-buffer-org-new (count file)
  "Creates a new ORG buffer replacing the current window, optionally
   editing a certain FILE"
  :repeat nil
  (interactive "P<f>")
  (if file
      (evil-edit file)
    (let ((buffer (generate-new-buffer "*new org*")))
      (set-window-buffer nil buffer)
      (with-current-buffer buffer
        (org-mode)
        (setq-local doom-real-buffer-p t)))))

(map! :leader
      (:prefix "b"
       :desc "New empty Org buffer" "o" #'+evil-buffer-org-new))

(let ((org-super-agenda-groups
       '(;; Each group has an implicit boolean OR operator between its selectors.
         (:name "Today"  ; Optionally specify section name
                :time-grid t  ; Items that appear on the time grid
                :todo "TODAY")  ; Items that have this TODO keyword
         (:name "Important"
                ;; Single arguments given alone
                :tag "bills"
                :priority "A")
         ;; Set order of multiple groups at once
         (:order-multi (2 (:name "Shopping in town"
                                 ;; Boolean AND group matches items that match all subgroups
                                 :and (:tag "shopping" :tag "@town"))
                          (:name "Food-related"
                                 ;; Multiple args given in list with implicit OR
                                 :tag ("food" "dinner"))
                          (:name "Personal"
                                 :habit t
                                 :tag "personal")
                          (:name "Space-related (non-moon-or-planet-related)"
                                 ;; Regexps match case-insensitively on the entire entry
                                 :and (:regexp ("space" "NASA")
                                               ;; Boolean NOT also has implicit OR between selectors
                                               :not (:regexp "moon" :tag "planet")))))
         ;; Groups supply their own section names when none are given
         (:todo "WAITING" :order 8)  ; Set order of this section
         (:todo ("SOMEDAY" "TO-READ" "CHECK" "TO-WATCH" "WATCHING")
                ;; Show this group at the end of the agenda (since it has the
                ;; highest number). If you specified this group last, items
                ;; with these todo keywords that e.g. have priority A would be
                ;; displayed in that group instead, because items are grouped
                ;; out in the order the groups are listed.
                :order 9)
         (:priority<= "B"
                      ;; Show this section after "Today" and "Important", because
                      ;; their order is unspecified, defaulting to 0. Sections
                      ;; are displayed lowest-number-first.
                      :order 1)
         ;; After the last group, the agenda will display items that didn't
         ;; match any of these groups, with the default order position of 99
         )))
  (org-agenda nil "a"))

(setq org-return-follows-link t
      org-agenda-tags-column 75
      org-deadline-warning-days 30
      org-use-speed-commands t)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(setq org-capture-templates
      '(("t" "Todo" entry (file "~/documents/Org/inbox.org")
         "* TODO %?\n  %i\n  %a")))

(setq org-agenda-files (list
                        "~/documents/Org/inbox.org"
                        "~/documents/Org/projects.org"
                        "~/documents/Org/repeaters.org"))

(setq org-agenda-custom-commands
      '((" " "Agenda"
         ((agenda ""
                  ((org-agenda-span 'day)))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled tasks")
                 (org-agenda-files '("~/documents/Org/inbox.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled project tasks")
                 (org-agenda-files '("~/documents/Org/projects.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))))))))

;; save all org-buffers when todo state changes
;;(advice-add 'org-deadline       :after (func-ignore #'org-save-all-org-buffers))
;;(advice-add 'org-schedule       :after (func-ignore #'org-save-all-org-buffers))
;;(advice-add 'org-store-log-note :after (func-ignore #'org-save-all-org-buffers))
;;(advice-add 'org-todo           :after (func-ignore #'org-save-all-org-buffers))

;; global keyboard shortcuts
;;(global-set-key (kbd "SPC c") #'org-capture)
;;(global-set-key (kbd "SPC a") #'org-agenda)

(setq
   org-fancy-priorities-list '("[A]" "[B]" "[C]")
   org-priority-faces
   '((?A :foreground "#ff6c6b" :weight bold)
     (?B :foreground "#98be65" :weight bold)
     (?C :foreground "#c678dd" :weight bold))
   org-agenda-block-separator 8411)

(setq org-agenda-custom-commands
      '(("v" "A better agenda view"
         ((tags "PRIORITY=\"A\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "High-priority unfinished tasks:")))
          (tags "PRIORITY=\"B\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Medium-priority unfinished tasks:")))
          (tags "PRIORITY=\"C\""
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Low-priority unfinished tasks:")))
          (tags "customtag"
                ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                 (org-agenda-overriding-header "Tasks marked with customtag:")))

          (agenda "")
          (alltodo "")))))

(map! :map org-mode-map
      :nie "M-SPC M-SPC" (cmd! (insert "\u200B")))

(defun +org-export-remove-zero-width-space (text _backend _info)
  "Remove zero width spaces from TEXT."
  (unless (org-export-derived-backend-p 'org)
    (replace-regexp-in-string "\u200B" "" text)))

(after! ox
  (add-to-list 'org-export-filter-final-output-functions #'+org-export-remove-zero-width-space t))

(defun +org-insert-file-link ()
  "Insert a file link.  At the prompt, enter the filename."
  (interactive)
  (insert (format "[[%s]]" (org-link-complete-file))))

(map! :after org
      :map org-mode-map
      :localleader
      "l f" #'+org-insert-file-link)

(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

(defun dt/insert-auto-tangle-tag ()
  "Insert auto-tangle tag in a literate config."
  (interactive)
  (evil-org-open-below 1)
  (insert "#+auto_tangle: t ")
  (evil-force-normal-state))

(map! :leader
      :desc "Insert auto_tangle tag" "i a" #'dt/insert-auto-tangle-tag)

(use-package! org-transclusion
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode))

(use-package! org-pandoc-import
  :after org)

(use-package emojify
  :hook (after-init . global-emojify-mode))

(defun dt/org-colors-oceanic-next ()
  "Enable Oceanic Next colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#6699cc" ultra-bold)
         (org-level-2 1.1 "#c594c5" extra-bold)
         (org-level-3 1.05 "#99c794" bold)
         (org-level-4 1.0 "#fac863" semi-bold)
         (org-level-5 1.1 "#5fb3b3" normal)
         (org-level-6 1.1 "#ec5f67" normal)
         (org-level-7 1.1 "#6699cc" normal)
         (org-level-8 1.1 "#c594c5" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

;; Load dt/org-colors-* theme on startup
(dt/org-colors-oceanic-next)

;;(use-package ox-man)
;;(use-package ox-gemini)

(setq org-journal-dir "~/documents/Org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

(after! org
  (setq org-roam-directory "~/documents/Org/roam/"
        org-roam-graph-viewer "/usr/bin/cachy-browser"))

(map! :leader
      (:prefix ("n r" . "org-roam")
       :desc "Completion at point" "c" #'completion-at-point
       :desc "Find node"           "f" #'org-roam-node-find
       :desc "Show graph"          "g" #'org-roam-graph
       :desc "Insert node"         "i" #'org-roam-node-insert
       :desc "Capture to node"     "n" #'org-roam-capture
       :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))

(map! :leader
      :desc "Switch to perspective NAME"       "DEL" #'persp-switch
      :desc "Switch to buffer in perspective"  "," #'persp-switch-to-buffer
      :desc "Switch to next perspective"       "]" #'persp-next
      :desc "Switch to previous perspective"   "[" #'persp-prev
      :desc "Add a buffer current perspective" "+" #'persp-add-buffer
      :desc "Remove perspective by name"       "-" #'persp-remove-by-name)

(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

(set-face-attribute 'mode-line nil :font "JetBrains Mono-9")
(setq doom-modeline-height 20     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
                                 '(coding-category-undecided coding-category-utf-8))
                           (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
                t)))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(setq-default
 delete-by-moving-to-trash t                      ; Delete files to trash
 window-combination-resize t                      ; take new window space from all other windows (not just current)
 x-stretch-cursor t)                              ; Stretch cursor to the glyph width

(setq undo-limit 80000000                         ; Raise undo-limit to 80Mb
 evil-want-fine-undo t                            ; By default while in insert all changes are one big blob. Be more granular
 auto-save-default t                              ; Nobody likes to loose work, I certainly don't
 truncate-string-elipsis "…"                      ; Unicode ellispis are nicer than "...", and also save /precious/ space
 scroll-margin 2                                  ; It's nice to maintain a little margin
 display-time-default-load-average nil)           ; I don't think I've ever found this useful

(display-time-mode 1)                             ; Enable time in the mode-line

(unless (string-match-p "^Power N/A" (battery))   ; On laptops...
  (display-battery-mode 1))                       ; it's nice to know how much power you have

(global-subword-mode 1)                           ; Iterate through CamelCase words

;; Frame resizing
(add-to-list 'default-frame-alist '(height . 24))
(add-to-list 'default-frame-alist '(width . 80))

;; Pull up prompt for which buffer I want to see after splitting the window
(setq evil-vsplit-window-right t
      evil-split-window-below t)
(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (consult-buffer))

(setq display-line-numbers-type t)
(map! :leader
      :desc "Comment or uncomment lines"      "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines))

(add-hook 'doom-first-buffer-hook
          (defun +abbrev-file-name ()
            (setq-default abbrev-mode t)
            (setq abbrev-file-name (expand-file-name "abbrev.el" doom-private-dir))))

(after! evil
  (setq evil-ex-substitute-global t     ; I like my s/../.. to by global by default
        evil-move-cursor-back nil       ; Don't move the block cursor when toggling insert mode
        evil-kill-on-visual-paste nil)) ; Don't put overwritten text in the kill ring

(after! consult
  (set-face-attribute 'consult-file nil :inherit 'consult-buffer)
  (setf (plist-get (alist-get 'perl consult-async-split-styles-alist) :initial) ";"))

(after! company
  (setq company-idle-delay 0.5
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort)) ;; make aborting less annoying.

(after! marginalia
  (setq marginalia-censor-variables nil)

  (defadvice! +marginalia--anotate-local-file-colorful (cand)
    "Just a more colourful version of `marginalia--anotate-local-file'."
    :override #'marginalia--annotate-local-file
    (when-let (attrs (file-attributes (substitute-in-file-name
                                       (marginalia--full-candidate cand))
                                      'integer))
      (marginalia--fields
       ((marginalia--file-owner attrs)
        :width 12 :face 'marginalia-file-owner)
       ((marginalia--file-modes attrs))
       ((+marginalia-file-size-colorful (file-attribute-size attrs))
        :width 7)
       ((+marginalia--time-colorful (file-attribute-modification-time attrs))
        :width 12))))

  (defun +marginalia--time-colorful (time)
    (let* ((seconds (float-time (time-subtract (current-time) time)))
           (color (doom-blend
                   (face-attribute 'marginalia-date :foreground nil t)
                   (face-attribute 'marginalia-documentation :foreground nil t)
                   (/ 1.0 (log (+ 3 (/ (+ 1 seconds) 345600.0)))))))
      ;; 1 - log(3 + 1/(days + 1)) % grey
      (propertize (marginalia--time time) 'face (list :foreground color))))

  (defun +marginalia-file-size-colorful (size)
    (let* ((size-index (/ (log10 (+ 1 size)) 7.0))
           (color (if (< size-index 10000000) ; 10m
                      (doom-blend 'orange 'green size-index)
                    (doom-blend 'red 'orange (- size-index 1)))))
      (propertize (file-size-human-readable size) 'face (list :foreground color)))))

(map! :leader
      (:prefix ("r" . "registers")
       :desc "Copy to register" "c" #'copy-to-register
       :desc "Frameset to register" "f" #'frameset-to-register
       :desc "Insert contents of register" "i" #'insert-register
       :desc "Jump to register" "j" #'jump-to-register
       :desc "List registers" "l" #'list-registers
       :desc "Number to register" "n" #'number-to-register
       :desc "Interactively choose a register" "r" #'counsel-register
       :desc "View a register" "v" #'view-register
       :desc "Window configuration to register" "w" #'window-configuration-to-register
       :desc "Increment register" "+" #'increment-register
       :desc "Point to register" "SPC" #'point-to-register))

(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)
