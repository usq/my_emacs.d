(setq kaylee-font-lock-keywords
      (let (
            (keywords '("kaylee"))
            (types '(":asset" ":kayleehook" ":framework"))
            )

        (let (
              (keywords-regexp  (regexp-opt keywords 'words))
              (type-regexp      "src:")
              (event-regexp    "(?:)[a-zA-Z0-9_-]+")
              (comments-regexp "#.*\\|//.*")
              )
          `(
            (,type-regexp . font-lock-type-face)
            (,event-regexp . font-lock-function-name-face)
            (,comments-regexp . font-lock-comment-face)
            (,keywords-regexp . font-lock-keyword-face)
            ))))

(define-derived-mode kaylee-mode fundamental-mode
  "kaylee mode"
  ;; code for syntax highlighting
  (setq font-lock-defaults '((kaylee-font-lock-keywords))))


(defun kaylee-build ()
  (interactive)
  (_execKayleeShell "kaylee build"))


(defun kaylee-mount ()
  (interactive)
  (_execKayleeShell "kaylee mount"))

(defun kaylee-fix ()
  (interactive)
  (_execKayleeShell "kaylee fix"))

(defun kaylee-info (platform fw)
  (interactive
   "Mplatform: 
Mframework: ")
  (_execKayleeShell (concat "kaylee info " platform " " fw)))


(defun kaylee-fix-override ()
  (interactive)
  (_execKayleeShell "kaylee fix --override"))

(defun kaylee-maintain ()
  (interactive)
  (_execKayleeShell "kaylee maintain"))

(defun kaylee-force-maintain ()
  (interactive)
  (_execKayleeShell "kaylee maintain --force"))

(defun kaylee-init-app ()
  (interactive)
  (_execKayleeShell "kaylee init app"))

(defun kaylee-init-framework ()
  (interactive)
  (_execKayleeShell "kaylee init framework"))

(defun kaylee-start-local-www ()
  (interactive) 
  )

(defun _execKayleeShell (arg)
  (if (get-buffer "*kaylee-output*")
      (kill-buffer "*kaylee-output*"))
  (with-output-to-temp-buffer "*kaylee-output*"
    (shell-command (concat arg " && echo done")
                   "*kaylee-output*"
                   "*kaylee-output*")

    (pop-to-buffer "*kaylee-output*")))

(provide 'kaylee-mode)



;; http://subfusion.net/cgi-bin/quote.pl?quote=firefly&number=1
