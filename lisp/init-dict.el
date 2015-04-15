(require-package 'chinese-yasdcv)
(setq yasdcv-sdcv-dicts '(("langdaoyh" "朗道英汉字典5.0" "langdao" t)
                          ("niujing" "牛津高阶英汉双解" "oald" t)
                          ("langdaohy" "朗道汉英字典5.0" "langdao" t)))
(global-set-key (kbd "C-c d") 'yasdcv-translate-at-point)

(provide 'init-dict)
