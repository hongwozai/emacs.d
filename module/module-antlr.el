;;-------------------------------------------
;;; antlr mode
;;-------------------------------------------
(autoload 'antlr-v4-mode "antlr-mode" nil t)

(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

(setq antlr-v4-language-list
      '((antlr-cpp "Cpp") (antlr-java "Java") ; +CSharp
        (antlr-js "JavaScript") (antlr-python "Python2" "Python3")))

(setq antlr-v4-tool-command  "java org.antlr.v4.Tool -Dlanguage=Cpp")