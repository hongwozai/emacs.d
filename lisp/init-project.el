;; bookmark
(setq bookmark-save-flag 1)

;;; find-file-in-project
;;; ignore hidden file
(require-package 'find-file-in-project)
(eval-after-load 'find-file-in-project
  '(progn
     (setq ffip-prefer-ido-mode t)
     (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                               "makefile" ".dir-local.el"))
     (add-to-list 'ffip-prune-patterns "*/.*/*")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my open files function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find dirs \( -path 'PATH' -o -path 'PATH' \) -a prune -o
;;; \( -name 'NAME' -o -name 'NAME' -o -path 'PATH' \) -type f -print
(defun hong//build-find-command (&optional file-or-dir need-file
                                           need-dirs ignore-dirs)
  (defun make-brackets (nop list-string &optional bracket)
    (concat (and bracket "\\( ")
            (substring
             (mapconcat (lambda (str) (concat " -" nop  " \"" str "\" -o "))
                        list-string
                        " ")
             0 -3)
            (and bracket "\\) " )))
  ;; build find command
  (concat (and ignore-dirs
               (concat (make-brackets "path" ignore-dirs t)
                       "-a -prune "))
          "-o "
          (and need-file
               (concat "\\("(make-brackets "name" need-file)
                       (and need-dirs
                            (concat " -o " (make-brackets "path" need-dirs)))
                       "\\)"))
          (concat " -type "
                  (if file-or-dir
                      "f" "d")
                  " ")
          " -print "))

(defun hong/find-file-in-dir (dirs &optional command)
  (let* ((dir-string (mapconcat
                      (lambda (str) (file-name-as-directory (expand-file-name str)))
                      dirs " "))
         (prompt-string (concat "Find file in " dir-string ": "))
         (command-string (concat "find -L " dir-string
                                 (concat " " (or command "-type f"))
                                 " 2>/dev/null"))
         (dir-isone (eq (length dirs) 1))
         (dirname-length (length dir-string)))

    (if dir-isone
        (concat dir-string
                (ido-completing-read
                 prompt-string
                 (delq nil
                       (mapcar (lambda (str) (if (< dirname-length (length str))
                                            (substring str dirname-length)
                                          nil))
                               (split-string
                                (shell-command-to-string command-string)
                                "[\n\t\r ]+")))))
      (ido-completing-read
       prompt-string
       (split-string
        (shell-command-to-string command-string)
        "[\n\t\r ]+"))
      )
    ))

(defun hong/open-emacs-configure-file ()
  (interactive)
  (let ((conf "~/.emacs.d/"))
    (find-file
     (hong/find-file-in-dir
      (list conf)
      (hong//build-find-command t '("*.el") '("*/snippets/*") '("*/.git/*"))
      ))))

(defun hong/open-system-configure-file ()
  (interactive)
  (find-file (concat "/sudo:root@localhost:"
                     (hong/find-file-in-dir
                      '("/etc/")
                      (hong//build-find-command t nil nil '("*/.git/*"))))))

;;; C-j instantly find file(when no input, dired)
(setq hong/workspace-directory '("~/workspace/"))

(defun hong/open-workspace-directory ()
  (interactive)
  (let ((cur-workspace
         (hong/find-file-in-dir
          hong/workspace-directory
          (hong//build-find-command nil nil nil
                                    '("*/.*" "*/elpa*")))))
    (find-file
     (hong/find-file-in-dir
      (list cur-workspace)
      (hong//build-find-command t nil nil
                                '("*/.*"))))
    )
  )

(defun hong/open-recentf-file ()
  (interactive)
  (unless recentf-mode
    (recentf-mode 1))
  (find-file
   (ido-completing-read "Find recentf files: "
                        recentf-list))
  )

(defhydra hydra-open-files-menu (:color pink
                                        :pre (message "Please input command")
                                        :hint nil)
  "
    ^Actions^
^^^^^^^^--------------------------------
  _e_: open emacs configure files
  _f_: open project files
  _r_: open recentf files
  _s_: open system configure files
  _w_: open workspace files
  _n_: create files (C-j ok)
^
^
"
  ("e" hong/open-emacs-configure-file :color blue)
  ("f" ffip :color blue)
  ("r" hong/open-recentf-file :color blue)
  ("w" hong/open-workspace-directory :color blue)
  ("n" ido-find-file :color blue)
  ("s" hong/open-system-configure-file :color blue)
  ("c" nil "cancel")
  ("h" split-window-horizontally "horizon window")
  ("v" split-window-below "vertical window")
  ("q" nil "quit" :color blue))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my window function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-window-menu (:color pink
                                    :pre (message "Please input command")
                                    :hint nil)
  "
    ^Windows direction^         ^Window operation^
^^^^^^^^--------------------------------------------------------------
  _h_: left window             _c_: delete this window
  _j_: down window             _o_: delete other window
  _k_: up window               _u_: restore window layout
  _l_: right window            _r_: swap window(rotate updown)
  ^^                           _s_: horizontal window
  ^^                           _v_: vertical window
  "
  ("h" evil-window-left :color blue)
  ("j" evil-window-down :color blue)
  ("k" evil-window-up :color blue)
  ("l" evil-window-right :color blue)
  ("c" evil-window-delete :color blue)
  ("o" delete-other-windows :color blue)
  ("u" winner-undo :color blue)
  ("s" evil-window-split :color blue)
  ("r" evil-window-rotate-downwards :color blue)
  ("v" evil-window-vsplit :color blue)
  ("q" nil "cancel" :color blue))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my buffer, bookmark function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-mark-or-buf-menu (:color pink
                                         :pre (message "Please input command")
                                         :hint nil)
  "
    ^Buffer^                           ^Bookmark^
^^^^^^^^--------------------------------------------------------------
  _l_: ibuffer                      _m_: bookmark menu
  _s_: switch buffer                _n_: new bookmark in current file
  _k_: kill this buffer             _j_: bookmark jump
  _o_: switch buffer other window
  _d_: dired jump
^
^
"
  ("l" ibuffer :color blue)
  ("s" ido-switch-buffer :color blue)
  ("k" kill-this-buffer :color blue)
  ("o" ido-switch-buffer-other-window :color blue)
  ("d" dired-jump :color blue)
  ("m" bookmark-bmenu-list :color blue)
  ("n" bookmark-set :color blue)
  ("j" bookmark-jump :color blue)
  ("c" nil "cancel")
  ("h" split-window-horizontally "horizon window")
  ("v" split-window-below "vertical window")
  ("q" nil "quit"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my help function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defhydra hydra-help-menu (:color pink
                                  :pre (message "Please input command")
                                  :hint nil)
  "
    ^describe^                           ^Misc^
^^^^^^^^--------------------------------------------------------------
  _f_: describe function            _i_: Info
  _k_: describe key                 _l_: list-colors-display
  _v_: describe varibale            _p_: list-process
  _m_: describe mode
  _e_: view-echo-area-messages
  _n_: view-emacs-news
  _h_: help-for-help
^
^
"
  ("f" describe-function :color blue)
  ("k" describe-key :color blue)
  ("v" describe-variable :color blue)
  ("m" describe-mode :color blue)
  ("e" view-echo-area-messages :color blue)
  ("n" view-emacs-news :color blue)
  ("h" help-for-help :color blue)
  ("i" info :color blue)
  ("l" list-colors-display :color blue)
  ("p" list-processes :color blue)
  ("c" nil "cancel")
  ("q" nil "quit"))

(evil-define-key 'motion help-mode-map (kbd "l") 'help-go-back)
(evil-define-key 'motion help-mode-map (kbd "r") 'help-go-forward)

(provide 'init-project)
