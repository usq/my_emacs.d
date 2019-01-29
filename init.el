;;; package --- Summary
;;; Commentary:
;;; Code:

;; https://www.reddit.com/r/emacs/comments/3kqt6e/2_easy_little_known_steps_to_speed_up_emacs_start/
(defvar mc/gc-cons-threshold--orig gc-cons-threshold)

(setq gc-cons-threshold (* 100 1024 1024)) ;100 MB before garbage collection
(setq message-log-max 10000)

(require 'package)
(setq package-enable-at-startup nil)
(setq use-package-always-ensure t)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(setq auto-window-vscroll nil)



(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(org-babel-load-file (expand-file-name "~/.emacs.d/orginit.org"))







;;;; look at https://www.suenkler.info/notes/emacs-config/

;;;; follow-mode!!!!!!!!!!!!!!!!!

;;look at workgroups
;;https://github.com/pashinin/workgroups2






;;;;; REPOSITORIES
;;(add-to-list 'load-path (concat user-emacs-directory "repos/" "a.el"))


;; from http://pragmaticemacs.com/category/dired/
(use-package dired-subtree
  :config
  (bind-keys :map dired-mode-map
             ("i" . dired-subtree-insert)
             (";" . dired-subtree-remove)))



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

;; disable fucking changelog-mode (this fucks up our changelogs)
(rassq-delete-all 'change-log-mode auto-mode-alist)



(mc-orga)
;;(mc-cpp)

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

