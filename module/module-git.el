;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'magit)
(require-package 'git-gutter)
(require-package 'git-messenger)
(require-package 'git-timemachine)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(global-git-gutter-mode t)

(add-hook 'git-timemachine-mode-hook
          (lambda ()
            (core/set-key git-timemachine-mode-map
              :state 'motion
              (kbd "n") 'git-timemachine-show-next-revision
              (kbd "p") 'git-timemachine-show-previous-revision
              (kbd "q") 'git-timemachine-quit)
            (evil-motion-state)))

;;-------------------------------------------
;;; key
;;-------------------------------------------
(defhydra hydra-git (:color red :hint nil)
  "
   Hunk: _n_ext _p_rev _s_tage _r_evert _d_iff
"
  ("n" git-gutter:next-hunk)
  ("p" git-gutter:previous-hunk)
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("d" git-gutter:popup-hunk)
  ("q" nil :exit t))
