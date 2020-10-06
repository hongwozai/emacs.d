;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'evil)
(require-package 'evil-leader)
(require-package 'evil-surround)
(require-package 'evil-matchit)

;;-------------------------------------------
;;; configure
;;-------------------------------------------
(setq evil-move-cursor-back t)
(setq evil-want-C-u-scroll nil)
(setq evil-symbol-word-search t)
(setq evil-lookup-func (lambda () (call-interactively #'man)))
;;; leader
(setq evil-leader/leader ",")
(setq evil-leader/no-prefix-mode-rx
      '("magit-.*-mode" "ibuffer-mode"))

;;-------------------------------------------
;;; startup
;;-------------------------------------------
(evil-mode t)
(global-evil-leader-mode t)
(global-evil-matchit-mode t)
(global-evil-surround-mode t)

;;-------------------------------------------
;;; command
;;-------------------------------------------
(evil-ex-define-cmd "ls" 'ibuffer)
(evil-ex-define-cmd "nu" 'linum-mode)

;;; ed backward
(define-key evil-ex-completion-map (kbd "C-b") 'backward-char)

;;; evil search
(define-key isearch-mode-map (kbd "SPC")
  (lambda () (interactive)
    (setq isearch-message (concat isearch-message ".*?"))
    (setq isearch-string (concat isearch-string ".*?"))
    (isearch-push-state)
    (isearch-update)))

;; for M-. find definiation
(define-key evil-normal-state-map
  (kbd "M-.") (global-key-binding (kbd "M-.")))

;;; related file
(define-key evil-normal-state-map (kbd "gF") 'ff-find-related-file)

;;; use isearch
(define-key evil-normal-state-map (kbd "/") 'evil-search-forward)
(define-key evil-normal-state-map (kbd "?") 'evil-search-backward)

;;; message buffer
(with-current-buffer "*Messages*"
  (evil-leader-mode)
  (evil-local-set-key 'normal (kbd "q") 'quit-window))

;;-------------------------------------------
;;; eval args
;;-------------------------------------------
;; bind evil-args text objects
(define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
(define-key evil-outer-text-objects-map "a" 'evil-outer-arg)

;; bind evil-forward/backward-args
(define-key evil-normal-state-map (kbd "M-l") 'evil-forward-arg)
(define-key evil-normal-state-map (kbd "M-h") 'evil-backward-arg)
(define-key evil-motion-state-map (kbd "M-l") 'evil-forward-arg)
(define-key evil-motion-state-map (kbd "M-h") 'evil-backward-arg)
;;-------------------------------------------
;;; functions
;;-------------------------------------------
(defalias 'core/leader-set-key 'evil-leader/set-key)
(defalias 'core/leader-set-key-for-mode 'evil-leader/set-key-for-mode)

(defmacro core/set-key (keymap &key state &rest bindings)
  "set MODE to global -> global-set-key/evil-global-set-key"
  (declare (indent defun))
  ;; evil
  (if (not (eq (nth 1 state) 'native))
      `(evil-define-key ,state
         ,(if (eq keymap 'global) ''global keymap)
         ,@bindings)
    ;; native
    (let ((stat '()))
      (while bindings
        (push (let ((key (car bindings))
                    (bind (cadr bindings)))
                (setq bindings (cddr bindings))
                (if (eq keymap 'global)
                    ;; global
                    `(global-set-key ,key ,bind)
                  ;; mode
                  `(define-key ,keymap ,key ,bind)))
              stat))
      (push 'progn stat)
      stat)))

(provide 'core-vim)
