;;; environment
(set-language-environment "utf-8")

;;; input method
(when (executable-find "/usr/bin/sdcv")
  (require-package 'chinese-yasdcv)
  (setq yasdcv-sdcv-dicts '(("langdaoyh" "朗道英汉字典5.0" "langdao" t)
                            ("niujing" "牛津高阶英汉双解" "oald" t)
                            ("langdaohy" "朗道汉英字典5.0" "langdao" t)))
  (global-set-key (kbd "C-c d") 'yasdcv-translate-at-point)

  (hong/select-buffer-window yasdcv-translate-at-point "*Stardict Output*")
  )

;;; select start

;;; input method
(require-package 'chinese-pyim)
(require 'chinese-pyim)
(global-set-key (kbd "C-<SPC>") 'toggle-input-method)
(global-set-key (kbd "C-;") 'pyim-toggle-full-width-punctuation)
(eval-after-load 'chinese-pyim
  '(progn
     (setq default-input-method "chinese-pyim")
     (setq pyim-use-tooltip nil)              ; don't use tooltip
     (setq pyim-dicts '((:name "pinyin" :file "~/.eim/pyim-bigdict.pyim" :coding utf-8-unix)))))

;;; fcitx
(when (executable-find "/usr/bin/fcitx")
  (require-package 'fcitx)
  (fcitx-default-setup))

(provide 'init-chinese)
