;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Setting the theme to doom-one
(setq doom-theme 'doom-one)
(map! :leader
      :desc "Load new theme" "h t" #'counsel-load-theme)

;; Bookmark keybinds
(setq bookmark-default-file "~/.config/doom/bookmarks")
(map! :leader
      (:prefix ("b". "buffer")
       :desc "List bookmarks"                          "L" #'list-bookmarks
       :desc "Set bookmark"                            "m" #'bookmark-set
       :desc "Delete bookmark"                         "M" #'bookmark-set
       :desc "Save current bookmarks to bookmark file" "w" #'bookmark-save))

;; Enable global auto revert
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

;; Ibuffer keys
(evil-define-key 'normal ibuffer-mode-map
  (kbd "f c") 'ibuffer-filter-by-content
  (kbd "f d") 'ibuffer-filter-by-directory
  (kbd "f f") 'ibuffer-filter-by-filename
  (kbd "f m") 'ibuffer-filter-by-mode
  (kbd "f n") 'ibuffer-filter-by-name
  (kbd "f x") 'ibuffer-filter-disable
  (kbd "g h") 'ibuffer-do-kill-lines
  (kbd "g H") 'ibuffer-update)

;; Settings related to fonts
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them up
;; and use 'SPC h r f' to refresh your font settings
(setq doom-font (font-spec :family "JetBrains Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 15)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :slant italic)
  '(font-lock-keyword-face :slant italic))

;; Line settings
(setq display-line-numbers-type t)
(map! :leader
      :desc "Comment or uncomment lines"      "TAB TAB" #'comment-line
      (:prefix ("t" . "toggle")
       :desc "Toggle line numbers"            "l" #'doom/toggle-line-numbers
       :desc "Toggle line highlight in frame" "h" #'hl-line-mode
       :desc "Toggle line highlight globally" "H" #'global-hl-line-mode
       :desc "Toggle truncate lines"          "t" #'toggle-truncate-lines))

;; Mardown
(custom-set-faces
 '(markdown-header-face ((t (:inherit font-lock-function-name-face :weight bold :family "variable-pitch"))))
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 1.7))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.6))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.5))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.3))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :height 1.2)))))

;; Modeline (status bar)
(set-face-attribute 'mode-line nil :font "JetBrains Mono-10")
(setq doom-modeline-height 30     ;; sets modeline height
      doom-modeline-bar-width 5   ;; sets right bar width
      doom-modeline-persp-name t  ;; adds perspective name to modeline
      doom-modeline-persp-icon t) ;; adds folder icon next to persp name

;; Open specific file examples
(map! :leader
      (:prefix ("e" . "open file")
       :desc "Edit repeaters file"   "r" #'(lambda () (interactive) (find-file "~/.config/doom/repeaters.org"))
       :desc "Edit agenda file"      "a" #'(lambda () (interactive) (find-file "~/Documents/Org/agenda.org"))
       :desc "Edit doom config.org"  "c" #'(lambda () (interactive) (find-file "~/.config/doom/config.org"))
       :desc "Edit inbox file"       "i" #'(lambda () (interactive) (find-file "~/.config/Org/inbox.org"))
       :desc "Edit projects file"    "p" #'(lambda () (interactive) (find-file "~/.config/Org/projects.org"))
       :desc "Edit eshell aliases"   "a" #'(lambda () (interactive) (find-file "~/.config/doom/eshell/aliases"))))

;; Org mode
(map! :leader
      :desc "Org babel tangle" "m B" #'org-babel-tangle)

;; Super agenda package
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

(after! org
  (setq org-directory "~/Documents/Org/"
        org-default-notes-file (expand-file-name "notes.org" org-directory)
        org-ellipsis " ▼ "
        org-superstar-headline-bullets-list '("◉" "○" "◆" "●" "○" "◆" "●")
        org-superstar-itembullet-alist '((?+ . ?➤) (?- . ?✦)) ; changes +/- symbols in item lists
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
        org-todo-keywords         ; This overwrites the default Doom org-todo-keywords
          '((sequence
             "INPROGGRESS(i)"     ; A task is in proggress 
             "WAITING(w)"         ; Something is holding up this task
             "GYM(g)"             ; Things to accomplish at the gym
             "PROJ(p)")           ; A project that contains other tasks
             (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
             (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)")))) ; The pipe necessary to separate "active" states and "inactive" states

;; This controls the color of bold, italic, underline, verbatim, strikethrough
(after! org 
  (setq org-emphasis-alist
  '(("*" (bold :slant italic :weight black ))
    ("/" (italic :foreground "dark salmon" ))
    ("_" (underline :foreground "cyan" ))
    ("=" (:foreground "deep slate blue" ))
    ("~" (:foreground "dim gray" ))   ;; Other colors could be: snow1, PaleGreen1
    ("+" (:strike-through nil :foreground "dark orange" )))))

;; Org agenda
(setq org-return-follows-link t
      org-agenda-tags-column 75
      org-deadline-warning-days 30
      org-use-speed-commands t)
(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(setq org-capture-templates
      '(("t" "Todo" entry (file "~/Documents/Org/inbox.org")
         "* TODO %?\n  %i\n  %a")))
         
(setq org-agenda-files (list
                        "~/Documents/Org/inbox.org"
                        "~/Documents/Org/projects.org"
                        "~/Documents/Org/repeaters.org"))

(setq org-agenda-custom-commands
      '((" " "Agenda"
         ((agenda ""
                  ((org-agenda-span 'day)))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled tasks")
                 (org-agenda-files '("~/Documents/Org/inbox.org"))
                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled 'deadline))
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Unscheduled project tasks")                                                   
                 (org-agenda-files '("~/Documents/Org/projects.org"))
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
   ;; org-fancy-priorities-list '("[A]" "[B]" "[C]")
   ;; org-fancy-priorities-list '("❗" "[B]" "[C]")
   org-fancy-priorities-list '("🟥" "🟧" "🟨")
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

;; Org-auto-tangle
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
        
;; Emojis
(use-package emojify
  :hook (after-init . global-emojify-mode))

;; Org fonts
(defun dt/org-colors-doom-one ()
  "Enable Doom One colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#51afef" ultra-bold)
         (org-level-2 1.1 "#c678dd" extra-bold)
         (org-level-3 1.05 "#98be65" bold)
         (org-level-4 1.0 "#da8548" semi-bold)
         (org-level-5 1.1 "#5699af" normal)
         (org-level-6 1.1 "#a9a1e1" normal)
         (org-level-7 1.1 "#46d9ff" normal)
         (org-level-8 1.1 "#ff6c6b" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-dracula ()
  "Enable Dracula colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#8be9fd" ultra-bold)
         (org-level-2 1.1 "#bd93f9" extra-bold)
         (org-level-3 1.05 "#50fa7b" bold)
         (org-level-4 1.0 "#ff79c6" semi-bold)
         (org-level-5 1.1 "#9aedfe" normal)
         (org-level-6 1.1 "#caa9fa" normal)
         (org-level-7 1.1 "#5af78e" normal)
         (org-level-8 1.1 "#ff92d0" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-gruvbox-dark ()
  "Enable Gruvbox Dark colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#458588" ultra-bold)
         (org-level-2 1.1 "#b16286" extra-bold)
         (org-level-3 1.05 "#98971a" bold)
         (org-level-4 1.0 "#fb4934" semi-bold)
         (org-level-5 1.1 "#83a598" normal)
         (org-level-6 1.1 "#d3869b" normal)
         (org-level-7 1.1 "#d79921" normal)
         (org-level-8 1.1 "#8ec07c" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-monokai-pro ()
  "Enable Monokai Pro colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#78dce8" ultra-bold)
         (org-level-2 1.1 "#ab9df2" extra-bold)
         (org-level-3 1.05 "#a9dc76" bold)
         (org-level-4 1.0 "#fc9867" semi-bold)
         (org-level-5 1.1 "#ff6188" normal)
         (org-level-6 1.1 "#ffd866" normal)
         (org-level-7 1.1 "#78dce8" normal)
         (org-level-8 1.1 "#ab9df2" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-nord ()
  "Enable Nord colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#81a1c1" ultra-bold)
         (org-level-2 1.1 "#b48ead" extra-bold)
         (org-level-3 1.05 "#a3be8c" bold)
         (org-level-4 1.0 "#ebcb8b" semi-bold)
         (org-level-5 1.1 "#bf616a" normal)
         (org-level-6 1.1 "#88c0d0" normal)
         (org-level-7 1.1 "#81a1c1" normal)
         (org-level-8 1.1 "#b48ead" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

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

(defun dt/org-colors-palenight ()
  "Enable Palenight colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#82aaff" ultra-bold)
         (org-level-2 1.1 "#c792ea" extra-bold)
         (org-level-3 1.05 "#c3e88d" bold)
         (org-level-4 1.0 "#ffcb6b" semi-bold)
         (org-level-5 1.1 "#a3f7ff" normal)
         (org-level-6 1.1 "#e1acff" normal)
         (org-level-7 1.1 "#f07178" normal)
         (org-level-8 1.1 "#ddffa7" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-solarized-dark ()
  "Enable Solarized Dark colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#268bd2" ultra-bold)
         (org-level-2 1.1 "#d33682" extra-bold)
         (org-level-3 1.05 "#859900" bold)
         (org-level-4 1.0 "#b58900" semi-bold)
         (org-level-5 1.1 "#cb4b16" normal)
         (org-level-6 1.1 "#6c71c4" normal)
         (org-level-7 1.1 "#2aa198" normal)
         (org-level-8 1.1 "#657b83" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-solarized-light ()
  "Enable Solarized Light colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#268bd2" ultra-bold)
         (org-level-2 1.1 "#d33682" extra-bold)
         (org-level-3 1.05 "#859900" bold)
         (org-level-4 1.0 "#b58900" semi-bold)
         (org-level-5 1.1 "#cb4b16" normal)
         (org-level-6 1.1 "#6c71c4" normal)
         (org-level-7 1.1 "#2aa198" normal)
         (org-level-8 1.1 "#657b83" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

(defun dt/org-colors-tomorrow-night ()
  "Enable Tomorrow Night colors for Org headers."
  (interactive)
  (dolist
      (face
       '((org-level-1 1.2 "#81a2be" ultra-bold)
         (org-level-2 1.1 "#b294bb" extra-bold)
         (org-level-3 1.05 "#b5bd68" bold)
         (org-level-4 1.0 "#e6c547" semi-bold)
         (org-level-5 1.1 "#cc6666" normal)
         (org-level-6 1.1 "#70c0ba" normal)
         (org-level-7 1.1 "#b77ee0" normal)
         (org-level-8 1.1 "#9ec400" normal)))
    (set-face-attribute (nth 0 face) nil :font doom-variable-pitch-font :weight (nth 3 face) :height (nth 1 face) :foreground (nth 2 face)))
    (set-face-attribute 'org-table nil :font doom-font :weight 'normal :height 1.0 :foreground "#bfafdf"))

;; Load our desired dt/org-colors-* theme on startup
(dt/org-colors-doom-one)

;; Org-export
;;(use-package ox-man)
;;(use-package ox-gemini)

;; Org-journal
(setq org-journal-dir "~/Documents/Org/journal/"
      org-journal-date-prefix "* "
      org-journal-time-prefix "** "
      org-journal-date-format "%B %d, %Y (%A) "
      org-journal-file-format "%Y-%m-%d.org")

;; Org-roam
(after! org
  (setq org-roam-directory "~/Documents/Org/roam/"
        org-roam-graph-viewer "/usr/bin/librewolf"))

(map! :leader
      (:prefix ("n r" . "org-roam")
       :desc "Completion at point" "c" #'completion-at-point
       :desc "Find node"           "f" #'org-roam-node-find
       :desc "Show graph"          "g" #'org-roam-graph
       :desc "Insert node"         "i" #'org-roam-node-insert
       :desc "Capture to node"     "n" #'org-roam-capture
       :desc "Toggle roam buffer"  "r" #'org-roam-buffer-toggle))

;; Perspective
(map! :leader
      :desc "Switch to perspective NAME"       "DEL" #'persp-switch
      :desc "Switch to buffer in perspective"  "," #'persp-switch-to-buffer
      :desc "Switch to next perspective"       "]" #'persp-next
      :desc "Switch to previous perspective"   "[" #'persp-prev
      :desc "Add a buffer current perspective" "+" #'persp-add-buffer
      :desc "Remove perspective by name"       "-" #'persp-remove-by-name)

;; Rainbow-mode
(define-globalized-minor-mode global-rainbow-mode rainbow-mode
  (lambda ()
    (when (not (memq major-mode
                (list 'org-agenda-mode)))
     (rainbow-mode 1))))
(global-rainbow-mode 1 )

;; Registers
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

;; Splits
(defun prefer-horizontal-split ()
  (set-variable 'split-height-threshold nil t)
  (set-variable 'split-width-threshold 40 t)) ; make this as low as needed
(add-hook 'markdown-mode-hook 'prefer-horizontal-split)
(map! :leader
      :desc "Clone indirect buffer other window" "b c" #'clone-indirect-buffer-other-window)
