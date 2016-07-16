;;; ======================= evil-anzu =============================
(with-eval-after-load 'evil
  (global-anzu-mode)
  (require 'evil-anzu))

;;; ======================= evil matchit ===========================
(global-evil-matchit-mode 1)

;;; ======================= evil surround ==========================
(global-evil-surround-mode 1)
(setcdr (assoc ?t evil-surround-pairs-alist)
        (lambda () (let ((str (read-from-minibuffer "" ""))) (cons str str))))

;;; ======================= evil iedit state =======================
(autoload 'evil-iedit-state/iedit-mode "evil-iedit-state")

(global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode)
(with-eval-after-load 'iedit
  (global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode))

(with-eval-after-load 'evil-iedit-state
  (define-key evil-iedit-insert-state-map
      (kbd "C-;") 'evil-iedit-state/quit-iedit-mode)
  (define-key evil-iedit-state-map
      (kbd "C-;") 'evil-iedit-state/quit-iedit-mode))

(provide 'init-evil-plugin)
