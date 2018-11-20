
;;; Code:

(require 'hide-lines)

(defvar qmlog-font-lock-defaults nil "Value for `font-lock-defaults'.")
(defvar lineregexp nil)

lineregexp
"^\\([VDIE]\\) \\(\\(\\([0-9][0-9]\\)/\\([0-9][0-9]\\)/\\([0-9][0-9]\\)\\)? [0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]\\) \\[\\([a-zA-Z]+\\)\\]\\(([0-9]+)\\)[	]+\\[\\([A-Za-z]+\\) -?\\([\\[(_:)a-z A-Z]+\\]?\\(?:_block_invoke\\(?:_2\\)?\\)?\\):\\([0-9]+\\)\\] - \\(.*\\)"



(defvar qmlog-mode-map nil "Keymap for `qmlog-mode'.")
(defvar -qmlog-start-regex nil)
(defvar -qmlog-module-regex nil)
(defvar -qmlog-hidden-logs '())
(defvar -qmlog-module-group-num 7)
;; collapse all
;; filter log level
(defun mc-re-group (str)
  "Surrounds STR with \\( and \\)."
  (concat "\\(" str "\\)"))




(let* ((loglevel "[VDIE]")
       (timestamp "\\(\\([0-9][0-9]\\)/\\([0-9][0-9]\\)/\\([0-9][0-9]\\) \\)?[0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]")
       (modulename "[a-zA-Z]+")
       (ignore1 "([0-9]+)")
       (location "\\[\\([A-Za-z]+\\) -?\\([\\[(_:)a-z A-Z]+\\]?\\(?:_block_invoke\\(?:_2\\)?\\)?\\):\\([0-9]+\\)\\]"))

  (setq -qmlog-start-regex (concat "^" loglevel " " timestamp))
  (setq lineregexp (concat "^"
			   (mc-re-group loglevel) " "
			   (mc-re-group timestamp) " "
			   "\\[" (mc-re-group modulename) "\\]"
			   (mc-re-group ignore1) "[\t]+"
			   location " - "
			   "\\(.*\\)"))

  (setq -qmlog-module-regex (concat -qmlog-start-regex " \\[" (mc-re-group modulename) "\\]"))
  
  (setq qmlog-font-lock-defaults
	`((,lineregexp
	   (1 font-lock-function-name-face)
	   (2 font-lock-variable-name-face)
	   (-qmlog-module-group-num font-lock-comment-delimiter-face) ;;7 is module name
	   (8 font-lock-constant-face)
	   (9 font-lock-function-name-face)
	   (10 font-lock-variable-name-face)
	   (11 font-lock-type-face)
	   ))))

(defun qmlog-prev-line ()
  "Go to previous log message."
  (interactive)
  (re-search-backward -qmlog-start-regex nil t))

(defun qmlog-next-line ()
  "Go to next log message."
  (interactive)
  (forward-line)
  (re-search-forward -qmlog-start-regex nil t)
  (beginning-of-line))

(defun qmlog-copy-log-message ()
  "Copy current log message."
  (interactive)
  (save-excursion
    (copy-region-as-kill (point)  (- (re-search-forward -qmlog-start-regex nil t 2) 14)))
  (message "Copied message to buffer"))


(require 's)
(defun qmlog-hide (modulename)
  (interactive
   (list
    (let ((current (-qmlog-module-from-current-line)))
      (read-string (format "Don't show logs from module [%s]: " current)
		   nil nil current))))

  (add-to-list '-qmlog-hidden-logs modulename)
  
  (hide-lines-show-all)
  
  (let ((start (concat -qmlog-start-regex " \\[" (s-join "\\|" -qmlog-hidden-logs) "\\]"))
	(end -qmlog-start-regex))
    (hide-blocks-matching start end))
  )

(defun -qmlog-module-from-current-line ()
  (beginning-of-line)
  (re-search-forward -qmlog-module-regex)
  (match-string 5)
  )

(defun qmlog-filter (modulename)
  "Show only log messages from MODULENAME."
  (interactive (list
		(let ((current (-qmlog-module-from-current-line)))
                  (read-string (format "Only show logs from module [%s]: " current)
			       nil nil current))))

  (hide-lines-show-all)
  (message "hide %s" modulename)
  (let ((start (concat -qmlog-start-regex " \\[" modulename "\\]"))
	(end -qmlog-start-regex))
    (hide-blocks-not-matching start end)))

(defvar qmlog/old-mode-string)
(defvar qmlog/new-mode-string)

(defun qmlog-reset-filter ()
  "Clear all filters."
  (interactive)
  (hide-lines-show-all)
  (setq -qmlog-hidden-logs '())
  (setq mode-line-format qmlog/old-mode-string))


(progn
  (setq qmlog-mode-map (make-sparse-keymap))
  (define-key qmlog-mode-map (kbd "p") 'qmlog-prev-line)
  (define-key qmlog-mode-map (kbd "n") 'qmlog-next-line)
  (define-key qmlog-mode-map (kbd "c") 'qmlog-copy-log-message)
  (define-key qmlog-mode-map (kbd "f") 'qmlog-filter)
  (define-key qmlog-mode-map (kbd "k") 'qmlog-hide)
  (define-key qmlog-mode-map (kbd "a") 'qmlog-reset-filter)
  (define-key qmlog-mode-map (kbd "q") 'qmlog-reset-filter)
  (define-key qmlog-mode-map (kbd "l") 'toggle-truncate-lines))

(define-derived-mode qmlog-mode fundamental-mode "QM Log"
  "QM Log mode"
  (setq font-lock-defaults '(qmlog-font-lock-defaults))
  (setq buffer-read-only t)
  (set (make-variable-buffer-local 'global-hl-line-mode) nil)
  (setq qmlog/old-mode-string mode-line-format))

(provide 'qmlog)
;;; qmlog ends here
