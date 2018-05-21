(when (executable-find "dot")
  (require-package 'graphviz-dot-mode)
  (require-package 'plantuml-mode))

;;; graphviz
(with-eval-after-load "org"
  (add-to-list 'org-src-lang-modes  '("dot" . graphviz-dot))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)))
  )

(with-eval-after-load 'graphviz-dot-mode
  (add-hook 'graphviz-dot-mode-hook
            (lambda ()
              (hong/select-buffer-window graphviz-dot-preview "*preview*")
              (setq graphviz-dot-auto-indent-on-braces t)
              (setq graphviz-dot-toggle-completions t)
              ;; use imagemagick
              (setq graphviz-dot-view-command "display %s")

              (evil-define-key 'normal graphviz-dot-mode-map
                (kbd "C-c C-c") 'graphviz-dot-preview
                (kbd "C-c v") 'graphviz-dot-view)
              (evil-leader/set-key-for-mode 'graphviz-dot-mode
                  "cc" 'graphviz-dot-preview
                  "cv" 'graphviz-dot-view)))
  )

;;; plantuml
(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))

(with-eval-after-load 'plantuml-mode
  (add-hook 'plantuml-mode-hook
            (lambda ()
              (evil-define-key 'normal plantuml-mode-map
                (kbd "C-c C-c")  'plantuml-preview
                (kbd "C-c v")    'hong/plantuml-view)
              (evil-leader/set-key-for-mode 'plantuml-mode
                  "cc" 'plantuml-preview
                  "cv" 'hong/plantuml-view)))
  )

(defun hong/plantuml-view ()
  (interactive)
  (let* ((plantuml-output-type
          (if current-prefix-arg (plantuml-read-output-type) "png"))
         (cmd (concat plantuml-java-command " "
                      (mapconcat (lambda (x) x) plantuml-java-args " ") " "
                      (expand-file-name plantuml-jar-path) " "
                      (plantuml-output-type-opt) " "
                      "-charset UTF-8"))
         (file (or (buffer-file-name) (error "Not Assoc File!")))
         (genfile (concat (string-remove-suffix "plantuml" file)
                          plantuml-output-type)))
    (start-process-shell-command "hong/plantuml-view" plantuml-preview-buffer
                                 (format "%s %s && display %s" cmd file genfile))))

(provide 'init-graphviz)