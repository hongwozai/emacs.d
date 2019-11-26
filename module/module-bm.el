;;-------------------------------------------
;;; bm mode
;;-------------------------------------------
(require-package 'bm)

(require 'bm)

;;; Allow cross buffer `bm-next'
(setq bm-cycle-all-buffers nil)

;;; save and load
(setq bm-restore-repository-on-load t)
(setq-default bm-buffer-persistence t)
(setq bm-repository-file "~/.emacs.d/bm-repository")

;; Loading the repository from file when on start up.
(add-hook 'after-init-hook 'bm-repository-load)
;; Saving bookmarks
(add-hook 'kill-buffer-hook #'bm-buffer-save)

;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when Emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook #'(lambda nil
                               (bm-buffer-save-all)
                               (bm-repository-save)))

;; The `after-save-hook' is not necessary to use to achieve persistence,
;; but it makes the bookmark data in repository more in sync with the file
;; state.
(add-hook 'after-save-hook #'bm-buffer-save)

;; Restoring bookmarks
(add-hook 'find-file-hooks   #'bm-buffer-restore)
(add-hook 'after-revert-hook #'bm-buffer-restore)

;;; mode and keybindings
(evil-set-initial-state 'bm-show-mode 'motion)
(core/set-key bm-show-mode-map
  :state '(motion)
  (kbd "RET") 'bm-show-goto-bookmark)

(defhydra+ mark-board (:color amaranth :hint nil)
  ("b" bm-toggle "bookmark-set" :color blue :column "bookmark")
  ("B" bm-show-all "list-bookmark" :color blue)
  ("l" bm-show "list-bookmark" :color blue)
  ("d" bm-remove-all-current-buffer "remove buffer" :color blue)
  ("D" bm-remove-all-all-buffers "remove all" :color blue)
  ("n" bm-next "next" :column "move")
  ("p" bm-previous "previous" :column "move")
  ("q" nil :exit t)
  )