
;;highlight current line
(global-hl-line-mode t)

(setq inhibit-startup-message t)

(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;;no visible bell
(setq visible-bell nil)

(provide 'appearance)
