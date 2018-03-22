;;; Code:

;; contains mite-api-key
(require 'hidden)
(require 'json)
(require 'dash)
(require 'request)
(require 'cl)


;; check https://github.com/Malabarba/Nameless
(defun mite--minutes-to-hours-and-minutes (mins)
  "Convert MINS to HH:MM form."
  (if (= mins -1)
      "-----"
    (let* ((h (/ mins 60))
	   (m (% mins 60)))
      (format "%02d:%02d" h m))))


(defun mite--parse-time_entry (it)
  (let ((entry (-pl-at it "time_entry")))
    (mite--make-data-list-entry (-pl-at entry "id")
				(-pl-at entry "customer_name")
				(-pl-at entry "service_name")
				(-pl-at entry "note")
				(-pl-at entry "minutes"))))

(defun mite--make-data-list-entry (id project-name service-name note minutes)
  (list :id id
	:project_name project-name
	:service_name service-name
	:note note
	:minutes minutes))

(defun mite--time_entry-to-tabulated (it)
  (list (-pl-at it :id)
	(vector 
	 (-pl-at it :project_name)
	 (-pl-at it :service_name)
	 (mite--minutes-to-hours-and-minutes (-pl-at it :minutes))
	 (decode-coding-string (-pl-at it :note) 'utf-8))))

;;; helper
(defun -pl-at (pl &rest keys)
  (if (and keys (listp pl) (>= (length pl) 2))
      (apply #'-pl-at (lax-plist-get pl (car keys)) (cdr keys))
    pl))


(custom-set-variables '(request-log-level 'debug)
		      '(request-message-level 'debug))


(defun mite--request (endpoint fn-success &optional fn-error)
  (request (concat "https://quartett-mobile.mite.yo.lk/" endpoint)
	   :headers (list (cons "X-MiteApiKey" mite-api-key))
	   :parser (lambda ()
	   	     (let ((json-object-type 'plist)
	   		   (json-array-type 'list)
	   		   (json-key-type 'string))
	   	       (json-read)))
	   :sync t
	   :success
	   (function* 
	    (lambda (&key data &allow-other-keys)
	      (funcall fn-success data)))
	   :error
	   (function*
	    (lambda (&key error-thrown &key symbol-status &key response &allow-other-keys)
	      (unless (null fn-error)
		(funcall fn-error error-thrown symbol-status))))))

(defun mite--data-footer (minute-summary)
  (list :id (1+ (-pl-at (car (last mite--data-list)) :id))
	:project_name ""
	:service_name ""
	:note ""
	:minutes (if minute-summary
		     (--reduce-from (+ acc (-pl-at it :minutes)) 0 mite--data-list)
		   -1)))

(defun mite-list-today ()
  "List all entries for today."
  (interactive)
  (mite--request (format-time-string "daily/%Y/%m/%d.json")
		 (lambda (json)
		   (let* ((internal-map (-map #'mite--parse-time_entry json))
			   (list-map (-map #'mite--time_entry-to-tabulated internal-map))
			   )
		     (setq mite--data-list internal-map)
		     ;;last entry
		     (setq mite--current-list (append list-map (list
								(mite--time_entry-to-tabulated (mite--data-footer nil))
								(mite--time_entry-to-tabulated (mite--data-footer t)))))
		     (pop-to-buffer "*mite-mode*" )
		     (mite-mode)  
		     (tabulated-list-print)))))


;;  Alle Zeiteinträge eines Tages auflisten
;;  Listet alle Zeiteinträge des aktuellen Benutzers am heutigen Tag auf.
;;  GET /daily.json
;;  Was einfach ein Alias für die längere Variante mit Parametern ist:

;;  GET /time_entries.json?user_id=current&at=today
;;  Listet alle Zeiteinträge des aktuellen Benutzers am 7. Februar 2015 auf.

;;  GET /daily/2015/2/7.json
;;  Was wiederum das gleiche Ergebnis liefert wie:

;; GET /time_entries.json?user_id=current&at=2015-02-07

(require 'widget)
     
(eval-when-compile
  (require 'wid-edit))


(defun mite-add-entry-today ()
  (interactive)
       (switch-to-buffer "*Create mite entry*")
       (kill-all-local-variables)
       (let ((inhibit-read-only t))
         (erase-buffer))
       (remove-overlays)
       (widget-insert "Add Mite entry\n\n")
       (widget-create 'editable-field
                      :format "Note: %v"
                      "")

       (widget-create 'editable-field
                      :format "Time: %v"
                      "00:00")

       (widget-insert " Project\n")
       (widget-create 'radio-button-choice
                      :value "Audi"
                      :notify (lambda (widget &rest ignore)
                                (message "You selected %s"
                                         (widget-value widget)))
                      '(item "Audi")
		      '(item "PiPa")
                      '(item "PHP"))
       (widget-insert "\n")
       (widget-insert " Service\n")
       (widget-create 'radio-button-choice
                      :value "Framework"
                      :notify (lambda (widget &rest ignore)
                                (message "You selected %s"
                                         (widget-value widget)))
                      '(item "Framework")
		      '(item "Development")
                      '(item "Projektorganisation"))
       (widget-insert "\n")
       
       (widget-insert " ")
       (widget-create 'push-button
                      :notify (lambda (&rest ignore)
                                (message "create entry"))
                      "Send")
       (widget-insert "\n ")
       (widget-create 'push-button
                      :notify (lambda (&rest ignore)
				(kill-buffer))
                      "Quit")
       (use-local-map widget-keymap)
       (goto-char (buffer-end -1))
       (widget-setup))

(define-derived-mode mite-mode tabulated-list-mode "mite mode"
  "Major mode for mite"
  (setq tabulated-list-format [("Project" 16 t) ("Service" 30 t) ("Time" 10 nil) ("Note" 15 nil)])
  (setq tabulated-list-padding 2)
  (add-hook 'tabulated-list-revert-hook 'docker-containers-refresh nil t)
  (setq tabulated-list-entries #'mite--list-for-today)
  (tabulated-list-init-header)
  (define-key mite-mode-map (kbd "+") 'mite-add-entry-today)
  (tablist-minor-mode))

(setq mite--current-list nil)
(setq mite--data-list nil)
(defun mite--list-for-today ()
  mite--current-list)



;; GET /daily/2015/2/7.json

(provide 'mite-mode)
;;; 


