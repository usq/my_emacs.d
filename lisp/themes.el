;;; package --- Summary
;;; Commentary:
;;; Code:

(use-package color-theme)

(use-package snazzy-theme
  :disabled t
  :ensure t
  :config
  (load-theme 'snazzy t))

(use-package doom-themes
  :config
  (load-theme 'doom-one)
  ;(load-theme 'doom-nord)
  ;(load-theme 'doom-nord-light)
  )

(use-package panda-theme
  :disabled t
  :ensure t
  :config
  (load-theme 'panda t))

;;(set-frame-font "Hack 12" nil t)
;(set-frame-font "Source Code Pro 13" nil t)

;;; https://belak.github.io/base16-emacs/
(use-package base16-theme
  :disabled t
  :ensure t
  :config
  (load-theme 'base16-materia t))

(use-package spacemacs-theme
  :disabled t
  :defer t
  :init
  (load-theme 'spacemacs-dark t))



(defun light-theme ()
  (interactive)
;  (load-theme 'spacemacs-light t)
  (load-theme 'base16-atelier-lakeside-light t))

(defun light-theme2 ()
  (interactive)
  (load-theme 'base16-summerfruit-light t))

(defun light-theme3 ()
  (interactive)
  (load-theme 'base16-atelier-cave-light t))

(defun dark-theme ()
  (interactive)
  ;; (load-theme 'spacemacs-dark t)
  (load-theme 'base16-materia t))

(defun dark-theme2 ()
  (interactive)
  (load-theme 'base16-monokai t))

(defun dark-theme3 ()
  (interactive)
  (load-theme 'base16-nord t))

(defun dark-theme4 ()
  (interactive)
  (load-theme 'base16-onedark t))

(defun dark-theme5 ()
  (interactive)
  (load-theme 'base16-oceanicnext t))


(provide 'themes)
