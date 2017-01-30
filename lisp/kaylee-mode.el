(setq kaylee-font-lock-keywords
      (let (
            (keywords '("~>" "=="))
            )

        (let (
              (keywords-regexp  (regexp-opt keywords 'words))
              (fw-pf-regexp      "^\\([a-zA-Z-0-9]+\\) +\\([a-zA-Z-]+\\) +\\(src:\\|~>\\|==\\) *\\([.a-zA-Z0-9]+\\)")
              (comments-regexp1 "#.*")
              (comments-regexp2 "//.*")
              )
          `(
            (,fw-pf-regexp . (1 font-lock-type-face))
            (,fw-pf-regexp . (2 font-lock-function-name-face))
            (,comments-regexp1 . font-lock-comment-face)
            (,comments-regexp2 . font-lock-comment-face)
            (,fw-pf-regexp . (3 font-lock-keyword-face))
            (,fw-pf-regexp . (4 font-lock-string-face))
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
