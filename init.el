(package-initialize)

(setq message-log-max 10000)


(add-to-list 'load-path (concat user-emacs-directory "lisp/"))
(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "lisp/")))
(load custom-file)

(setq load-prefer-newer t)
(setq use-package-always-ensure t)
(require 'packages)
(packages-install '(
		    use-package
		    ))

(use-package magit
  :bind
  ("C-x m" . magit-status))

(use-package paredit)
(use-package flx)
(use-package flx-ido)
(use-package ido-vertical-mode)
(use-package ido-at-point)
(use-package ido-ubiquitous)
(use-package smex
  :bind
  (("M-x" . smex)
   ("M-X" . smex-major-mode-commands)))
  

(use-package ace-jump-mode
  :bind
  (("C-." . ace-jump-mode)
   ("C-c j" . ace-jump-mode)))

(use-package smartparens)
(use-package direx)

(use-package monokai-theme
  :config
  (load-theme 'monokai))

(use-package restclient)
(use-package simple-httpd)

(require 'mac)
(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'keybindings)
(require 'my-misc)
