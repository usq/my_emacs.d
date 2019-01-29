(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

(fset 'display-startup-echo-area-message #'ignore)
	(fset 'yes-or-no-p #'y-or-n-p)

    ;;    this KILLS performance in large files
    ;;    (global-hl-line-mode t)


;;restore layout after ediff
    (winner-mode) 
    (add-hook 'ediff-after-quit-hook-internal 'winner-undo)


	(blink-cursor-mode -1)
	(setq visible-bell nil)

	(setq inhibit-startup-screen t)
	(setq inhibit-startup-message t)
	(setq ring-bell-function 'ignore)

	(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
	(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

	(setq ns-pop-up-frames nil)

(setq show-paren-delay 0.125)
(show-paren-mode 1)

(setq custom-file (expand-file-name "custom.el" (concat user-emacs-directory "lisp/")))
(load custom-file)

(delete-selection-mode 1)

(setq
 backup-by-copying t      ; don't clobber symlinks
 backup-directory-alist
 '(("." . "~/.emacs.d/backups/saves"))    ; don't litter my fs tree
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control -1)       ; dont use versioned backups

(use-package magit
  :bind
  ("C-x m" . magit-status)
  :config

  ;; Subtler highlight
  (set-face-background 'diff-file-header "#121212")
  (set-face-foreground 'diff-context "#666666")
  (set-face-foreground 'diff-added "#00cc33")
  (set-face-foreground 'diff-removed "#ff0000")

  (set-default 'magit-stage-all-confirm nil)
  (set-default 'magit-unstage-all-confirm nil)

  (eval-after-load 'ediff
    '(progn
       (set-face-foreground 'ediff-odd-diff-B "#ffffff")
       (set-face-background 'ediff-odd-diff-B "#292521")
       (set-face-foreground 'ediff-even-diff-B "#ffffff")
       (set-face-background 'ediff-even-diff-B "#292527")

       (set-face-foreground 'ediff-odd-diff-A "#ffffff")
       (set-face-background 'ediff-odd-diff-A "#292521")
       (set-face-foreground 'ediff-even-diff-A "#ffffff")
       (set-face-background 'ediff-even-diff-A "#292527")))

  ;; todo:
  ;; diff-added-face      diff-changed-face
  ;; diff-context-face    diff-file-header-face
  ;; diff-function-face   diff-header-face
  ;; diff-hunk-header-face        diff-index-face
  ;; diff-indicator-added-face    diff-indicator-changed-face
  ;; diff-indicator-removed-face  diff-nonexistent-face
  ;; diff-removed-face


  ;; Load git configurations
  ;; For instance, to run magit-svn-mode in a project, do:
  ;;
  ;;     git config --add magit.extension svn
  ;;
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)

  (defun magit-save-and-exit-commit-mode ()
    (interactive)
    (save-buffer)
    (server-edit)
    (delete-window))

  (defun magit-exit-commit-mode ()
    (interactive)
    (kill-buffer)
    (delete-window))

  (eval-after-load "git-commit-mode"
    '(define-key git-commit-mode-map (kbd "C-c C-k") 'magit-exit-commit-mode))

  ;; C-c C-a to amend without any prompt

  (defun magit-just-amend ()
    (interactive)
    (save-window-excursion
      (magit-with-refresh
       (shell-command "git --no-pager commit --amend --reuse-message=HEAD"))))

  (eval-after-load "magit"
    '(define-key magit-status-mode-map (kbd "C-c C-a") 'magit-just-amend))

  ;; C-x C-k to kill file on line

  (defun magit-kill-file-on-line ()
    "Show file on current magit line and prompt for deletion."
    (interactive)
    (magit-visit-item)
    (delete-current-buffer-file)
    (magit-refresh))

  (define-key magit-status-mode-map (kbd "C-x C-k") 'magit-kill-file-on-line)

  ;; full screen magit-status

  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun magit-quit-session ()
    "Restores the previous window configuration and kills the magit buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))

  (define-key magit-status-mode-map (kbd "q") 'magit-quit-session)

  ;; full screen vc-annotate
  (defun vc-annotate-quit ()
    "Restores the previous window configuration and kills the vc-annotate buffer"
    (interactive)
    (kill-buffer)
    (jump-to-register :vc-annotate-fullscreen))

  (eval-after-load "vc-annotate"
    '(progn
       (defadvice vc-annotate (around fullscreen activate)
	 (window-configuration-to-register :vc-annotate-fullscreen)
	 ad-do-it
	 (delete-other-windows))

       (define-key vc-annotate-mode-map (kbd "q") 'vc-annotate-quit)))

  ;; ignore whitespace

  (defun magit-toggle-whitespace ()
    (interactive)
    (if (member "-w" magit-diff-options)
	(magit-dont-ignore-whitespace)
      (magit-ignore-whitespace)))

  (defun magit-ignore-whitespace ()
    (interactive)
    (add-to-list 'magit-diff-options "-w")
    (magit-refresh))

  (defun magit-dont-ignore-whitespace ()
    (interactive)
    (setq magit-diff-options (remove "-w" magit-diff-options))
    (magit-refresh))

  (define-key magit-status-mode-map (kbd "W") 'magit-toggle-whitespace)

  ;; Show blame for current line

  ;;(require-package 'git-messenger)
  ;;(global-set-key (kbd "C-x v p") #'git-messenger:popup-message)

  ;; Don't bother me with flyspell keybindings

  ;;(eval-after-load "flyspell"
  ;;  '(define-key flyspell-mode-map (kbd "C-.") nil))
  )

(use-package auctex-latexmk :defer t)

(use-package company-jedi
  :defer t
  :config
  (add-to-list 'company-backends 'company-jedi))

(use-package groovy-mode :defer t)

(use-package js2-mode
  :bind
  (("C-c [tab]" . json-format)))

(use-package typescript-mode :defer t)
(use-package angular-mode :defer t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package cider
  :ensure t
  :config
  (add-hook 'cider-repl-mode-hook #'eldoc-mode)
  (setq cider-repl-use-pretty-printing t))

(use-package flycheck-kotlin)
(use-package kotlin-mode)

(use-package ycmd
  :ensure t
  :config
  (set-variable 'ycmd-server-command '("python" "/Users/michaelconrads/dev/lab/ycmd/ycmd"))

  (add-hook 'c++-mode-hook 'ycmd-mode)

  )

(require 'ycmd)
(require 'ycmd-eldoc)
(add-hook 'ycmd-mode-hook 'ycmd-eldoc-setup)
(set-variable 'ycmd-extra-conf-whitelist '("~/.ycm_extra_conf.py"))
(set-variable 'ycmd-global-config "~/.ycm_extra_conf.py")
(setq request-message-level -1  url-show-status nil)

(use-package company-ycmd
  :ensure t
  :init (company-ycmd-setup)
  :config (add-to-list 'company-backends 'company-ycmd))



(use-package irony
  :ensure t
  :disabled t
  :hook 
					;	(c-mode . irony-mode)
					;	(c++-mode . irony-mode)

					;      :init
					;      (set-variable ' ymcd-server-command )

  )

(use-package company-irony
  :ensure t
  :disabled t
  :config
  (add-to-list 'company-backends 'company-irony))

(use-package cargo)
     (use-package flycheck-rust)
;;     (use-package rustic :ensure t)

(use-package avy
  :bind
  (("M-s" . avy-goto-char-2)
   ("C-c j" . avy-goto-char-2)))

(use-package flx)
(use-package ivy
  :ensure t
  :config
  (progn
    (ivy-mode 1)
    (setq ivy-use-virtual-buffers t)
    (setq enable-recursive-minibuffers t)
    (setq ivy-initial-inputs-alist nil)
    (minibuffer-depth-indicate-mode 1)
    (setq ivy-re-builders-alist
	  '((t . ivy--regex-fuzzy))))
  :bind
  (("C-s" . swiper) ;; disable fuzzy once with M-r
   ("C-c C-r" . ivy-resume)))

(use-package counsel
  :ensure t
  :bind
  (("M-x" . counsel-M-x)))

(use-package counsel-tramp
  :config
  (setq tramp-default-method "ssh")
  )


(use-package smex
  :ensure t) ;;for ivy command sorting

(use-package smartparens)
	(use-package company
	  :bind
	  ("C-," . company-complete-common)
	  :config
	  (add-hook 'after-init-hook 'global-company-mode))


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

	(use-package swift-mode :defer t)

	(use-package yasnippet :defer t
	  :config
	  (setq yas-snippet-dirs
		'("~/.emacs.d/snippets")))

	(use-package restclient)
	(use-package company-restclient)
	(use-package json-snatcher :defer t)

	(use-package cmake-mode)
(use-package ag)

(use-package direx)
	  (use-package dirtree :defer t)

	  (use-package flycheck
	    :ensure t
	    :init (global-flycheck-mode)
	    :config
	    (unbind-key "C-c +" flycheck-mode-map))



	  (use-package exec-path-from-shell
	    :config
	    (message "Calling exec-path-from-shell-initialize")
	    (exec-path-from-shell-initialize)
	    (message "PATH is now: %s" (getenv "PATH"))
  )


	  (use-package rotate :defer t)


	  (use-package try)
	  (use-package yafolding)
	  (use-package sgml-mode  :defer t)
      ;;for neo tree
      (use-package all-the-icons)
	  (use-package neotree
	    :config (setq neo-window-width 40 
			  neo-smart-open t 
			  neo-theme 'icons)
	    :bind ("C-c t" . neotree))
	  (use-package which-key
	    :config
	    (which-key-mode))
(use-package ace-jump-mode)

	  (use-package ace-window
	    :init
	     (progn
	      (global-set-key [remap other-window] 'ace-window)
	      (custom-set-faces
	       '(aw-leading-char-face
		 ((t (:inherit ace-jump-face-foreground :height 3.0)))))))

	  (use-package elfeed :defer t)
	  (use-package simple-httpd)
	  (use-package reveal-in-osx-finder :defer t)
	  (use-package shell-pop :defer t)

(setq load-prefer-newer t)
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

(use-package f) ;; why do I neet this?
(use-package deferred)
(use-package request)

(use-package hideshow ;; why do I need this if I have yafolding?
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

(use-package org
	    :ensure t
	    :bind
	    (("C-c l" . org-store-link)
	     ("C-c c" . org-capture))

	    :config
(message "loading config org")
	    (setq org-use-speed-commands t
		  org-return-follows-link t
		  org-hide-emphasis-markers t
		  org-outline-path-complete-in-steps nil
		  org-src-fontify-natively t   ;; Pretty code blocks
		  org-src-tab-acts-natively t
		  org-confirm-babel-evaluate nil
		  org-agenda-ndays 7
		  org-clock-in-resume t
		  org-clock-report-include-clocking-task t
		  org-agenda-window-setup 'current-window
		  org-agenda-files (append (file-expand-wildcards "~/dev/org/*.org") '("~/dev/QM/qm.org" "~/dev/QM/orga/projects.org"))
		  org-agenda-span 1 ;;start agenda in day instead week
		  org-todo-keywords '((sequence "TODO(t)" "|" "DOING(g)" "WAITING(w)" "|" "DONE(d)")
				      (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))

		  org-todo-keyword-faces '(("TODO" :foreground "red" :weight bold)
					   ("NEXT" :foreground "blue" :weight bold)
					   ("DONE" :foreground "forest green" :weight bold)
					   ("WAITING" :foreground "orange" :weight bold)
					   ("HOLD" :foreground "magenta" :weight bold)
					   ("CANCELLED" :foreground "forest green" :weight bold)
					   ("MEETING" :foreground "forest green" :weight bold)
					   ("PHONE" :foreground "forest green" :weight bold))

		  org-default-notes-file  "~/dev/org/refile.org"
		  org-capture-templates '(("t" "todo" entry (file "~/dev/org/refile.org")          "* TODO hello %?\n%U\n%a\n" :clock-in t :clock-resume t)
					  ("n" "note" entry (file "~/dev/org/refile.org")          "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
					  ("w" "org-protocol" entry (file "~/dev/org/refile.org")  "* TODO Review %c\n%U\n" :immediate-finish t)
					  ("m" "Meeting" entry (file "~/dev/org/refile.org")	   "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
					  )

		  )
	    (add-to-list 'auto-mode-alist '("\\.txt\\'" . org-mode))

	    ;; we use C-c + for org-mode-map
	    (unbind-key "C-c +" org-mode-map)
	    (unbind-key "C-c -" org-mode-map)
	    (unbind-key "<S-left>" org-mode-map)
	    (unbind-key "<S-right>" org-mode-map)
	    (unbind-key "<S-up>" org-mode-map)
	    (unbind-key "<S-down>" org-mode-map)
	    (unbind-key "C-," org-mode-map) ;; I use this for company
	    (define-key org-mode-map [remap org-return] (lambda () (interactive)
							  (if (org-in-src-block-p)
							      (org-return)
							    (org-return-indent))))




	    (org-babel-do-load-languages
	     'org-babel-load-languages
	     '((python . t)
	       (dot . t)
	       (latex . t)
	       ))

	    (add-hook 'org-mode-hook 'jira-link-mode)

	    ;; Make windmove work in org-mode:
	    (add-hook 'org-shiftup-final-hook 'windmove-up)
	    (add-hook 'org-shiftleft-final-hook 'windmove-left)
	    (add-hook 'org-shiftdown-final-hook 'windmove-down)
	    (add-hook 'org-shiftright-final-hook 'windmove-right)

	    (add-to-list 'org-structure-template-alist '("el" "#+BEGIN_SRC emacs-lisp\n\n#+END_SRC"))

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


	    ;; Remove empty LOGBOOK drawers on clock out
	    (defun bh/remove-empty-drawer-on-clock-out ()
	      (interactive)
	      (save-excursion
		(beginning-of-line 0)
		(org-remove-empty-drawer-at "LOGBOOK" (point))))

	    (add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append))

(use-package org-bullets
      :ensure t
      :config
      (add-hook 'org-mode-hook 'org-bullets-mode))

(use-package projectile
  :ensure t
  :bind
  (
   ("C-c p f" . projectile-find-file)
   ("C-c p p" . projectile-switch-project)))

(use-package powerline
  :disabled t
  :config
  (powerline-default-theme))

(use-package rainbow-delimiters)
(use-package dimmer
  :init
  (setq dimmer-percent 0.3)
  :config
  (dimmer-mode))

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

;; always indent everything
(use-package aggressive-indent
  :defer t
  :config
  (global-aggressive-indent-mode 1))


(use-package browse-kill-ring
  :defer t
  :bind
  ("C-c y" . browse-kill-ring))

(use-package ibuffer
  :bind
  ("C-x C-b" . ibuffer))


(use-package multiple-cursors
  :defer t
  :bind
  ("H-SPC" . set-rectangular-region-anchor))


(use-package undo-tree
  :bind
  ("C-x u" . undo-tree-visualize)
  ("C-?" . undo-tree-redo))

;;(require 'doom-modeline)
;;(+doom-modeline|init)

(use-package moody
  ;:disabled t
  :config
  (setq moody-slant-function 'moody-slant-apple-rgb)
  (setq x-underline-at-descent-line t)
  (setq moody-mode-line-height 20)
  (moody-replace-mode-line-buffer-identification)
  (moody-replace-vc-mode))

(use-package minions)

(require 'eyedropper)
(require 'themes)
(require 'mac)
(require 'tex)

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
(require 'qmlog)
(require 'mite-mode)

(use-package hydra
:bind
(
 ("C-c m" . mc/global-hydra-menu/body)

)
)

(defhydra mc/global-hydra-menu (:color pink
				       :hint nil)
  "
    ^foo^            ^second row^
    ^^^^^-----------
    _m_: message     _u_: foo

    "
  ("m" (message "hello"))
  ("q" quit-window "quit" :color blue)
  ("u" nil)
  )

(use-package docker
  :config
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/bin")))
  (setq explicit-shell-file-name "bash"))

(use-package docker-tramp)

(define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-defun)

(global-set-key (kbd "C-h C-f") 'find-function)

;; ebook reader
(use-package nov)
