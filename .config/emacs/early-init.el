;;; early-init.el -*- lexical-binding: t; -*-
;; Loaded before package.el and the UI exist. This is where startup cost is
;; *prevented* (not undone later). All startup-critical performance opts live
;; here because config.org is tangled + loaded by init.el *after* this file --
;; putting them in config.org would miss the expensive `org-babel-load-file'
;; tangle phase entirely.

;; ---------------------------------------------------------------------------
;; Garbage collection: defer for the entire startup, then restore a low runtime
;; threshold.  This is the single biggest startup win.  `most-positive-fixnum'
;; means "effectively never collect during boot"; the hook below restores a sane
;; value once startup is done.
;;
;; Runtime threshold is deliberately LOW (8 MB), not high.  A high *runtime*
;; threshold lets the glibc malloc arena balloon -- it never returns freed bytes
;; to the OS, so RSS ratchets up with every GC cycle.  8 MB keeps the arena
;; small and bounds peak via `gc-cons-percentage' (0.1).  (This is why we do NOT
;; use gcmh-mode here: gcmh raises the threshold high while active, which would
;; reintroduce the very RSS growth this config is tuned to avoid.)
;; ---------------------------------------------------------------------------
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 1.0)

(defun tl/reset-gc-after-startup ()
  "Restore a low, latency-friendly GC threshold once startup completes."
  (setq gc-cons-threshold (* 8 1000 1000)   ; 8 MB
        gc-cons-percentage 0.1))
(add-hook 'emacs-startup-hook #'tl/reset-gc-after-startup)

;; ---------------------------------------------------------------------------
;; `file-name-handler-alist' (TRAMP, gzip, archive, etc. handlers) is consulted
;; on every `load'/`require'/`expand-file-name'.  Emacs makes thousands of those
;; calls at startup.  Blank it for boot, restore (merged) once done.  Robust
;; against handlers packages may register during init.
;; ---------------------------------------------------------------------------
(defvar tl/file-name-handlers-saved file-name-handler-alist
  "Snapshot of `file-name-handler-alist' captured in early-init for restoration.")
(setq file-name-handler-alist nil)

(defun tl/restore-file-name-handlers ()
  "Restore `file-name-handler-alist' (merged) after startup."
  (setq file-name-handler-alist
        (delete-dups (append file-name-handler-alist
                             tl/file-name-handlers-saved))))
(add-hook 'emacs-startup-hook #'tl/restore-file-name-handlers)

;; ---------------------------------------------------------------------------
;; Frame: don't reflow the frame when font/tab-bar/scroll-bar metrics change
;; during startup.  Even trivial deltas can cost ~hundreds of ms of redraw on
;; Wayland.  (Default is `tab-bar-lines'; `t' inhibits all implied resizes.
;; Manual/pixelwise resizing by the user is unaffected.)
;; ---------------------------------------------------------------------------
(setq frame-inhibit-implied-resize t)

;; ---------------------------------------------------------------------------
;; Skip the second, case-insensitive pass over `auto-mode-alist'.  Requires that
;; mode rules are properly cased -- the standard ones always are.
;; ---------------------------------------------------------------------------
(setq auto-mode-case-fold nil)

;; ---------------------------------------------------------------------------
;; Elpaca owns package management; keep package.el dormant at startup.
;; ---------------------------------------------------------------------------
(setq package-enable-at-startup nil)
