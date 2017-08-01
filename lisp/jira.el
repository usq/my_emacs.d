
(require 'json)
(require 'url)
(require 'jira-params)

(define-button-type 'jira-link)

(defun jira-link-insert-buttons (beg end)
  (remove-overlays beg end 'type 'jira-link)
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "\\[[a-zA-Z]+-[0-9]+\\]" end t)
      (make-button (match-beginning 0)
		   (match-end 0)
		   'action (lambda (button)
			     (let ((new-url (replace-regexp-in-string
					     "\\[\\|\\]"
					     ""
					     (format qm-jira-link-url (button-get button 'text)))))
			       (message new-url)
			       (browse-url new-url)))
		   'follow-link t
		   'text (match-string 0))))
  (save-excursion
    (goto-char beg)
    (while (re-search-forward "{[a-zA-Z]+-[0-9]+}" end t)
      (make-button (match-beginning 0)
		   (match-end 0)
		   'action (lambda (button)
			     (let ((new-url (replace-regexp-in-string
					     "{\\|}"
					     ""
					     (format aid-jira-link-url (button-get button 'text)))))
			       (message new-url)
			       (browse-url new-url)))
		   'follow-link t
		   'text (match-string 0)))))


(define-minor-mode jira-link-mode nil nil nil nil
  (cond
   (jira-link-mode
    (jit-lock-register #'jira-link-insert-buttons)
    (jira-link-insert-buttons (point-min) (point-max)))
   (t
    (jit-lock-unregister #'jira-link-insert-buttons)
    (remove-overlays (point-min) (point-max) 'type 'jira-link))))


 (defun json-from-url (url headers)
   "Return json response from querying URL with HEADERS."
 (let ((url-request-extra-headers headers))
   (with-current-buffer
       (url-retrieve-synchronously url)
     (goto-char url-http-end-of-headers)
     (json-read))))


(defun jira-clean (issues)
  (let ((all-issues 
	 (cdr  (assoc 'issues
		      issues))))
    (mapcar (lambda (issue)
	      (list
	       (cdr (assoc 'key issue))
	       (cdr (assoc 'summary (assoc 'fields issue)))
	       (cdr (assoc 'name (assoc 'status (assoc 'fields issue))))))
	    all-issues)))

(defun list-serenity-issues ()
  (jira-clean 
   (json-from-url sry-search-url
		  '(("Authorization" . jira-qm-token)))))

(defun jira-sync-serenity ()
  (interactive)
  (let* ((issues (list-serenity-issues))
	 (content (buffer-substring-no-properties (point-min) (point-max)))
	 (deduplicated-issues nil))
    (setq deduplicated-issues 
	  (mapcar (lambda (issue)
		    (let ((pos (string-match (format "\\[%s\\]" (first issue)) content)))
		      (if (null pos)
			issue
			nil))
		    )
		  issues))

    (mapc (lambda (issue)
	      (when (not (null issue))
		(newline)
		(let ((key (first issue))
		      (description (second issue))
		      (status (third issue)))
		  (if (equalp status "In Progress")
		      (insert (format  "*** DOING [%s] %s"  (first issue) (second issue)))
		    (insert (format  "*** TODO [%s] %s"  (first issue) (second issue)))))))
	    deduplicated-issues))
  (jira-link-mode)
  (jira-link-mode))

;;https://www.gnu.org/software/emacs/manual/html_mono/widget.html#Programming-Example

(provide 'jira)
