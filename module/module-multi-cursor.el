;;-------------------------------------------
;;; multi cursor
;;-------------------------------------------
(require-package 'evil-mc)

;;; start evil-mc mode when we need
(core/set-key global
  :state '(normal motion emacs insert)
  (kbd "C-;") 'evil-mc-mode)

;;; grm mark all symbol
;;; grq quit edit

;;; grs start select
;;; grh mark toggle
;;; grr start edit

