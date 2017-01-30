;;; Code:
(require 'cl-lib)
(require 'json)

(defun join-path (components)
  "Joins COMPONENTS with /."
  (concat (apply 'concat
		  (mapcar 'file-name-as-directory
			  (butlast components)))
	  (car (last components))))

(defun directory-p (path)
  "T if PATH points to a directory."
  (eq t (first (file-attributes path))))

(defun filename-matches (path &rest args)
  "Return t if the filename of PATH match any of ARGS."
  (let ((name (file-name-nondirectory path)))
    (reduce (lambda (s x)
	      (or s
		  (equal name x)))
	    args :initial-value nil)))

(defun folders-at-path (path)
  "Return all folders at PATH."
  (let* ((files (directory-files path t))
	 (folders (remove-if-not (lambda (x)
				   (and (directory-p x)
					(not (filename-matches x "." ".."))))
				 files)))
    folders))

(defun repos-in-path (path)
  "Return a list of all repos at PATH recursively."
  (when (file-exists-p path)
    (let ((folders (folders-at-path path))
	  (gits '()))
      (loop for folder in folders
	    do
	    (if (filename-matches folder ".git")
		(add-to-list 'gits path)
	      (setq gits (append  gits
				  (repos-in-path (join-path (list path
								  (file-name-nondirectory folder))))))))
      gits)))


(defun extr-git-history (path author since until)
  (let* ((default-directory path)
	 (git-log-string (concat "git log "
				 " --format=\"%aD: %s\""
				 " --author=\"" author "\""
				 " --since=\"" since "\""
				 " --until=\"" until "\""
				 ))
	 (res (shell-command-to-string git-log-string)))
    (if  (> (length res)
	    1)
	(concat "\n" path "\n" res)
      res)))


(defun mc-mite-all-repo-history (root-path from to)
  (interactive "DrootPath:  
sfromDate: 
stoDate: ")
  (with-output-to-temp-buffer "log"
    (princ
     (let ((repositories (repos-in-path root-path)))
       (remove-if 'string-empty-p 
		  (loop for rep in repositories

			collect (extr-git-history rep "Michael Conrads" from to)))
       ))))




(mc-mite-all-repo-history "~/dev/QM/" "2017-01-18" "2017-01-19")

(defun request-json (json)
  (let* ((api-key "74bbf7d1c679a8ec")
	 (api-key-header (concat  "'X-MiteApiKey: " api-key "'"))
	 (curl-command (concat  "curl -s -H " api-key-header " https://quartett-mobile.mite.yo.lk/" json))
	 )

    (shell-command-to-string curl-command)
    ))




(with-output-to-temp-buffer "*response*"
  (princ 
   (mapcar (lambda (x)
	     (format "-%S-\n" (plist-get (plist-get x :service) :name)))
	   (let ((json-object-type 'plist))
	     (json-read-from-string (request-json "services.json")))
	   )))

(request-json "daily.json")




;;(plist-get 
;;       (let ((json-object-type 'plist))
;;	 (json-read-from-string "{\"foo\" : 3}"))
;;       :foo)
;;
;;(alist-get 'a '((a . 4)))



(provide 'mite)

;;; mite.el ends here
