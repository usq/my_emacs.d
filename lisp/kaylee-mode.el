;;; kaylee-mode
(require 'subr-x)
(require 'cl-lib)
(require 'comint)
(require 'seq)
(require 's)

;;; Code:
(define-derived-mode kaylee-mode comint-mode "Inferior Kaylee"
  "Major mode for Kaylee inferior process."
  (setq-local indent-tabs-mode nil)
  (setq font-lock-defaults '((kaylee-font-lock-keywords)))
  ;; How to dispaly the process status in the mode-line
					;  (setq mode-line-process '(":%s"))

  ;;reenable enter key
  (define-key kaylee-mode-map (kbd "RET") nil)
  (define-key kaylee-mode-map (kbd "C-c C-c") (lambda ()
						(interactive) (kaylee-fix)))
  (define-key kaylee-mode-map (kbd "C-c C-o") (lambda ()
						(interactive) (kaylee-fix-override)))
  (define-key kaylee-mode-map (kbd "C-c f") (lambda ()
					      (interactive) (kaylee-fix)))
  (define-key kaylee-mode-map (kbd "C-c m") (lambda ()
					      (interactive) (kaylee-mount)))
  (define-key kaylee-mode-map (kbd "C-c o") (lambda ()
					      (interactive) (kaylee-open)))
  (define-key kaylee-mode-map (kbd "C-c k") (lambda ()
					      (interactive) (kaylee-switch)))
  (define-key kaylee-mode-map (kbd "C-c d") (lambda ()
					      (interactive) (kaylee-dirty-projects)))
  
  (define-key kaylee-mode-map (kbd "C-c i") (lambda ()
					      (interactive)
					      (kaylee-projectinfo-at-point nil)))
  (define-key kaylee-mode-map (kbd "C-c I") (lambda ()
					      (interactive)
					      (kaylee-projectinfo-at-point t)))

  
  (setq-local kaylee-font-lock-keywords
	      (let ((keywords '("~>" "==" ">=")))
		(let (
		      (keywords-regexp  (regexp-opt keywords 'words))
		      (fw-pf-regexp      "^\\([.a-zA-Z-0-9\\/]+\\) +\\([a-zA-Z-]+\\) +\\(src:\\|~>\\|==\\|>=\\) *\\([.a-zA-Z0-9_/-]+\\)")
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
  
  ;; This disables editing and traversing the "=>" prompts
  (setq-local comint-prompt-read-only t)
  ;; Lets comint mode recognize the prompt
  ;;(setq-local comint-prompt-regexp (rx bol "=>" space))

  (defun kaylee--sentinel (process event)
    (with-current-buffer "*kaylee-output*"
      (insert "\npress `q` to quit")
      (special-mode)))
  
  (defun kaylee--run-cmd (args)
    (if (get-buffer "*kaylee-output*")
	(kill-buffer "*kaylee-output*"))

    (let ((output (get-buffer-create "*kaylee-output*")))
      (switch-to-buffer-other-window output)

      (let* ((kaylee-proc-buffer (apply 'make-comint-in-buffer "kaylee" output "kaylee" nil args))
	     (kaylee-proc (get-buffer-process kaylee-proc-buffer)))
	(set-process-sentinel kaylee-proc 'kaylee--sentinel))))
  
  (defun kaylee--run-sync-cmd (args)
    (if (get-buffer "*kaylee-output*")
	(kill-buffer "*kaylee-output*"))

    (let ((output (get-buffer-create "*kaylee-output*")))
      (switch-to-buffer-other-window output)
      (with-current-buffer output
	(insert (shell-command-to-string (string-join (cons "kaylee" args) " "))))))

  (defun kaylee-projectinfo-at-point (open)
    (interactive)
    (let* ((current-line (thing-at-point 'line t))
	   (components (split-string current-line))
	   (fw (first components))
	   (pf (second components)))
      (kaylee-info pf fw open)))

  
  (defun kaylee-clone (platform fw)
    (interactive
     "Mplatform:
Mframework:")
    (kaylee--run-cmd (list "clone" platform fw)))
  
  (defun kaylee-build ()
    (interactive)
    (kaylee--run-cmd '("build")))

  (defun kaylee-mount ()
    (interactive)
    (kaylee--run-cmd '("mount")))

  (defun kaylee-show-in-gitlab ()
    (interactive)
    (if (file-exists-p "Serenity.json")
	(progn
	  (with-temp-buffer
	    (insert-file-contents-literally "Serenity.json")
	    (goto-char (point-min))
	    (let* ((serenityjson (json-read))
		   (pf (cdr (assoc-string "platform" serenityjson)))
		   (name (cdr (assoc-string "name" serenityjson))))
	      (kaylee--run-cmd `("info" ,pf ,name "--open"))
	      )
	    )
	  )
      (message "Serenity.json not found")
      )
    )

  (defun kaylee-fix-override ()
    (interactive)
    (kaylee--run-cmd '("fix" "--override")))

  (defun kaylee-open ()
    (interactive)
    (shell-command "open *.xcworkspace"))

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

  (defun kaylee-info (platform fw open)
    (interactive
     "Mplatform:
Mframework:")
    (kaylee--run-sync-cmd (list "info" platform fw (when open "--open")))
    (with-current-buffer "*kaylee-output*"
      (ansi-color-apply-on-region (point-min) (point-max))
      (view-mode 1)
      (goto-char (point-min))))

  (defun kaylee-why (platform fw)
    (interactive
     "Mplatform:
Mframework:")
    (kaylee--run-sync-cmd (list "why" platform fw))
    (with-current-buffer "*kaylee-output*"
      (ansi-color-apply-on-region (point-min) (point-max))
      (view-mode 1)
      (goto-char (point-min))))

  (defun kaylee--read-lines (filePath)
    "Return a list of lines of a file at FILEPATH."
    (with-temp-buffer
      (insert-file-contents filePath)
      (split-string (buffer-string) "\n" t)))

  (defun kaylee--project-from-string (cat-str)
    (let* ((parts (s-split " " cat-str))
	   (branchparts (s-split ":" (third parts)))
	   (branchname (second branchparts))
	   (fwname (concat (first parts) " " (second parts) " src:" branchname))
	   )
      
      `((name . ,(first parts))
	(platform . ,(second parts))
	(branch . ,branchname)))
    )
  
  (defun kaylee--src-fws-in-catalyzerfixed (path)
    (let* ((catlines (kaylee--read-lines path))
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
			filtered)))
      fws))

  (defun kaylee--repo-dirty? (repo)
    (let* ((gitpath (concat "Serenity/Projects/" (cdr (assoc 'platform repo))
			    "/" (cdr (assoc 'name repo))))
	   (result (shell-command-to-string (concat "git --git-dir=" gitpath "/.git --work-tree=" gitpath "  status --porcelain "))))
      (not (s-blank-str-p (s-replace "\n" "" result)))))
  
  (defun kaylee-switch ()
    "Switch between Catalyzer and Catalyzer.fixed."
    (interactive)
    (let ((fws (kaylee--src-fws-in-catalyzerfixed "Catalyzer.fixed")))
      (if (null fws)
	  (message "No src: dependency found")
	(kaylee--query-user-for-selection "Select source dependency:" fws))))


  (defun --kaylee-current-branch-name-at-path (path)
    (let* ((result (shell-command-to-string (concat "git --git-dir=" path "/.git --work-tree=" path " rev-parse --abbrev-ref HEAD"))
		   ))
      (s-trim-right result)
      )
    )

  (defun --kaylee-current-branch-name (cat-str)
    (let* ((parts (s-split " " cat-str))
	   (branchname (--kaylee-current-branch-name-at-path (concat "Serenity/Projects/" (second parts) "/" (first parts))
							     ))
	   (fwname (concat (first parts) " " (second parts) " src:" branchname))
	   )
      
      `((name . ,(first parts))
	(platform . ,(second parts))
	(branch . ,branchname)))
    )

  (defun replace-src-dep-in-line-with-branch (line branch)
    (replace-regexp-in-string "src:[a-zA-Z0-9-_/]+" (lambda (match)
						      (concat "src:" branch)
						      )
			      line)
    )

  
  
  (defun kaylee-insert-branch-name ()
    (interactive)
    (let* (
	   (current-line (thing-at-point 'line t))
	   (components (split-string current-line))
	   (fw (first components))
	   (pf (second components))
	   (fws (kaylee--src-fws-in-catalyzerfixed "Catalyzer.fixed"))
	   (project (first (seq-filter (lambda (el)
					 (and
					  (equalp fw (cdr (assoc 'name el) ))
					  (equalp pf (cdr (assoc 'platform el))))
					 )
				       (mapcar #'--kaylee-current-branch-name fws))))
	   )


      
      (if (null fw)
	  (message "Point not at dependency")
	(if (null project)
	    (message "No src: dependency found for or no Catalyzer.fixed found")
	  (progn
	    (kill-whole-line)
	    (insert (replace-src-dep-in-line-with-branch current-line (cdr (assoc 'branch project))))
	    )
	  (message "-> %s" project)))))

  
  (defun kaylee--query-user-for-selection (query fws)
    (kaylee--open-selection (ivy-completing-read query fws)))

  (defun kaylee--open-selection (selection)
    (let* ((selparts (s-split " " selection))
	   (fwname (first selparts))
	   (fwplatform (second selparts)))
      (find-file-other-window (concat "Serenity/Projects/" fwplatform "/" fwname "/Catalyzer"))))

  (defun kaylee-dirty-projects ()
    "List projects where statis is not clean"
    (interactive)
    (let* ((fws (kaylee--src-fws-in-catalyzerfixed "Catalyzer.fixed"))
	   (projects (mapcar #'kaylee--project-from-string fws))
	   (dirty-repos (-filter #'kaylee--repo-dirty?  projects)))
      (if (null dirty-repos)
	  (message "No src dependency dirty!")
	(kaylee--query-user-for-selection "Select dirty repo:" (-map (lambda (r) (concat (cdr (assoc 'name r)) " " (cdr (assoc 'platform r)) " src:" (cdr (assoc 'branch r)))) dirty-repos)))))) ;; end kaylee-mode




;; toggle between catalyzers




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

(provide 'kaylee-mode)

;; curl http://subfusion.net/cgi-bin/quote.pl\?quote\=firefly\&number\=1 | tail -n +15 | tail -r | tail -n +4 | tail -r
;; http://subfusion.net/cgi-bin/quote.pl?quote=firefly&number=1
