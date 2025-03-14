(require 'server)

(setq server-use-tcp t)
(setq server-auth-key
      "Gpq~)+kz%'ebA#AL67sA4=,W5~@_xra$?^4pf$_z?=cC^jl%]Jq-BUAtj[)HrFCd")

(setq server-host "0.0.0.0"
      server-port 11014)

(add-hook 'server-after-make-frame-hook
          (lambda ()
            (set-graphic-font '("DejaVu Sans Mono Bold" . 16)
                              '("微软雅黑" . 20))))

(server-start)