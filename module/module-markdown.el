;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'markdown-mode)

(setq markdown-command "pandoc")
(add-hook 'markdown-mode-hook 'visual-line-mode)

(setq auto-mode-alist
      (append
       ;; markdown-mode
       '(("\\.md\\'" . markdown-mode)
         ("README\\'" . markdown-mode)
         ("readme\\'" . markdown-mode)
         ("readme\\.txt\\'" . markdown-mode)
         ("README\\.txt\\'" . markdown-mode))))

;;; C-c C-c l on-the-fly preview
;;; C-c C-s C/q/
