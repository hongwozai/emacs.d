;;debug
(setq debug-on-error nil)

;; initial
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Happy learning, you can do it.\n\n")
(setq initial-major-mode 'scheme-mode)

;; surface
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; mode line
(defvar hidden-minor-modes ; example, write your own list of hidden
  '(abbrev-mode            ; minor modes
    auto-fill-function
    flycheck-mode
    flyspell-mode
    paredit-mode
    hs-minor-mode
    eldoc-mode
    helm-mode
    company-search-mode
    company-mode
    undo-tree-mode
    yas-minor-mode
    smooth-scroll-mode))

(defun purge-minor-modes ()
  (interactive)
  (dolist (x hidden-minor-modes nil)
    (let ((trg (cdr (assoc x minor-mode-alist))))
      (when trg
        (setcar trg "")))))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

(provide 'init-utils)
