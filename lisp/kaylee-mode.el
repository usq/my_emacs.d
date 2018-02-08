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


(require 'subr-x)
(define-derived-mode inferior-kaylee-mode comint-mode "Inferior Kaylee"
  "Major mode for Kaylee inferior process."
  (setq-local indent-tabs-mode nil)

  ;; How to dispaly the process status in the mode-line
  (setq mode-line-process '(":%s"))
  
  ;; This disables editing and traversing the "=>" prompts
  (setq-local comint-prompt-read-only t)
  ;; Lets comint mode recognize the prompt
  ;;(setq-local comint-prompt-regexp (rx bol "=>" space))

  (defun kaylee--sentinel (process event)
    (when (equal "finished" (string-trim event))
      (with-current-buffer "*kaylee-output*")
      (insert "\npress `q` to quit")
      (special-mode)
      ))
  
  (defun kaylee--run-cmd (args)
    (if (get-buffer "*kaylee-output*")
	(kill-buffer "*kaylee-output*"))

    (let ((output (get-buffer-create "*kaylee-output*")))
      (switch-to-buffer-other-window output)

      (let* ((kaylee-proc-buffer (apply 'make-comint-in-buffer "kaylee" output "kaylee" nil args))
	     (kaylee-proc (get-buffer-process kaylee-proc-buffer)))
	(set-process-sentinel kaylee-proc 'kaylee--sentinel))
      ))
  (defun kaylee--run-sync-cmd (args)
    (if (get-buffer "*kaylee-output*")
	(kill-buffer "*kaylee-output*"))

    (let ((output (get-buffer-create "*kaylee-output*")))
      (switch-to-buffer-other-window output)
      (insert (shell-command-to-string (string-join (cons "kaylee" args) " ")))
      ))
  
  (defun kaylee-build ()
    (interactive)
    (kaylee--run-cmd '("build")))

  (defun kaylee-mount ()
    (interactive)
    (kaylee--run-cmd '("mount")))

  (defun kaylee-fix-override ()
    (interactive)
    (kaylee--run-cmd '("fix" "--override")))

  (defun kaylee-maintain ()
    (interactive)
    (kaylee--run-cmd '("maintain")))

  (defun kaylee-force-maintain ()
    (interactive)
    (kaylee--run-cmd '("maintain" "--force")))

  (defun kaylee-init-app ()
    (interactive)
    (kaylee--run-cmd '("init" "app")))

  (defun kaylee-init-framework ()
    (interactive)
    (kaylee--run-cmd '("init" "framework")))

  (defun kaylee-fix ()
    (interactive)
    (kaylee--run-cmd '("fix")))

  (defun kaylee-info (platform fw)
    (interactive
     "Mplatform: 
Mframework: ")
    (kaylee--run-sync-cmd (list "info" platform fw))
    
    (with-current-buffer "*kaylee-output*"
      (ansi-color-apply-on-region (point-min) (point-max))
      (view-mode 1)
      (goto-char (point-min))
      ))

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






;; toggle between catalyzers
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
(defun kaylee--run-tests (path-to-kaylee)
  (let ((buffname "kaylee tests"))
    (let ((buf (get-buffer-create buffname)))
      (with-current-buffer
	  buf
	(special-mode)	
	(setq buffer-read-only nil)
	(erase-buffer)
	(special-mode)
	(mc-async-cmd-logging (string-join (list  path-to-kaylee "selftest") " ") buf)
	(switch-to-buffer-other-window buf)
	))))

(defun kaylee-run-local-tests ()
  (interactive)
  (kaylee--run-tests "~/dev/QM/frameworks/serenity/kaylee/bin/kaylee"))

(defun kaylee-run-tests ()
  (interactive)
    (kaylee--run-tests "kaylee"))

(provide 'kaylee-mode)

;; curl http://subfusion.net/cgi-bin/quote.pl\?quote\=firefly\&number\=1 | tail -n +15 | tail -r | tail -n +4 | tail -r
;; http://subfusion.net/cgi-bin/quote.pl?quote=firefly&number=1
