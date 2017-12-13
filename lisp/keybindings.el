;;; Package --- Summary
;;; Commentary:
;;; Code:
(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)
(windmove-default-keybindings) ;; Shift+direction

(global-set-key (kbd "C-c (") 'start-kbd-macro)
(global-set-key (kbd "C-c )") 'end-kbd-macro)

(global-set-key (kbd "C-c /") 'comment-or-uncomment-region)

(global-set-key (kbd "C-c +") (lambda ()
				(interactive)
				(enlarge-window 5)))

(global-set-key (kbd "C-c -") (lambda ()
				(interactive)
				(shrink-window 5)))

(global-set-key (kbd "C-c a") 'org-agenda)

(global-set-key (kbd "C-c e") 'eval-print-last-sexp)
(global-set-key (kbd "C-c C-b") 'browse-url)


(global-unset-key (kbd "C-j"))
(global-unset-key (kbd "C-j"))
(global-set-key (kbd "C-j") 'ace-jump-char-mode)

(global-set-key (kbd "C-c k") 'kaylee-switch)

(global-unset-key (kbd "C-x C-c"))

(provide 'keybindings)
;;; keybindings.el ends here


