;;-------------------------------------------
;;; multi cursor
;;-------------------------------------------
(require-package 'iedit)

;;; start evil-mc mode when we need
(core/set-key global
  :state '(normal motion emacs insert)
  (kbd "C-;") 'iedit-mode)

;;; grm mark all symbol
;;; grq quit edit

;;; grs start select
;;; grh mark toggle
;;; grr start edit

