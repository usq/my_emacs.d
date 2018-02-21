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
    (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;; end bootstrapping ;;;;;;;;;;;;;;;
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

;; always indet everything
(use-package aggressive-indent
  :defer t
  :config
  (global-aggressive-indent-mode 1))

(use-package dash  :defer t)
(use-package sgml-mode  :defer t)
(use-package hideshow
  :defer t
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
  :defer t
  :bind
  ("C-c y" . browse-kill-ring))

(use-package magit
  :bind
  ("C-x m" . magit-status))

(use-package ibuffer
  :bind
  ("C-x C-b" . ibuffer))

(use-package multiple-cursors
  :defer t
  :bind
  ("H-SPC" . set-rectangular-region-anchor))

(use-package swift-mode :defer t)

(use-package yasnippet :defer t :ensure t
  :config
  (setq yas-snippet-dirs
	'("~/.emacs.d/snippets")))

(use-package company
  :bind
  ("C-," . company-complete-common)
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-jedi
  :config
  (add-to-list 'company-backends 'company-jedi))

(use-package paredit
  :defer t
  :diminish paredit-mode
  :init
  (add-hook 'clojure-mode-hook 'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
  (add-hook 'json-mode-hook 'enable-paredit-mode))

(use-package groovy-mode :defer t)
(use-package auctex-latexmk :defer t)
(use-package typescript-mode :defer t)
(use-package angular-mode :defer t)
(use-package undo-tree
  :bind
  ("C-x u" . undo-tree-visualize)
  ("C-?" . undo-tree-redo))

(use-package flx)
(use-package flx-ido
  :ensure t
  :init
  (setq ido-use-faces nil)
  :config
  (flx-ido-mode 1))

(use-package ido-vertical-mode)
(use-package ido-at-point)
(use-package ido-completing-read+)
(use-package smex
  :bind
  (("M-x" . smex)
   ("M-X" . smex-major-mode-commands)))

(use-package ace-jump-mode
  :defer t
  :config
  (setq ace-jump-mode-case-fold -1)
  :bind
  (("C-." . ace-jump-mode)
   ("C-c j" . ace-jump-mode)))

(use-package smartparens)
(use-package direx)
(use-package dirtree :defer t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (unbind-key "C-c +" flycheck-mode-map))


(use-package restclient)
(use-package simple-httpd)
(use-package cmake-mode)

(use-package reveal-in-osx-finder :defer t)

(use-package exec-path-from-shell
  :ensure t
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

(use-package dimmer
  :init
  (setq dimmer-percent 0.3)
  :config
  (dimmer-mode))

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
	org-agenda-ndays 7
	org-clock-in-resume t
	org-clock-report-include-clocking-task t
	org-agenda-window-setup 'current-window
	org-agenda-span 1 ;;start agenda in day instead week
        org-todo-keywords '((sequence "TODO(t)" "|" "DOING(g)" "WAITING(w)" "|" "DONE(d)")
                            (sequence "|" "CANCELED(c)")))
  (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))
  :bind
  (("C-c l" . org-store-link)
   ("C-c c" . org-capture))
  :config
  ;; we use C-c + for org-mode-map
  (unbind-key "C-c +" org-mode-map)
  (unbind-key "C-c -" org-mode-map)
  (unbind-key "<S-left>" org-mode-map)
  (unbind-key "<S-right>" org-mode-map)
  (unbind-key "<S-up>" org-mode-map)
  (unbind-key "<S-down>" org-mode-map)
  (define-key org-mode-map [remap org-return] (lambda () (interactive)
                                                (if (org-in-src-block-p)
                                                    (org-return)
                                                  (org-return-indent))))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh . t)
     (python . t)
     (dot . t)
     (latex . t)
     ))
  
  (add-hook 'org-mode-hook 'jira-link-mode)
    
  ;; Make windmove work in org-mode:
  (add-hook 'org-shiftup-final-hook 'windmove-up)
  (add-hook 'org-shiftleft-final-hook 'windmove-left)
  (add-hook 'org-shiftdown-final-hook 'windmove-down)
  (add-hook 'org-shiftright-final-hook 'windmove-right))

;; fix org table layout
(defun my-org-clocktable-indent-string (level)
  (if (= level 1)
      ""
    (let ((str "^"))
      (while (> level 2)
        (setq level (1- level)
              str (concat str "--")))
      (concat str "-> "))))
(advice-add 'org-clocktable-indent-string :override #'my-org-clocktable-indent-string)


;;;; look at https://www.suenkler.info/notes/emacs-config/
(use-package neotree
  :ensure t
  :config (setq neo-window-width 40)
  :bind ("C-c t" . neotree))

(use-package which-key
  :config
  (which-key-mode))

(use-package ace-window
  :ensure t
  :init
   (progn
    (global-set-key [remap other-window] 'ace-window)
    (custom-set-faces
     '(aw-leading-char-face
       ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

(use-package projectile
  :bind
  ("C-c p f" . projectile-find-file)
  ("C-c p p" . projectile-switch-project))

(use-package wolfram
  :defer t
  :config
  (setq wolfram-alpha-app-id "7L7LE4-HHWQGE9TG6"))

(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package rainbow-delimiters)


;;;; follow-mode!!!!!!!!!!!!!!!!!

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

(use-package rotate :defer t)
(use-package json-snatcher :defer t)

;; hydra
(use-package hydra :ensure t :defer t)
(require 'hydras)

(use-package tidy :defer t)

;;clojure
(use-package cider
  :ensure t
  :pin MELPA-Stable
  :config
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (setq cider-repl-use-pretty-printing t))

;; kotlin
(use-package flycheck-kotlin)
(use-package kotlin-mode)

(require 'themes)
(require 'mac)
(require 'tex)

(require 'appearance)

(require 'setup-ido)
(require 'setup-magit)
(require 'setup-latex)

(require 'keybindings)
(require 'djinni-mode)
(require 'kaylee-mode)
(add-to-list 'auto-mode-alist '("Catalyzer.*\\'" . kaylee-mode))

(require 'my-misc)
(require 'mite)
(require 'jira)

;;; fix horrible eshell behaviour
(add-hook
 'eshell-mode-hook
 (lambda ()
   (setq pcomplete-cycle-completions nil)
   (setq pcomplete-ignore-case t)))

(put 'downcase-region 'disabled nil)

;;fix latex _ fuckup
(setq LaTeX-verbatim-environments-local '("Verbatim" "lstlisting"))

;;disable f*in keyboard-escape-quit
(defun keyboard-escape-quit () (interactive))

(require 'mc-snippets)

;;; https://github.com/gongo/json-reformat
(use-package json-reformat)
(use-package s)
(require 'zen-mode)
(require 'org-config)
(require 'qmlog)

(use-package docker
  :config
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq explicit-shell-file-name "bash"))

(use-package docker-tramp)

;;;;; REPOSITORIES
(add-to-list 'load-path (concat user-emacs-directory "repos"))

(use-package fireplace)

(require 'server)
(add-hook 'after-init-hook (lambda ()
                             (unless (or (daemonp) (server-running-p))
                               (server-start)
                               (setq server-raise-frame t))))


(find-file "~/Dropbox/org/qm.org")

;;;todo
;; check out tabulated-list-mode

;;; init.el ends here
