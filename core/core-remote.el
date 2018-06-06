;;-------------------------------------------
;;; tramp
;;-------------------------------------------
;;; ssh is faster than scp. scpx or sshx. see Tramp hangs
(setq tramp-default-method "ssh")
(setq tramp-verbose 2)
(setq tramp-connection-timeout 20)

;;; save password(2 hours)
(setq password-cache t)
(setq password-cache-expiry 7200)

;;; faster see wiki Tramp hangs #2
(setq tramp-chunksize 8192)
(setq tramp-ssh-controlmaster-options
      "-o ControlMaster=auto -o ControlPath='tramp.%%C' -o ControlPersist=no")

;;-------------------------------------------
;;; config
;;-------------------------------------------
;;; experiment
(setq enable-remote-dir-locals t)

(provide 'core-remote)
