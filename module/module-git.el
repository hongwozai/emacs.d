;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'git-commit)
(require-package 'magit)
(require-package 'git-gutter)
(require-package 'git-messenger)
(require-package 'git-timemachine)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq git-gutter:handled-backends '(git svn))

;;; git gutter slow in large file
;; (global-git-gutter-mode t)
(add-hook 'find-file-hook
          (lambda ()
            (when (<= (line-number-at-pos (point-max)) 1500)
              (git-gutter-mode))))

(add-hook 'git-timemachine-mode-hook
          (lambda ()
            (core/set-key git-timemachine-mode-map
              :state 'motion
              (kbd "n") 'git-timemachine-show-next-revision
              (kbd "p") 'git-timemachine-show-previous-revision
              (kbd "q") 'git-timemachine-quit)
            (evil-motion-state)))

;;; git-messenger
(setq git-messenger:show-detail t)

;;-------------------------------------------
;;; key
;;-------------------------------------------
(defhydra hydra-git (:color amaranth :hint nil)
  "
   Hunk: _n_ext _p_rev _s_tage _r_evert _d_iff
"
  ("n" git-gutter:next-hunk)
  ("p" git-gutter:previous-hunk)
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("d" git-gutter:popup-hunk)
  ("q" nil :exit t))

(core/leader-set-key
  "vp" 'git-messenger:popup-message)

;;-------------------------------------------
;;; hacking
;;-------------------------------------------
(with-eval-after-load 'git-messenger
  (defun git-messenger:execute-command (vcs args output)
    (cl-case vcs
      (git (apply 'process-file "git" nil output nil args))
      ;; 此处将LANG=C去掉，但是不知道会不会有什么问题，先使用一段时间
      (svn (apply 'process-file "svn" nil output nil args))
      (hg
       (let ((process-environment (cons
                                   "HGPLAIN=1"
                                   (cons "LANG=utf-8" process-environment))))
         (apply 'process-file "hg" nil output nil args))))))

