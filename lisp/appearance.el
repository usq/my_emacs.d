
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



(provide 'appearance)
