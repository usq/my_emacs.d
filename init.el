;;; package --- Summary
;;; Commentary:
;;; Code:

;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(defvar mc/gc-cons-threshold--orig gc-cons-threshold)
(setq gc-cons-threshold (* 100 1024 1024)) ;100 MB before garbage collection

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

;; always indent everything
(use-package aggressive-indent
  :defer t
  :config
  (global-aggressive-indent-mode 1))

(use-package yafolding)
(use-package sgml-mode  :defer t)
(use-package f)
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

(use-package ibuffer-vc
  :disabled t
  :config
  (add-hook 'ibuffer-hook (lambda ()
			    (ibuffer-auto-mode 1)
			    (ibuffer-vc-set-filter-groups-by-vc-root)
			    (unless (eq ibuffer-sorting-mode 'alphabetic)
			      (ibuffer-do-sort-by-alphabetic))
			    )))

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
  :defer t
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

;;ivy
(use-package flx)
(use-package ivy
  :bind
  (("M-x" . counsel-M-x))
  :config
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-fuzzy)))
  )


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

(use-package shell-pop
  :defer t)

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
;;        org-completion-use-ido t
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
   '((shell . t)
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


(use-package dash  :defer t)
(use-package request :defer t)

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
  :ensure t
  :bind
  ("C-c p f" . projectile-find-file)
  ("C-c p p" . projectile-switch-project))

(use-package wolfram
  :defer t
  :config
  (setq wolfram-alpha-app-id "7L7LE4-HHWQGE9TG6"))

(use-package powerline
  :disabled t
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
(require 'mite-mode)
(use-package docker
  :config
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq explicit-shell-file-name "bash"))

(use-package docker-tramp)

;;;;; REPOSITORIES
;;(add-to-list 'load-path (concat user-emacs-directory "repos/" "a.el"))

;; ebook reader
(use-package nov)

;; from http://pragmaticemacs.com/category/dired/
(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))

;; checkout https://github.com/Kungsgeten/org-brain/blob/master/README.org

(use-package moody
  :config
  (setq moody-slant-function 'moody-slant-apple-rgb)
  (setq x-underline-at-descent-line t)
  (setq moody-mode-line-height 20)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))


(use-package minions)

(require 'server)
(add-hook 'after-init-hook (lambda ()
                             (unless (or (daemonp) (server-running-p))
                               (server-start)
                               (setq server-raise-frame t))))


(global-auto-revert-mode 1)
(add-hook 'dired-mode-hook 'auto-revert-mode)

(defun bjm/kill-this-buffer ()
  "Kill the current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

;; use same frame
(setq ns-pop-up-frames nil)

(add-to-list 'default-frame-alist
             '(ns-transparent-titlebar . t))

(add-to-list 'default-frame-alist
             '(ns-appearance . dark))

(global-set-key (kbd "C-x k") 'bjm/kill-this-buffer)

(setq gc-cons-threshold mc/gc-cons-threshold--orig)

;;; speedup next-line
(setq line-move-visual nil)

(mc-orga)

; (setq browse-url-browser-function 'eww-browse-url)
;; (set-frame-font "DejaVu Sans Mono-14" nil t)
;; (set-frame-font "Fantasque Sans Mono-16" nil t)
;; (set-frame-font "Source Code Pro-14" nil t)
;; (set-frame-font "Monaco-14" nil t)
;; (set-frame-font "Cousine-14" nil t)

;;maybe look at https://github.com/roman/golden-ratio.el

;;;todo
;; check out tabulated-list-mode

;;; init.el ends here
(put 'dired-find-alternate-file 'disabled nil)

