
(require 'magit-popup)

(define-derived-mode hci-mode tabulated-list-mode "hci mode"
  "Major mode for handling hci"
 (setq tabulated-list-format [("cmd" 16 t)("status" 15 t)])
  (setq tabulated-list-padding 2)
;  (setq tabulated-list-sort-key (cons "Image" nil))
  
					;  (add-hook 'tabulated-list-revert-hook 'docker-containers-refresh nil t)
  
  (setq tabulated-list-entries (list (list  1 [("this is command" . nil) "this is status"])
				     (list  2 ["this is command" "this is status"])))
  (tabulated-list-init-header)
  (tablist-minor-mode))



;; (docker-utils-define-popup hci-show
;;   "Popup for copying files from/to containers."
;;   'docker-containers-popups
;;   :man-page "docker-cp"
;;   :actions  '((?F "Copy From" (lambda () t))
;;               (?T "Copy To" (lambda () t))))

(defun list-hci-entries ()
  (progn
    (message "called")
    (list 1 "this is command" "this is status")))

(defun list-hci ()
  (interactive)
  (pop-to-buffer "*hci-mode*" )
  (hci-mode)
  (tabulated-list-print)
  )


(defun filter-fun (a response)
  (message "filter %S %S" a (mapcar (lambda (c) c) response)))


(defun sentinel-fun (x)
  (message "sentinel %S" x))

(let ((proc (hci-open-serial-port "/dev/tty.usbserial-FTH95RWV")))
;  (message "killing proc")
;  (kill-process proc)
  )

;;0x1 0x0 0xFE 0x26 0x4 0x3 0x0 0x0 0x59 0x9 0x0 0x0 0xC 0x0 0xFF 0xD0 0x0 0x0 0x43 0x90 0xF0 0x20 0xDD 0x84 0x1B 0x0 0xC 0xDD 0x84 0x22 0x80 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x1 0x0 0x0 0x0 

;0x4 0xFF 0x6 0x7F 0x6 0x0 0x0 0xFE 0x0 



(defun hci--archive-wrote-bytes (wrote) )

(defun hci--write-hci (proc bytes)
  (process-send-string proc (mapconcat #'char-to-string  bytes ""))
  )

(defun hci--read-hci (proc)
  (let ((read   '(1 2 3 4)))
    (hci--archive-read-bytes read)
    read))


(defun hci-open-serial-port (port)
  (interactive)
  (setq hci-comm nil)
  (let* ((proc (make-serial-process :port port
				    :speed 115200
				    :filter #'filter-fun
				    :sentinel #'sentinel-fun
				    :stopbits 2
				    )))

    (hci--write-hci proc  '(#x1 #x0 #xFE #x26 #x4 #x3 #x0 #x0 #x59 #x9 #x0 #x0 #xC #x0 #xFF #xD0 #x0 #x0 #x43 #x90 #xF0 #x20 #xDD #x84 #x1B #x0 #xC #xDD #x84 #x22 #x80 #x0 #x0 #x0 #x0 #x0 #x0 #x0 #x1 #x0 #x0 #x0))
    proc
))




(provide 'hci-mode)
