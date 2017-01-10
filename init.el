;;; package --- Summary
;;; Commentary:
;;; Code:
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

(package-refresh-contents)

;;;;;;;;;;;;;;; end bootstrapping ;;;;;;;;;;;;;;;

(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(use-package dash)
(use-package google-this)
(use-package sgml-mode)
(use-package hideshow
  :config
  (add-to-list 'hs-special-modes-alist
	       '(nxml-mode
		 "<!--\\|<[^/>]*[^/]>"
		 "-->\\|</[^/>]*[^/]>"

		 "<!--"
		 sgml-skip-tag-forward
		 nil))
  :init
  (add-hook 'nxml-mode-hook 'hs-minor-mode)
  :bind
  ("C-c h" . hs-toggle-hiding))

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

(use-package company
  :bind
  ("C-," . company-complete-common)
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-jedi
  :config
  (add-to-list 'company-backends 'company-jedi)
  (add-hook 'python-mode-hook 'my/python-mode-hook))

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

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (unbind-key "C-c +" \-mode-map))

;; (use-package monokai-theme
;;   :config
;;   (load-theme 'monokai))

(use-package  color-theme-sanityinc-tomorrow
  :config
  (color-theme-sanityinc-tomorrow-night))

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

(use-package org
  :ensure t        ; But it comes with Emacs now!?
  :init
  (setq org-use-speed-commands t
        org-return-follows-link t
        org-hide-emphasis-markers t
        org-completion-use-ido t
        org-outline-path-complete-in-steps nil
        org-src-fontify-natively t   ;; Pretty code blocks
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil
        org-todo-keywords '((sequence "TODO(t)" "DOING(g)" "|" "DONE(d)")
                            (sequence "|" "CANCELED(c)")))
  (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
  
  :bind
  (("C-c l" . org-store-link)
   ("C-c c" . org-capture))
  :config
  ;; we use C-c + for org-mode-map
  (unbind-key "C-c +" org-mode-map)
  (unbind-key "C-c -" org-mode-map)
  (font-lock-add-keywords            ; A bit silly but my headers are now
   'org-mode `(("^\\*+ \\(TODO\\) "  ; shorter, and that is nice canceled
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "⚑")
                          nil)))
               ("^\\*+ \\(DOING\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "⚐")
                          nil)))
               ("^\\*+ \\(CANCELED\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "✘")
                          nil)))
               ("^\\*+ \\(DONE\\) "
                (1 (progn (compose-region (match-beginning 1) (match-end 1) "✔")
                          nil)))))

  (define-key org-mode-map [remap org-return] (lambda () (interactive)
                                                (if (org-in-src-block-p)
                                                    (org-return)
                                                  (org-return-indent))))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh . t)
     (python . t)
     (dot . t)
     ))

  ;; Make windmove work in org-mode:
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right))

(use-package projectile)

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

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
    (setq helm-locate-fuzzy-match t
	  helm-apropos-fuzzy-match t)))

;;clojure
(use-package cider)

(require 'mac)
(require 'tex)

(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'setup-latex)

(require 'keybindings)
(require 'djinni-mode)
(require 'kaylee-mode)


(require 'my-misc)
(require 'mite)

;;; init.el ends here


