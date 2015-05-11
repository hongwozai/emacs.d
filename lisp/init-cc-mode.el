(setq c-default-style "k&r"
      c-basic-offset       4
      indent-tabs-mode     t
      default-tab-with     4)

(setq gdb-many-window t)
(setq gdb-show-main   t)

;; doxymacs
(require 'doxymacs)
(add-hook 'c-mode-common-hook 'doxymacs-mode)

;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))


(defun hong/head-comment ()
  (interactive)
  (insert "/**\n")
  (insert "* @Author: luzeya\n")
  (insert (concat "* @Create: " (format-time-string "%Y/%m/%d" (current-time)) "\n"))
  (insert "* @Description:\n")
  (insert "**/\n"))

(provide 'init-cc-mode)
