;;; =================== isearch ======================
;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;; isearch (.*? replace space, use C-q SPC insert SPC)
(define-key isearch-mode-map (kbd "SPC")
  '(lambda () (interactive)
     (setq isearch-message (concat isearch-message ".*?"))
     (setq isearch-string (concat isearch-string ".*?"))
     (isearch-update)))

;;; =================== grep =========================
(setq-default grep-hightlight-matches     t
              grep-scroll-output          nil)

(when (executable-find "ag")
  (require-package 'ag)
  (setq-default ag-highlight-search t)
  (setq-default ag-reuse-buffers t)
  (setq-default ag-reuse-window nil)

  (hong/select-buffer-window ag "*ag search*")
  )

;;; =================== occur =========================
;;; occur follow
(defun hong/occur-next-or-prev (next-or-prev)
  (lexical-let ((nop next-or-prev))
    (lambda () (interactive)
      (let ((buf (get-buffer-window (buffer-name))))
        (save-selected-window
          (if (eq nop 'next) (occur-next) (occur-prev))
          (occur-mode-goto-occurrence-other-window)
          (recenter)
          (hong--display-current-overlay))))))

(defadvice isearch-occur (after hong/occur-exit-isearch activate)
  (and (ignore-errors (select-window (get-buffer-window "*Occur*")))
       (isearch-exit)))

(add-hook 'occur-mode-hook
          (lambda ()
            (define-key evil-motion-state-local-map (kbd "n")
              (hong/occur-next-or-prev 'next))
            (define-key evil-motion-state-local-map (kbd "p")
              (hong/occur-next-or-prev 'prev))
            (define-key evil-motion-state-local-map (kbd "RET")
              #'occur-mode-goto-occurrence-other-window)))

(defun hong/multi-occur-same-major-mode ()
  (interactive)
  (defun hong//common-mode-buffers (the-mode)
    (delq nil (mapcar (lambda (buf)
                        (when (buffer-live-p buf)
                          (with-current-buffer buf
                            (and (eq major-mode the-mode)
                                 buf))))
                      (buffer-list))))
  (multi-occur (hong//common-mode-buffers major-mode)
               (read-regexp "Collect strings matching regexp: "))
  (select-window (get-buffer-window "*Occur*"))
  )

;;; ========================= key bindings ============================
(defhydra hydra-search-menu (:color amaranth :hint nil)
  "
   ^Actions^                  ^Misc^
^^^^^-------------------------------------------------------
  _a_: counsel ag            _A_: ag
  _o_: occur                 _O_: moccur in same major-mode
  _r_: rgrep
  _s_: swiper
^
^
  "
  ("a" counsel-ag :color blue)
  ("A" ag :color blue)
  ("o" occur :color blue)
  ("r" rgrep :color blue)
  ("s" swiper :color blue)
  ("O" hong/multi-occur-same-major-mode :color blue)
  ("c" nil "cancel")
  ("q" nil "cancel"))

(provide 'init-search)
