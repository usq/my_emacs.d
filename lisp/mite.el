
;;; Code:
(require 'cl-lib)

(defun hello(x &key a b)
    (list x a b))

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


(defun all-repo-history (root-path from to)
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


;;(all-repo-history "~/dev/QM/" "2016-12-01" "2016-12-24")


(provide 'mite)
;;; mite.el ends here
