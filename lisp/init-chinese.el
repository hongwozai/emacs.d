;;; coding system
(set-language-environment "utf-8")
(prefer-coding-system 'utf-8)
;;; ======================== dictionary =================================
(when (executable-find "/usr/bin/sdcv")
  (require-package 'chinese-yasdcv)
  (setq yasdcv-sdcv-dicts '(("langdaoyh" "朗道英汉字典5.0" "langdao" t)
                            ("niujing" "牛津高阶英汉双解" "oald" t)
                            ("langdaohy" "朗道汉英字典5.0" "langdao" t)))
  (global-set-key (kbd "C-c d") 'yasdcv-translate-at-point)

  (hong/select-buffer-window yasdcv-translate-at-point "*Stardict Output*")
  )

(defun hong/translate-brief-at-point ()
  (interactive)
  (let ((word
         (if (use-region-p)
             (buffer-substring-no-properties (region-beginning) (region-end))
             (thing-at-point 'word t))))
    (bing-dict-brief word)))

;;; ======================= input method =================================
(require 'pyim)
(pyim-basedict-enable)
(with-eval-after-load 'pyim
  (setq default-input-method "pyim")
  (setq pyim-use-tooltip 'popup)
  (setq pyim-page-length 5)
  (setq pyim-enable-words-predict nil)
  (global-set-key (kbd "C-SPC") 'toggle-input-method))

;;; fcitx
(when (executable-find "/usr/bin/fcitx")
  (require-package 'fcitx)
  (fcitx-default-setup))

(provide 'init-chinese)
