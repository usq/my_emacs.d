
(fset 'display-startup-echo-area-message #'ignore)
(fset 'yes-or-no-p #'y-or-n-p)

;;highlight current line
(global-hl-line-mode t)

(blink-cursor-mode -1)
(setq visible-bell nil)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)


(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))


(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.emacs.d/backups/saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control -1)       ; dont use versioned backups


(desktop-save-mode 1)

(provide 'appearance)


