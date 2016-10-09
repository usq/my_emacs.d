(package-initialize)

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))
(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "lisp/")))
(load custom-file)

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
		    ace-jump-mode
		    monokai-theme
		    ))

(require 'mac)
(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)

(require 'keybindings)
