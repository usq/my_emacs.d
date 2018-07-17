
(require 'js2-mode)
(require 'f)
(defun add-format-json-to-js2-mode () (define-key js2-mode-map (kbd "C-x TAB") 'json-format))
(add-hook 'js2-mode-hook 'add-format-json-to-js2-mode)

(defun show-in-finder ()
  (interactive)
  (reveal-in-osx-finder))

(defun acc-map (key n m)
  (nth (- n 1) (caddr (assoc key m))))

(require 'keep)
(defun mc-tfl (all)
  (interactive
   "Menterall: 
")

  (defun named (x)
    (if (symbolp x)
	(symbol-name x)
      (number-to-string x)))

  (let* ((m (get-m))
	 (l (subseq (split-string all "") 1 7))
	 (e1 (subseq l 0 2))
	 (e2 (subseq l 2 4))
	 (e3 (subseq l 4 6))
	 
	 (t1 (acc-map (intern (first e1))
	      (string-to-number (second e1)) m))
	 (t2 (acc-map (intern (first e2)) (string-to-number (second e2)) m))
	 (t3 (acc-map (intern (first e3)) (string-to-number (second e3)) m))
	 (final (concat (named t1)
		     (named t2)
		     (named t3))))
    (paste-to-osx final)
    (message final)))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun mc-calc-fl (amount start-course)
  (interactive "MAmount: 
MStartValue: ")
  (catch 'end

  (let ((end nil))
    (while (not end)
;      	    (debug)
      (let ((new-course (read-string (concat "New Course (start: " start-course "): "))))
	(let* (
	       (a (string-to-number amount))
	       (start (string-to-number start-course))
	       (start-value (* a start))
	       (new (string-to-number new-course))
	       (new-value (* a new))
	       (win (- new-value start-value))
	       (st (format "with course %s and amount %s, you win %0.3f   (original: %s * %s was %0.3f)" new a win start a start-value))
	       (cont (read-string (concat st " continue? [y/nq]")))
	       )
	  
	  (if (or (equalp cont "q") (equalp cont "n"))
	      (throw 'end 1))
	  )
	)))))

(defun tum-address ()
  (interactive)
  (message "Boltzmannstr 3, 85748 München"))

(defun qm-address ()
  (interactive)
  (message "Walter-Gropius-Straße 17, 80807 München"))


(defun print-shell-variable ()
  (interactive)
  (let* ((var (thing-at-point 'symbol))
	 (echo (concat "echo \"" var ": ${" var "}\"")))
    (end-of-line)
    (newline)
    (insert echo)))

;; (defun -to_ ()
;;   (interactive)
;;   (replace-string "-" "_" )

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))

(defun gittower ()
  (interactive)
  (let ((tries 0)
	(found nil)
	(dir (f-dirname (f-this-file))))

    (while (and (< tries 5)
		(null found))
      
      (if (f-exists? (f-join dir ".git"))
	  (progn
	    (setq found t)
	    (shell-command (concat "gittower " dir)))
	(progn
	  (incf tries)
	  (setq (apply #'f-join (butlast (f-split dir)))))))))




(defun pwd-kill ()
  (interactive)
  (let* ((pwd (pwd)))
    (kill-new (replace-regexp-in-string "Directory " "" pwd))))

;;flyspell mode
(defun flyspell-switch-dictionary()
  "toggles between english and german dictionary for flyspell mode"
  (interactive)
  (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "deutsch8") "english" "deutsch8")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)))

(defvar *mc-dired-file-to-copy* nil)
(defun mc-dired-copy ()
  "Copies the path at point in dired buffer"
  (interactive)
  (let ((path (dired-filename-at-point)))
    (message path)
    (setq *mc-dired-file-to-copy* path))
  )

(defun mc-dired-paste ()
  (interactive)
  (if (not (null *mc-dired-file-to-copy*))
      (let* ((source-file *mc-dired-file-to-copy*)
	     (file-name (file-name-nondirectory source-file))
	     (current-directory (dired-current-directory))
	     (new-file (concat current-directory file-name)))

	(if (directory-p source-file)
	    (copy-directory source-file new-file)
	    (copy-file source-file  new-file 1))
	
	(revert-buffer))
    (message "nothing copied!")))

(defun mc-dired-run-in-shell ()
  (interactive)
  (let ((file (dired-filename-at-point)))
    (let ((p (get-process (concat file "-process")))
	  (p2 (get-process (concat file "-process<1>")) ))

      (when (not (null p))
	(interrupt-process p)
	(message "killing proc"))

      (when (not (null p2))
	(interrupt-process p2)
	(message "killing proc<1>")))
    
    
    (if (file-executable-p file)
	(start-process-shell-command (concat file "-process") file file)
      (start-process-shell-command (concat file "-process") file (concat "sh " file)))
    (display-buffer file t t)))

(defun mc-empty-buffer ()
  (interactive)
  (let ((name (generate-new-buffer-name "temp")))
    (generate-new-buffer name)
    (switch-to-buffer-other-window name)))

(defun mc-two-empty-buffers ()
  (interactive)
  (mc-empty-buffer)
  (mc-empty-buffer))

(defun mc-insert-pwd ()
  (interactive)
  (pwd t))

(defun mc-orga ()
  (interactive)
  (find-file "~/dev/QM/qm.org"))


(defun snake_case-to-camelCase ()
  "Convert aa_bb to aaBb in region."
  (interactive)
  (when (use-region-p)
    (let ((regex "\\([a-z]\\)_\\([a-z]\\)"))
      (goto-char (region-beginning))
      (while (re-search-forward regex nil t)
	(replace-match (concat (match-string 1) (upcase (match-string 2)))
		       t)))))

(defun camel-case-to_snake_case ()
  (interactive)
  (let* ((bounds (bounds-of-thing-at-point 'symbol))
	 (word (buffer-substring-no-properties (car bounds) (cdr bounds)))
	 (regex "\\([a-z][A-Z]\\)"))
    (message "%s" word)

    )
  )

(defun mc-open-file-at-point ()
  (interactive)
  (start-process "external" nil "open" (dired-get-filename)))


(defun zoom-text-in ()
  (interactive)
  (text-scale-increase 1))

(defun zoom-text-out ()
  (interactive)
  (text-scale-decrease 1))

(provide 'my-misc)
;;; my-misc ends here

