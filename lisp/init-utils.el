;;debug
(setq debug-on-error nil)
(setq debug-on-quit nil)
(setq ad-redefinition-action 'accept)

;;; initiate gc allocate
(setq-default gc-cons-threshold (* 1024 1024 24)
              gc-cons-percentage 0.5)

;;; common lisp support
(require 'cl)

;;; site-lisp add path
(let ((lisp-dir "~/.emacs.d/site-lisp"))
  (setq load-path
        (append
         (loop for dir in (directory-files lisp-dir)
               unless (string-match "^\\." dir)
               collecting (expand-file-name dir lisp-dir))
         load-path)))

;;; =============================  autoexit ================================
(defun hong/exit ()
  (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process 'hong/exit-prompt))))

(defun hong/exit-prompt (process state)
  (if (string-match "\\(exited\\|finished\\)" state)
      (progn
        (ignore-errors (delete-window (get-buffer-window (process-buffer process))))
        (kill-buffer (process-buffer process)))))
;;; ielm C-c C-d exit
(add-hook 'ielm-mode-hook 'hong/exit)

;;; =========================== pop window ================================
(defun hong-pop (func)
  (select-window (split-window-below))
  (funcall func))

(defun hong-pop-func (func)
  (lexical-let ((fun func))
    (lambda () (interactive) (hong-pop fun))))
;;; ===========================  select window =============================
(defmacro hong/select-buffer-window (cmd buffer-name)
  `(defadvice ,cmd (after ,(gensym) activate)
     (ignore-errors (select-window (get-buffer-window ,buffer-name)))))

(dolist (var '((describe-function . "*Help*")
               (describe-key . "*Help*")
               (describe-mode . "*Help*")
               (describe-coding-system . "*Help*")
               (describe-variable . "*Help*")
               (shell-command . "*Shell Command Output*")
               (list-colors-display . "*Colors*")
               (list-processes . "*Process List*")
               (grep . "*grep*")
               (rgrep . "*grep*")
               (occur . "*Occur*")))
  (eval `(hong/select-buffer-window ,(car var) ,(cdr var))))

;;; ========================= system relevant ==============================
(defun hong-updatedb ()
  "updatedb need by counsel locate"
  (interactive)
  (let ((default-directory "/sudo:root@localhost:/"))
    (message (shell-command-to-string "updatedb"))))

;;; ========================= compatibility ================================
(when (version< emacs-version "24.4")
  (defun set-face-bold (face bold-p &optional frame)
    (set-face-bold-p face bold-p frame))

  (defun set-face-italic (face italic-p &optional frame)
    (set-face-italic-p face italic-p frame)))

;;; ========================= loop find ====================================
(defun hong--loop-find (func)
  (let ((path (if buffer-file-name
                  (file-name-directory buffer-file-name) "/"))
        (go-on t)
        (ret nil))
    (while go-on
      (if (funcall func path)
          (progn (setq go-on nil)
                 (setq ret path))
        (progn
          (setq path (file-name-directory (directory-file-name path)))
          (if (equal path "/")
              (setq go-on nil))
          (setq ret nil))
        ))
    ret))

;;; ========================= overlay ======================================
(defface hong--jump-tags-face
  '((t (:foreground "black" :background "DarkSeaGreen3")))
  "tags jump face"
  :group 'etags)

(defun hong--overlay-display (delay overlay face)
  (overlay-put overlay 'face face)
  (sit-for delay)
  (delete-overlay overlay))

(defun hong--display-current-overlay ()
  (let ((start (line-beginning-position))
        (end (line-end-position)))
    (hong--overlay-display 1
                           (make-overlay start end)
                           'hong--jump-tags-face)))

(defmacro hong--display-line (func)
  `(defadvice ,func (after ,(gensym) activate)
     (hong--display-current-overlay)))

(provide 'init-utils)
