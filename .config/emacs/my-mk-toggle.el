;;; my-mk-toggle.el --- Define stateful toggle commands  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; `my/mk-toggle' creates an interactive toggle command with lifecycle
;; phases: init, enable, disable, final.  Common one-liner toggles
;; (minor modes, hook additions, display flips) without boilerplate.

;;; Code:

;;;###autoload
(defmacro my/mk-toggle (name &rest plist)
  "Define toggle command NAME/toggle with state variable NAME/active-p.

NAME is a symbol.  The macro defines:
- NAME/active-p — boolean state variable, initialised to :initial-p.
- NAME/toggle   — interactive command that toggles the state
                  (:toggle-name overrides the command's name).

Keyword arguments (plist):
:init FORM       — evaluated before each state transition.
:enable FORM     — evaluated when entering enabled state.
:disable FORM    — evaluated when entering disabled state.
:final FORM      — evaluated after each state transition.
:initial-p VALUE — initial active state (default nil).
:toggle-name SYM — command name override (default NAME/toggle).

Each transition runs: init, enable/disable, final.
At definition time the initial sequence is run to bring the system
into concordance with the initial state."
  (declare (indent 1))
  (let* ((init      (plist-get plist :init))
         (enable    (plist-get plist :enable))
         (disable   (plist-get plist :disable))
         (final     (plist-get plist :final))
         (initial-p (plist-get plist :initial-p))
         (active-var (intern (format "%s/active-p" name)))
         (toggle-fn  (or (plist-get plist :toggle-name)
                         (intern (format "%s/toggle" name))))
         (init-f    (or init '(ignore)))
         (enable-f  (or enable '(ignore)))
         (disable-f (or disable '(ignore)))
         (final-f   (or final '(ignore)))
         (doc (format "Toggle `%s' active state." name))
         (var-doc (format "Non-nil when `%s' is enabled." toggle-fn)))
    `(progn
       (eval-and-compile
         ;; silence: reference to free variable NAME
         (defvar ,name)
         ;; declare only; the init form is applied by the defvar below, so it is
         ;; never evaluated at compile time (it may read a defcustom that is not
         ;; yet bound).
         (defvar ,active-var))
       (defvar ,active-var ,initial-p ,var-doc)
       ,init-f
       (if ,active-var
           (progn ,enable-f ,final-f)
         (progn ,disable-f ,final-f))
       ;; Toggle command
       (defun ,toggle-fn ()
         ,doc
         (interactive)
         (if ,active-var
             ;; was enabled → transition to disabled
             (progn
               ,init-f
               ,disable-f
               ,final-f
               (setq ,active-var nil))
           ;; was disabled → transition to enabled
           (progn
             ,init-f
             ,enable-f
             ,final-f
             (setq ,active-var t)))))))

(provide 'my-mk-toggle)

;;; my-mk-toggle.el ends here

