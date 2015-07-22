(setq-default grep-hightlight-matches     t
              grep-scroll-output          t)

(when (executable-find "ag")
  (require-package 'ag)
  (setq-default ag-highlight-search t))

;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;; occur follow
(defun hong/occur-next-or-prev (next-or-prev)
  (lexical-let ((nop next-or-prev))
    (lambda () (interactive)
      (let ((buf (get-buffer-window (buffer-name))))
        (if (eq nop 'next) (occur-next) (occur-prev))
        (occur-mode-goto-occurrence-other-window)
        (hl-line-mode 1)
        (recenter)
        (select-window buf)))))

(defadvice occur (after hong/occur-switch-window activate)
  (select-window (get-buffer-window "*Occur*")))

(defadvice isearch-occur (after hong/occur-exit-isearch activate)
  (select-window (get-buffer-window "*Occur*"))
  (isearch-exit))
(add-hook 'occur-mode-hook
          (lambda ()
            (define-key evil-motion-state-local-map (kbd "n")
              (hong/occur-next-or-prev 'next))
            (define-key evil-motion-state-local-map (kbd "p")
              (hong/occur-next-or-prev 'prev))))

(provide 'init-search)
