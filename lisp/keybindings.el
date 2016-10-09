(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)


(windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "<s-right>") 'windmove-right)
(global-set-key (kbd "<s-left>") 'windmove-left)
(global-set-key (kbd "<s-up>") 'windmove-up)
(global-set-key (kbd "<s-down>") 'windmove-down)

(define-key global-map (kbd "C-c j") 'ace-jump-mode)

;; Magit
(global-set-key (kbd "C-x m") 'magit-status)
(autoload 'magit-status "magit")


(provide 'keybindings)
