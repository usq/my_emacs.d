(package-initialize)

(setq inhibit-startup-message t)

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;;mac
(require 'mac)

;;appearance
(require 'appearance)

(require 'packages)

(packages-install '(
		    magit
		    paredit
		    flx
		    flx-ido
		    ido-vertical-mode
		    ido-at-point
		    ido-ubiquitous
		    smex
		    ))

(require 'setup-ido)

(global-set-key (kbd "C-x m") 'magit-status)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)







