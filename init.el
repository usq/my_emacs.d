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
(use-package scala-mode)

(use-package yasnippet)
(use-package company
  :bind
  ("C-," . company-complete-common)
  :init
  (add-hook 'after-init-hook 'global-company-mode))

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
(use-package dirtree)
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package monokai-theme
  :config
  (load-theme 'monokai))

(use-package restclient)
(use-package simple-httpd)
(use-package cmake-mode)

(use-package reveal-in-osx-finder)

(use-package exec-path-from-shell
  :config
 (exec-path-from-shell-initialize))

(use-package js2-mode
  :bind
  (("C-c [tab]" . json-format)))

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(require 'mac)
(require 'tex)

(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'setup-latex)

(require 'keybindings)
(require 'djinni-mode)
(require 'kaylee-mode)




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

;;flyspell mode
(defun flyspell-switch-dictionary()
  (interactive)
  (let* ((dic ispell-current-dictionary)
         (change (if (string= dic "deutsch8") "english" "deutsch8")))
    (ispell-change-dictionary change)
    (message "Dictionary switched from %s to %s" dic change)
    ))


(put 'upcase-region 'disabled nil)

(require 'my-misc)
