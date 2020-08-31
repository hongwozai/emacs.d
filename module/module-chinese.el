;;-------------------------------------------
;;; keybinding
;;-------------------------------------------
(core/leader-set-key
  "cs" 'translate-brief-at-point)

;;-------------------------------------------
;;; windows configure
;;-------------------------------------------
(when (eq system-type 'windows-nt)
  (prefer-coding-system 'gbk)
  (set-language-environment "gbk")
  (set-default-coding-systems 'gbk))

;;-------------------------------------------
;;; translate
;;-------------------------------------------
(require-package 'bing-dict)

(defun translate-brief-at-point ()
  (interactive)
  (let ((word (if (use-region-p)
                  (buffer-substring-no-properties
                   (region-beginning) (region-end))
                (thing-at-point 'word t))))
    (if word
        (bing-dict-brief word)
      (message "No Word."))))

;;-------------------------------------------
;;; input method
;;-------------------------------------------
(require-package 'pyim)
(require-package 'pyim-basedict)

;;; default
(require 'pyim)
(setq default-input-method "pyim")
(setq pyim-default-scheme 'quanpin)

(with-eval-after-load "pyim"
  (require 'pyim-basedict)
  (pyim-basedict-enable)
  (if (require 'posframe nil t)
      (setq pyim-page-tooltip 'posframe)
    (setq pyim-page-tooltip 'popup))
  (setq pyim-page-length 9))

;;-------------------------------------------
;;; emacs sometimes can't reconginze gbk
;;-------------------------------------------
;; set coding config, last is highest priority.
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Recognize-Coding.html#Recognize-Coding
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
(prefer-coding-system 'gb18030)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)

(provide 'module-chinese)