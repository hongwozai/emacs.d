(setq-default grep-hightlight-matches     t
			  grep-scroll-output          t)

(when (executable-find "ag")
  (require-package 'ag)
  (setq-default ag-highlight-search t))

;;; occur inside isearch
(define-key isearch-mode-map (kbd "C-o") 'isearch-occur)

(provide 'init-search)
