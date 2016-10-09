
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
(setq ns-function-modifier 'hyper)


(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")


;; Don't open files from the workspace in a new frame
(setq ns-pop-up-frames nil)

;; Use aspell for spell checking: brew install aspell --lang=en
;;(setq ispell-prog
;;      ram-name "/usr/local/bin/aspell")


(provide 'mac)
