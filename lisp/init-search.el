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
(define-key occur-mode-map (kbd "j") 'next-line)
(define-key occur-mode-map (kbd "k") 'previous-line)
(define-key occur-mode-map (kbd "n") (hong/occur-next-or-prev 'next))
(define-key occur-mode-map (kbd "p") (hong/occur-next-or-prev 'prev))

(provide 'init-search)
