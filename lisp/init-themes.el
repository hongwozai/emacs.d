;; color theme
(require-package 'zenburn-theme)
(load-theme 'zenburn t)

;;; mode-line
(defvar hong/mode-line-normal "#657b83")
(defvar hong/mode-line-inactive "DimGrey")

(custom-theme-set-faces
 'zenburn
 `(mode-line
   ((t (:box (:line-width 1 :color ,hong/mode-line-normal :style nil)
             :foreground "#ffffff" :background ,hong/mode-line-normal
             :overline ,hong/mode-line-normal :inverse-video nil))))
 `(mode-line-inactive
   ((t (:box (:line-width 1 :color "#657b83" :style nil)
             :foreground "#ffffff" :background ,hong/mode-line-inactive
             :overline ,hong/mode-line-inactive :inverse-video nil))))
 )

(provide 'init-themes)
