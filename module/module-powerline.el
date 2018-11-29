;;; don't use powerline, because too slow
;;; mode-line
(setq-default mode-line-format
              '("%e"
                (:eval (winum-get-number-string))
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                ;; vim state
                (:eval evil-mode-line-tag)
                ;; line and column
                "[" "%02l" "," "%01c" "] "
                mode-line-frame-identification
                mode-line-buffer-identification
                "   [" (vc-mode vc-mode) " ]  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces)
              )