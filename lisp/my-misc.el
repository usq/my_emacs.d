(defun add-format-json-to-js2-mode () (define-key js2-mode-map (kbd "C-x TAB") 'json-format))
(add-hook 'js2-mode-hook 'add-format-json-to-js2-mode)

(defun show-in-finder ()
  (interactive)
  (reveal-in-osx-finder))

(defun tum-address ()
  (interactive)
  (message "Boltzmannstr 3, 85748 München"))

(defun qm-address ()
  (interactive)
  (message "Walter-Gropius-Straße 17, 80807 München"))

(provide 'my-misc)

