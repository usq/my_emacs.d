(package-initialize)

(setq message-log-max 10000)

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "lisp/")))
(load custom-file)

(setq load-prefer-newer t)

(require 'packages)

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))
(setq use-package-always-ensure t)
;;;;;;;;;;;;;;; end bootstrapping

(require 'mac)
(require 'tex)

(use-package dash)

(use-package magit
  :bind
  ("C-x m" . magit-status))

(use-package paredit
  :diminish paredit-mode
  :init
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'ielm-mode-hook 'enable-paredit-mode)
  (add-hook 'json-mode-hook 'enable-paredit-mode))


(use-package auctex-latexmk)

(use-package undo-tree
  :bind
  ("C-x u" . undo-tree-visualize))

(use-package flx)
(use-package flx-ido
  :ensure t
  :init
  (setq ido-use-faces nil)
  :config
  (flx-ido-mode 1))


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

(use-package reveal-in-osx-finder)

(use-package js2-mode
  :bind
  (("C-c [tab]" . json-format)))


(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'setup-latex)

(require 'keybindings)
(require 'my-misc)
(require 'djinni-mode)

