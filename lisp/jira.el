
(require 'json)
(require 'url)
(require 'jira-params)
(require 's)
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

(defun list-issue-with-jql-url (jql-url)
  (jira-clean 
   (json-from-url jql-url
		  (list `("Authorization" . ,jira-qm-token)))))


(defun jira-sync-fw ()
  (interactive)
  (jira-sync-issues (list-issue-with-jql-url fw-search-url)))

(defun jira-sync-pipa ()
  (interactive)
  (jira-sync-issues (list-issue-with-jql-url pipa-search-url)))

(defun jira-sync-serenity ()
  (interactive)
  (jira-sync-issues (list-issue-with-jql-url sry-search-url)))

(defun jira-sync-tickets ()
  (interactive)
  (jira-sync-fw)
  (jira-sync-serenity)
  (jira-sync-pipa))

(defun jira-cleanup-umlaute (ins)
  (s-replace-all '(("Ã¼" . "ü")
		   ("Ã" . "Ü")
		   ("Ã¶" . "ö")
		   ("Ã¤" . "ä"))
		 ins))

(defun jira-sync-issues (j-issues)
  (let* ((issues j-issues)
	 (content (buffer-substring-no-properties (point-min) (point-max)))
	 (deduplicated-issues nil)
	 (level (org-outline-level))
	 (stars (s-repeat level "*")))
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
		      (description (jira-cleanup-umlaute (second issue)))
		      (status (third issue)))
		  (case ())
		  (cond ((equalp status "In Progress") (insert (format  "%s DOING [%s] %s" stars (first issue) description)))
			((equalp status "Blocked") (insert (format  "%s WAITING [%s] %s"  stars (first issue) description)))
			(t (insert (format  "%s TODO [%s] %s"  stars (first issue) description)))
			)
)))
	  deduplicated-issues))
    (jira-link-mode)
    (jira-link-mode))



;; (defclass ticket ()
;;   ((number :initarg :num
;; 	   :documentation "a number")))

;; (defmethod hello ((tick ticket))
;;   (message "hello %s" (oref tick :num)))




(defun jira-kv-mapping (k v)
  (let ((m 
	 '(
	   ("priority" .  (("mapped" . "priority")
			   ("values" . (("minor" . "4")))))
	   ("type" . (("mapped" . "issuetype")
		      ("values" . (("feedback" . "13")
				   ("story" . "7")
				   ("task" . "3")
				   ("bug" . "1")))))
	   
	   ("project" . (("mapped" . "pid")
			 ("values" . (("php" . "10501")
				      ("serenity" . "13804")
				      ("fw" . "13301")))))
	   
	   ("platform" . (("mapped" . "customfield_10502")
			  ("values" . (("ios" . "10114")
				       ("all" . "10113")))))
	   ("component" . (("mapped" . "components")
			   ("values" . (("kaylee" . "14038")))))
	   
	   )))
    (let ((nk (assoc-recursive m k "mapped"))
	  (nv (assoc-recursive m k "values" v)))
      (if (and (not (null nk))
	       (not (null nv)))
	  (concat nk "=" nv)
	nil))))


(defun assoc-recursive (alist &rest keys)
  "Recursively find KEYs in ALIST."
  (while keys
    (setq alist (cdr (assoc (pop keys) alist))))
  alist)


(defmacro jira-issue-url (&rest elements)
  `(let* ((els ',elements)
	  (pairs (mapcar (lambda (x) (s-split "=" (symbol-name x))) els)))
     
     (concat "https://jira.quartett-mobile.de/secure/CreateIssueDetails!init.jspa?"
	     (s-join "&" 
		     (mapcar (lambda (p)
			       (let ((r (jira-kv-mapping (first p) (second p))))
				 (if (not (null r))
				     r
				   (concat (first p) "=" (second p)))))
				     pairs)))))

(defun jira-create-fw-task ()
  (interactive)
  (browse-url (jira-issue-url reporter=conrads project=fw priority=minor type=task platform=ios)))

(defun jira-create-php-story ()
  (interactive)
  (browse-url (jira-issue-url reporter=conrads project=php priority=minor type=story platform=ios)))

(defun jira-create-php-task ()
  (interactive)
  (browse-url (jira-issue-url reporter=conrads project=php priority=minor type=task platform=ios)))

(defun jira-create-kaylee-feedback-ticket ()
  (interactive)
  (browse-url (jira-issue-url reporter=conrads project=serenity priority=minor type=feedback platform=all component=kaylee)))

(defun jira-create-kaylee-bug-ticket ()
  (interactive)
  (browse-url (jira-issue-url reporter=conrads project=serenity priority=minor type=bug platform=all component=kaylee)))

(provide 'jira)
