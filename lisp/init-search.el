;;; =================== isearch ======================
;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;; isearch (.*? replace space, use C-q SPC insert SPC)
(define-key isearch-mode-map (kbd "SPC")
  '(lambda () (interactive)
     (setq isearch-message (concat isearch-message ".*?"))
     (setq isearch-string (concat isearch-string ".*?"))
     (isearch-push-state)
     (isearch-update)))

;;; =================== grep =========================
(setq-default grep-hightlight-matches     t
              grep-scroll-output          nil)

(setq grep-command "grep -nH -E -e ")

(with-eval-after-load 'grep
  (setq hong-grep-files-aliases
        '((c-mode . "*.[ch] *.cpp *.hpp *.cc *.C *.cxx")
          (c++-mode . "*.[ch] *.cpp *.hpp *.cc *.C *.cxx")
          (emacs-lisp-mode . "*.el")))

  (defun grep-read-files (regexp)
    (read-string "Search Files: "
                 (let ((str (assoc major-mode hong-grep-files-aliases)))
                   (if str (cdr str) ".*"))))
  )

;;; =================== ag ============================
(when (executable-find "ag")
  (require-package 'ag)
  (require-package 'wgrep-ag)
  (setq-default ag-highlight-search t)
  (setq-default ag-reuse-buffers t)
  (setq-default ag-reuse-window nil)

  (hong/select-buffer-window ag "*ag search*")
  )

;;; =================== occur =========================
;;; occur follow
(defun occur-np (np)
  (lexical-let ((np np))
    (lambda () (interactive)
      (save-selected-window
        (if (eq np 'next) (occur-next) (occur-prev))
        (occur-mode-goto-occurrence-other-window)
        (recenter)))))

(defadvice isearch-occur (after hong/occur-exit-isearch activate)
  (and (ignore-errors (select-window (get-buffer-window "*Occur*")))
       (isearch-exit)))

(add-hook 'occur-mode-hook
          (lambda ()
            (evil-local-set-key 'motion (kbd "e") 'occur-edit-mode)
            (evil-local-set-key 'motion (kbd "n") (occur-np 'next))
            (evil-local-set-key 'motion (kbd "p") (occur-np 'prev))
            (evil-local-set-key 'motion (kbd "RET") #'occur-mode-goto-occurrence-other-window)))

;;; ========================= key bindings ============================
(defhydra hydra-search-menu (:color amaranth :hint nil)
  "
   ^Actions^                  ^Misc^
^^^^^-------------------------------------------------------
  _a_: counsel ag            _A_: ag
  _o_: occur
  _g_: rgrep                 _G_: counsel git grep
  _s_: swiper
^
^
  "
  ("a" counsel-ag :color blue)
  ("A" ag :color blue)
  ("o" occur :color blue)
  ("g" rgrep :color blue)
  ("G" counsel-git-grep :color blue)
  ("s" swiper :color blue)
  ("c" nil "cancel")
  ("q" nil "cancel"))

(provide 'init-search)
