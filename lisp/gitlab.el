;;; package --- Summary
;;; Commentary:

;;; Code:
(require 'cl-lib)
(require 'request)
(require 'deferred)
(require 'request-deferred)

(defvar gitlab-token "qVqs1hHWLz59Ns6GuWRe")
(cl-defstruct project)


(defun tes (te endpoint)
  (deferred:$
    
    (request-deferred
     (concat "git.quartett-mobile.de/api/v4/project/" endpoint)
     :headers '(("Content-Type" . "application/json")
		("Private-Token" . gitlab-token))
     :parser 'json-read)

    (deferred:nextc it
      (lambda (response)
	(funcall te response)
;	(message "Got: %S" (request-response-data response))
	))
    ))

(tes (lambda (x)
       (message "Got: %S" (request-response-data response))
       )
     "conrads/testproj")





(defun req (lambd endpoint)
  (request
   (concat "git.quartett-mobile.de/api/v4/project/" endpoint)
   :headers '(("Content-Type" . "application/json")
	      ("Private-Token" . gitlab-token))
   :parser 'json-read
   :success (function*
             (lambda (&key data &allow-other-keys)

	       (funcall lambd data)
	       ))
   ))


(req (lambda (d)
       (debug)
       d
       (message "got: %S"  (assoc 'web_url d))
	       )
     "kaylee")






(provide 'gitlab)
;;; gitlab.el ends here
