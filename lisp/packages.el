(setq package-enable-at-startup nil)
(setq package-archives
      ;; Package archives, the usual suspects
      '(("GNU ELPA"     . "http://elpa.gnu.org/packages/")
        ("MELPA-Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/")
	("MELPA-MILK"   . "https://melpa.milkbox.net/packages/"))
      ;; Prefer MELPA Stable over GNU over MELPA.  IOW prefer MELPA's stable
      ;; packages over everything and only fall back to GNU or MELPA if
      ;; necessary.
      package-archive-priorities
      '(("MELPA Stable" . 10)
        ("GNU ELPA"     . 5)
        ("MELPA"        . 2)
        ("MELPA-MILK"   . 1))
      )

(package-initialize)

(unless (file-exists-p "~/.emacs.d/elpa/archives/melpa")
  (package-refresh-contents))


(provide 'packages)



