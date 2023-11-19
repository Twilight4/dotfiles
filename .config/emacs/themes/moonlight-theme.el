;;; moonlight-theme.el --- Custom Moonlight theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
;; Author: Twilight4

(defun darken-color (color percent)
  "Darken COLOR by PERCENT."
  (apply 'color-rgb-to-hex
         (mapcar (lambda (x) (* x (/ (- 100 percent) 100.0)))
                 (color-name-to-rgb color))))

(deftheme doom-moonlight
  "A dark theme inspired by VS code's Moonlight")

(let ((class '((class color) (min-colors 89)))
      ;; Define your color palette here
      (bg         "#212337")
      (bg-alt     "#191a2a")
      (base0      "#161a2a")
      (base1      "#191a2a")
      (base2      "#1e2030")
      (base3      "#222436")
      (base4      "#2f334d")
      (base5      "#444a73")
      (base6      "#828bb8")
      (base7      "#a9b8e8")
      (base8      "#b4c2f0")
      (indigo     "#7a88cf")
      (region     "#383e5c")
      (fg         "#c8d3f5")
      (fg-alt     "#b4c2f0")
      (grey       "#444a73")
      (dark-red   "#ff5370")
      (red        "#ff757f")
      (light-red  "#ff98a4")
      (orange     "#ff995e")
      (green      "#c3e88d")
      (dark-teal  "#4fd6be")
      (teal       "#77e0c6")
      (light-teal "#7af8ca")
      (yellow     "#ffc777")
      (blue       "#82aaff")
      (dark-blue  "#4976eb")
      (light-blue "#50c4fa")
      (light-magenta "#baacff")
      (magenta    "#c099ff")
      (violet     "#f989d3")
      (light-pink "#fca7ea")
      (pink       "#f3c1ff")
      (cyan       "#b4f9f8")
      (dark-cyan  "#86e1fc"))

  (custom-theme-set-faces
   'doom-moonlight
   ;; Customize faces here
   `(default ((,class (:background ,bg :foreground ,fg))))
   `(region ((,class (:background ,region))))
   `(font-lock-comment-face ((,class (:foreground ,indigo))))
   `(font-lock-doc-face ((,class (:foreground ,grey))))
   `(font-lock-keyword-face ((,class (:foreground ,magenta))))
   `(font-lock-constant-face ((,class (:foreground ,orange))))
   `(font-lock-function-name-face ((,class (:foreground ,blue))))
   `(font-lock-string-face ((,class (:foreground ,green))))
   `(font-lock-variable-name-face ((,class (:foreground ,light-red))))
   `(font-lock-type-face ((,class (:foreground ,yellow))))
   `(font-lock-builtin-face ((,class (:foreground ,magenta))))
   `(font-lock-preprocessor-face ((,class (:foreground ,dark-cyan))))
   `(line-number ((,class (:foreground ,base5 :background ,(darken-color bg 6)))))
   `(line-number-current-line ((,class (:foreground ,fg :background ,region))))
   `(mode-line ((,class (:background ,(darken-color base2 10) :foreground ,base8))))
   `(mode-line-inactive ((,class (:background ,(darken-color bg 10) :foreground ,fg-alt))))
   `(tooltip ((,class (:background ,base0 :foreground ,fg))))
   ;; Org mode faces
   `(org-level-1 ((,class (:foreground ,light-blue))))
   `(org-level-2 ((,class (:foreground ,dark-cyan))))
   `(org-level-3 ((,class (:foreground ,light-red))))
   `(org-level-4 ((,class (:foreground ,blue))))
   `(org-level-5 ((,class (:foreground ,magenta))))
   `(org-level-6 ((,class (:foreground ,red))))
   `(org-level-7 ((,class (:foreground ,violet))))
   `(org-level-8 ((,class (:foreground ,yellow))))
   `(org-block ((,class (:background ,base2))))
   `(org-block-background ((,class (:background ,base2))))
   `(org-block-begin-line ((,class (:background ,base2))))
   ;; Add more face customizations as needed
   )

  ;; Additional theme settings
  (setq doom-moonlight-padded-modeline nil) ; Customize as needed

  (provide-theme 'doom-moonlight))

;;; doom-moonlight-theme.el ends here
