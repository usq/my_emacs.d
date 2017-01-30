;;; Package --- Summary
;;; Commentary:
;;; general settings

;;; Code:
(setq mac-command-modifier 'meta)
(setq ns-function-modifier 'hyper)

;;umlaute please!
(setq mac-option-modifier nil)

;; full power mode
(put 'upcase-region 'disabled nil)

;; move to trash
(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash/emacs")

;; Don't open files from the workspace in a new frame
(setq ns-pop-up-frames nil)

;;  Use aspell for spell checking: brew install aspell --lang=en
(defvar ispell-program-name)
(setq ispell-program-name "/usr/local/bin/aspell")

(defvar ido-ignore-files)
(add-to-list 'ido-ignore-files "\\.DS_Store")

;; backup in temp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; no lockfile, these clobber all up :/
;; i should add .# files to my global gitignore!
(setq create-lockfiles nil)

;;(defvar python-shell-interpreter)
;;(when (boundp python-shell-interpreter)
;;  (setq python-shell-interpreter "python" )
;;  )


;(setq python-shell-interpreter "path\to\your\python3.2")
;(autoload 'python-mode "python-mode" "Python Mode." t)
;(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
;(add-to-list 'interpreter-mode-alist '("python" . python-mode))


(provide 'mac)

;;; mac.el ends here
