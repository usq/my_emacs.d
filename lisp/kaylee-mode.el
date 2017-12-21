(setq kaylee-font-lock-keywords
      (let ((keywords '("~>" "==" ">=")))
        (let (
              (keywords-regexp  (regexp-opt keywords 'words))
              (fw-pf-regexp      "^\\([.a-zA-Z-0-9\\/]+\\) +\\([a-zA-Z-]+\\) +\\(src:\\|~>\\|==\\|>=\\) *\\([.a-zA-Z0-9/]+\\)")
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

(defun kaylee-fix ()
  (interactive)
  (_execKayleeShell "kaylee" "fix"))



(defun _execKayleeShell (&rest args)
  (if (get-buffer "*kaylee-output*")
      (kill-buffer "*kaylee-output*"))

  (let ((output (get-buffer-create "*kaylee-output*")))
    (eval `(start-process "kaylee process" output ,@args))
    (switch-to-buffer-other-window output)
    (special-mode)
    )
   )


(defun kaylee-token ()
  (interactive)
  (defun all-but-last (l)
    (reverse (cdr (reverse l))))
  
  (let* ((token (shell-command-to-string "security find-generic-password -g -a kaylee -s de.quartett-mobile.kaylee"))
	 (pwline (first (split-string token "\n")))
	 (replaced (replace-regexp-in-string "password: \\\"" "" pwline))
	 (cleaned-up (join-string-list (reverse (cdr (reverse (split-string replaced "" t )))) ""))
	 (cleaned-up2 (join-string-list  (all-but-last (split-string replaced "" t )) ""))	 
	 )

    (message "Copied token to clipboard")
    (paste-to-osx cleaned-up2)))



(require 'cl-lib)
(defun kaylee--read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer
    (insert-file-contents filePath)
    (split-string (buffer-string) "\n" t)))



(defun kaylee--src-fws-in-catalyzerfixed (path)
  (let*
      (
       (catlines (kaylee--read-lines path))
       (filtered (cl-remove-if-not (lambda (x)  (and (not (s-starts-with-p "#" x))
						     (s-contains-p "src:" x)))
				   catlines))
       (fws (mapcar (lambda (fw)
		      (let* ((parts (s-split " " fw))
			     (branchparts (s-split ":" (third parts)) )
			     (branchname (second branchparts))
			     (fwname (concat (first parts) " " (second parts) " src:" branchname))
			     )
			fwname))
		    filtered))
       )
    fws))

(defun kaylee-switch ()
  (interactive)
  (let* ((fws (kaylee--src-fws-in-catalyzerfixed "Catalyzer.fixed"))
	 (selection (ido-completing-read "Select " fws))
	 (selparts (s-split " " selection))
	 (fwname (first selparts))
	 (fwplatform (second selparts)))
	 (find-file-other-window (concat "Serenity/Projects/" fwplatform "/" fwname "/Catalyzer"))))


(require 'mc)
(defun kaylee-run-tests ()
  (interactive)
  (let ((buffname "kaylee tests"))
    (let ((buf (get-buffer-create buffname)))
      (with-current-buffer
	  buf
	(special-mode)	
	(setq buffer-read-only nil)
	(erase-buffer)
	(special-mode)
	(mc-async-cmd-logging "~/dev/QM/frameworks/serenity/kaylee/bin/kaylee selftest"
			      buf)
	(switch-to-buffer-other-window buf)
	)))
  )



(provide 'kaylee-mode)

;; curl http://subfusion.net/cgi-bin/quote.pl\?quote\=firefly\&number\=1 | tail -n +15 | tail -r | tail -n +4 | tail -r
;; http://subfusion.net/cgi-bin/quote.pl?quote=firefly&number=1
