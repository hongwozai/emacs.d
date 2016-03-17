;; bookmark
(setq bookmark-save-flag 1)

;;; find-file-in-project
;;; ignore hidden file
(require-package 'find-file-in-project)
(eval-after-load 'find-file-in-project
  '(progn
     (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                               "makefile" ".dir-local.el"))
     (add-to-list 'ffip-prune-patterns "*/.*/*")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my process function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hong/kill-process ()
  (interactive)
  (let ((process
         (delete-if (lambda (str) (equal (if (< (length str) 6)
                                        nil
                                      (substring str 0 6)) "server"))
                    (mapcar #'process-name (process-list)))))
    (if (null process)
        (message "NO PROCESS!")
      (delete-process (get-process
                       (completing-read "Kill Process: " process))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my open files function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find dirs \( -path 'PATH' -o -path 'PATH' \) -a -prune -o
;;; \( -name 'NAME' -o -name 'NAME' -o -path 'PATH' \) -type f -print
(defun hong/open-emacs-configure-file ()
  (interactive)
  (let ((default-directory "~/.emacs.d/"))
    (ffip)))

(defun hong/open-recentf-file ()
  (interactive)
  (unless recentf-mode
    (recentf-mode 1))
  ;; use recentf-list
  (ivy-recentf))

(defun hong/find-file ()
  (interactive)
  (let* ((cmd "find -L . -path '*/.*' -prune -o -type d -print 2>/dev/null")
         (collection (split-string
                      (shell-command-to-string cmd)
                      "\n"))
         (collection-strip
          (if (equal "" (car (last collection)))
              (setq collection (butlast (cdr collection)))
            (setq collection (cdr collection))))
         (len (length collection)))
    (cond
     ((= len 0) (let ((ffip-project-root default-directory)) (ffip)))
     (t
      (ivy-read "Open File: "
                (mapcar (lambda (x) (substring x 2)) collection-strip)
                :action (lambda (dir)
                          (with-ivy-window
                            (let ((ffip-project-root dir))
                              (when dir
                                (ffip)))))
                :require-match t)))))

(defun hong/open-tramp-connections ()
  (interactive)
  (unless (functionp #'tramp-list-connections)
    (require 'tramp))
  (let ((list-conns
         (mapcar (lambda (vec)
                   (format "/%s:%s@%s:"
                           (tramp-file-name-method vec)
                           (tramp-file-name-user vec)
                           (tramp-file-name-host vec)))
                 (tramp-list-connections))))
    (if (null list-conns)
        (message "NO TRAMP CONNECTS!!!")
      (ido-find-file-in-dir (ivy-read "Open Tramp: " list-conns)))))

(defhydra hydra-open-files-menu (:color amaranth :hint nil)
  "
    ^Open^                               ^Misc^
^^^^^^^^------------------------------------------------------------------------
  _e_: emacs configure files       _l_: locate file
  _p_: project files
  _f_: open files
  _t_: ido tramp connection
  _r_: open recentf files
^
^
"
  ("e" hong/open-emacs-configure-file :color blue)
  ("p" ffip :color blue)
  ("f" hong/find-file :color blue)
  ("t" hong/open-tramp-connections :color blue)
  ("r" hong/open-recentf-file :color blue)
  ("l" counsel-locate :color blue)
  ("c" nil "cancel")
  ("h" split-window-horizontally "horizon window")
  ("v" split-window-below "vertical window")
  ("q" nil "quit" :color blue))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my window function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-window-menu (:color amaranth :hint nil)
  "
    ^Windows direction^         ^Window operation^
^^^^^^^^--------------------------------------------------------------
  _h_: left window             _c_: delete this window
  _j_: down window             _o_: delete other window
  _k_: up window               _u_: restore window layout
  _l_: right window            _r_: swap window(rotate updown)
  ^^                           _s_: horizontal window
  ^^                           _v_: vertical window
  ^^                           _t_: window layout change
  "
  ("h" evil-window-left :color blue)
  ("j" evil-window-down :color blue)
  ("k" evil-window-up :color blue)
  ("l" evil-window-right :color blue)
  ("c" evil-window-delete :color blue)
  ("o" delete-other-windows :color blue)
  ("u" winner-undo :color blue)
  ("t" hong/window-layout-change :color blue)
  ("s" evil-window-split :color blue)
  ("r" evil-window-rotate-downwards :color blue)
  ("v" evil-window-vsplit :color blue)
  ("q" nil "cancel" :color blue))

(define-key evil-emacs-state-map (kbd "C-w") 'hydra-window-menu/body)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my buffer, bookmark function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-mark-or-buf-menu (:color amaranth :hint nil)
  "
    ^Buffer^                           ^Bookmark^
^^^^^^^^--------------------------------------------------------------
  _l_: ibuffer                      _m_: bookmark menu
  _d_: dired jump                   _n_: new bookmark in current file
  _o_: switch buffer other window   _j_: bookmark jump
  _s_: set buffer coding
^
^
"
  ("l" ibuffer :color blue)
  ("o" switch-to-buffer-other-window :color blue)
  ("d" dired-jump :color blue)
  ("m" bookmark-bmenu-list :color blue)
  ("s" revert-buffer-with-coding-system :color blue)
  ("n" bookmark-set :color blue)
  ("j" bookmark-jump :color blue)
  ("c" nil "cancel")
  ("h" split-window-horizontally "horizon window")
  ("v" split-window-below "vertical window")
  ("q" nil "quit"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my help function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-help-menu (:color amaranth :hint nil)
  "
    ^describe^                           ^Misc^
^^^^^^^^--------------------------------------------------------------
  _f_: describe function            _i_: Info
  _k_: describe key                 _l_: list-colors-display
  _v_: describe varibale            _p_: list-process
  _m_: describe mode                _a_: apropos
  _e_: view-echo-area-messages
  _n_: view-emacs-news
  _h_: help-for-help
  _S_: info lookup symbol
^
^
"
  ("f" counsel-describe-function :color blue)
  ("k" describe-key :color blue)
  ("v" counsel-describe-variable :color blue)
  ("m" describe-mode :color blue)
  ("e" view-echo-area-messages :color blue)
  ("n" view-emacs-news :color blue)
  ("h" help-for-help :color blue)
  ("S" info-lookup-symbol :color blue)
  ("i" info :color blue)
  ("l" list-colors-display :color blue)
  ("p" hong/kill-process :color blue)
  ("a" apropos :color blue)
  ("c" nil "cancel")
  ("q" nil "quit"))

(evil-define-key 'motion help-mode-map (kbd "l") 'help-go-back)
(evil-define-key 'motion help-mode-map (kbd "r") 'help-go-forward)
(evil-define-key 'motion Info-mode-map (kbd "l") 'Info-history-back)
(evil-define-key 'motion Info-mode-map (kbd "w") 'evil-forward-word-begin)
(evil-define-key 'motion Info-mode-map (kbd "b") 'evil-backward-word-begin)

(provide 'init-project)
