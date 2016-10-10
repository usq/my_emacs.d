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

;;;;;;;;;;;;;;; end bootstrapping ;;;;;;;;;;;;;;;

(use-package dash)

(use-package browse-kill-ring
  :bind
  ("C-c y" . browse-kill-ring))

(use-package magit
  :bind
  ("C-x m" . magit-status))

(use-package ibuffer
  :bind
  ("C-x C-b" . ibuffer))

(use-package multiple-cursors
  :bind
  ("H-SPC" . set-rectangular-region-anchor))

(use-package swift-mode)
(use-package yasnippet)
(use-package company)
(use-package company-sourcekit
  :config
  (add-to-list 'company-backends 'company-sourcekit))


(use-package paredit
  :diminish paredit-mode
  :init
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
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
  :config
  (setq ace-jump-mode-case-fold -1)
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

(require 'mac)
(require 'tex)

(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'setup-latex)

(require 'keybindings)
(require 'my-misc)
(require 'djinni-mode)

;;look at workgroups
;;https://github.com/pashinin/workgroups2

;;look at helm
;;https://emacs-helm.github.io/helm/#introduction
(use-package helm
  :ensure t
  :bind
  ("C-c o" . helm-occur)
  :config
  (progn
    (require 'helm-config)
    (helm-mode 1)
    (setq helm-locate-fuzzy-match t
	  helm-apropos-fuzzy-match t)))

;;(helm-command-prefix)
