

(setq mac-command-modifier 'meta)
(setq ns-function-modifier 'hyper)

;;umlaute please!
(setq mac-option-modifier nil)


(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")


;; Don't open files from the workspace in a new frame
(setq ns-pop-up-frames nil)

;;  Use aspell for spell checking: brew install aspell --lang=en
(setq ispell-program-name "/usr/local/bin/aspell")

(add-to-list 'ido-ignore-files "\\.DS_Store")


(provide 'mac)
