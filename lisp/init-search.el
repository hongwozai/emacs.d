;;; =================== grep =========================
(setq-default grep-hightlight-matches     t
              grep-scroll-output          t)

(when (executable-find "ag")
  (require-package 'ag)
  (setq-default ag-highlight-search t)
  (setq-default ag-reuse-buffers t)
  (setq-default ag-reuse-window nil)

  (hong/select-buffer-window ag "*ag search*")
  )

;;; =================== occur =========================
;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)
;;; occur follow
(defun hong/occur-next-or-prev (next-or-prev)
  (lexical-let ((nop next-or-prev))
    (lambda () (interactive)
      (let ((buf (get-buffer-window (buffer-name))))
        (save-selected-window
          (if (eq nop 'next) (occur-next) (occur-prev))
          (occur-mode-goto-occurrence-other-window)
          (recenter))))))

(hong/select-buffer-window occur "*Occur*")

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

(provide 'init-search)
