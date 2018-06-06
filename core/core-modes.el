;;-------------------------------------------
;;; mode
;;-------------------------------------------
;; language
(require-package 'lua-mode)
(require-package 'cmake-mode)
(require-package 'php-mode)

;;-------------------------------------------
;;; mode install
;;-------------------------------------------
(setq auto-mode-alist
      (append
       ;; markdown-mode
       '(("\\.md\\'" . markdown-mode)
         ("README\\'" . markdown-mode)
         ("readme\\'" . markdown-mode)
         ("readme\\.txt\\'" . markdown-mode)
         ("README\\.txt\\'" . markdown-mode))
       ;; conf-mode shell-script-mode
       '((".*config\\'" . conf-mode)
         (".*profile\\'" . conf-mode)
         ("ssh.\\{1,2\\}config\\'" . conf-mode)
         ("\\.*rc\\'" . sh-mode)
         ("\\.zsh\\'" . sh-mode)
         ("\\.sh\\'" . sh-mode)
         ("\\.bash\\'" . sh-mode)
         ("\\.bashrc\\'" . sh-mode)
         ("\\.bash_history\\'" . sh-mode)
         ("\\.bash_profile\\'" . sh-mode))
       ;; cmake
       '(("CMakeLists\\.txt\\'" . cmake-mode)
         ("\\.cmake\\'" . cmake-mode))
       ;; log
       '(("\\.log\\'" . log-view-mode))
       auto-mode-alist))

(provide 'core-modes)