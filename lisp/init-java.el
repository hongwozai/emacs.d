(require-package 'meghanada)

(add-hook 'java-mode-hook
          (lambda ()
            (meghanada-mode t)))

(provide 'init-java)