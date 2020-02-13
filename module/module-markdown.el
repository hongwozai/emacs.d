;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'markdown-mode)

(setq markdown-command "pandoc")
(add-hook 'markdown-mode-hook 'visual-line-mode)

(setq auto-mode-alist
      (append
       ;; markdown-mode
       '(("\\.md\\'" . markdown-mode)
         ("README\\'" . markdown-mode)
         ("readme\\'" . markdown-mode)
         ("readme\\.txt\\'" . markdown-mode)
         ("README\\.txt\\'" . markdown-mode))
       auto-mode-alist))

;;; C-c C-c l simple on-the-fly preview
;;; C-c C-s C/q/

;;-------------------------------------------
;;; livedown on-the-fly preview
;;-------------------------------------------
;;; npm install -g livedown
;;; livedown start Readme.md --port 6419

;;-------------------------------------------
;;; configure
;;-------------------------------------------
(setq markdown-enable-wiki-links t
      markdown-italic-underscore t
      markdown-asymmetric-header t
      markdown-make-gfm-checkboxes-buttons t
      markdown-gfm-uppercase-checkbox t
      markdown-fontify-code-blocks-natively t
      markdown-enable-math t

      markdown-content-type "application/xhtml+xml"
      markdown-css-paths '("https://cdn.jsdelivr.net/npm/github-markdown-css/github-markdown.min.css"
                           "https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/styles/github.min.css")
      markdown-xhtml-header-content "
<meta name='viewport' content='width=device-width, initial-scale=1, shrink-to-fit=no'>
<style>
body {
  box-sizing: border-box;
  max-width: 740px;
  width: 100%;
  margin: 40px auto;
  padding: 0 10px;
}
</style>
<script src='https://cdn.jsdelivr.net/gh/highlightjs/cdn-release/build/highlight.min.js'></script>
<script>
document.addEventListener('DOMContentLoaded', () => {
  document.body.classList.add('markdown-body');
  document.querySelectorAll('pre[lang] > code').forEach((code) => {
    code.classList.add(code.parentElement.lang);
    hljs.highlightBlock(code);
  });
});
</script>
")


;;-------------------------------------------
;;; toc
;;-------------------------------------------
(require-package 'markdown-toc)

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-command-map
    (kbd "r") 'markdown-toc-generate-or-refresh-toc))
