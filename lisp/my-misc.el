

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
 
  (let* ((m (get-m))
	 (l (subseq (split-string all "") 1 7))
	 (e1 (subseq l 0 2))
	 (e2 (subseq l 2 4))
	 (e3 (subseq l 4 6))
	 
	 (t1 (acc-map (intern (first e1))
	      (string-to-number (second e1)) m))
	 (t2 (acc-map (intern (first e2)) (string-to-number (second e2)) m))
	 (t3 (acc-map (intern (first e3)) (string-to-number (second e3)) m))
	 (final (concat (symbol-name t1)
		     (symbol-name t2)
		     (symbol-name t3))))
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

(add-to-list 'auto-mode-alist '("Catalyzer" . kaylee-mode))
(add-to-list 'auto-mode-alist '("Catalyzer.override" . kaylee-mode))
(add-to-list 'auto-mode-alist '("Catalyzer.source" . kaylee-mode))
(add-to-list 'auto-mode-alist '("Catalyzer.fixed" . kaylee-mode))


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
  (shell-command "gittower ."))

(defun pwd-kill ()
  (interactive)
  (let* ((pwd (pwd)))
    (kill-new (replace-regexp-in-string "Directory " "" pwd))))


(defun rotate-windows (arg)
  "Rotate your windows; use the prefix argument ARG to rotate the other direction."
  (interactive "P")
  (if (not (> (count-windows) 1))
      (message "You can't rotate a single window!")
    (let* ((rotate-times (prefix-numeric-value arg))
           (direction (if (or (< rotate-times 0) (equal arg '(4)))
                          'reverse 'identity)))
      (dotimes (_ (abs rotate-times))
        (dotimes (i (- (count-windows) 1))
          (let* ((w1 (elt (funcall direction (window-list)) i))
                 (w2 (elt (funcall direction (window-list)) (+ i 1)))
                 (b1 (window-buffer w1))
                 (b2 (window-buffer w2))
                 (s1 (window-start w1))
                 (s2 (window-start w2))
                 (p1 (window-point w1))
                 (p2 (window-point w2)))
            (set-window-buffer-start-and-point w1 b2 s2 p2)
            (set-window-buffer-start-and-point w2 b1 s1 p1)))))))

;;flyspell mode
(defun flyspell-switch-dictionary()
  "toggles between english and german dictionary for flyspell mode"
  (interactive)
  (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "deutsch8") "english" "deutsch8")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)))


(provide 'my-misc)
;;; my-misc ends here

