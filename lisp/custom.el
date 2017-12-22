
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(compilation-message-face (quote default))
 '(custom-enabled-themes (quote (sanityinc-tomorrow-night)))
 '(custom-safe-themes
   (quote
    ("0c3b1358ea01895e56d1c0193f72559449462e5952bded28c81a8e09b53f103f" "69e7e7069edb56f9ed08c28ccf0db7af8f30134cab6415d5cf38ec5967348a3c" "732ccca2e9170bcfd4ee5070159923f0c811e52b019106b1fc5eaa043dff4030" "3e34e9bf818cf6301fcabae2005bba8e61b1caba97d95509c8da78cff5f2ec8e" "b67b2279fa90e4098aa126d8356931c7a76921001ddff0a8d4a0541080dee5f6" "8be07a2c1b3a7300860c7a65c0ad148be6d127671be04d3d2120f1ac541ac103" "60e09d2e58343186a59d9ed52a9b13d822a174b33f20bdc1d4abb86e6b17f45b" "aded4ec996e438a5e002439d58f09610b330bbc18f580c83ebaba026bbef6c82" "50b64810ed1c36dfb72d74a61ae08e5869edc554102f20e078b21f84209c08d1" "6145e62774a589c074a31a05dfa5efdf8789cf869104e905956f0cbd7eda9d0e" "78c1c89192e172436dbf892bd90562bc89e2cc3811b5f9506226e735a953a9c6" "5a7830712d709a4fc128a7998b7fa963f37e960fd2e8aa75c76f692b36e6cf3c" "527df6ab42b54d2e5f4eec8b091bd79b2fa9a1da38f5addd297d1c91aa19b616" "c968804189e0fc963c641f5c9ad64bca431d41af2fb7e1d01a2a6666376f819c" "d9dab332207600e49400d798ed05f38372ec32132b3f7d2ba697e59088021555" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" "a61109d38200252de49997a49d84045c726fa8d0f4dd637fce0b8affaa5c8620" "c614d2423075491e6b7f38a4b7ea1c68f31764b9b815e35c9741e9490119efc0" "34ed3e2fa4a1cb2ce7400c7f1a6c8f12931d8021435bad841fdc1192bd1cc7da" "146061a7ceea4ccc75d975a3bb41432382f656c50b9989c7dc1a7bb6952f6eb4" "0961d780bd14561c505986166d167606239af3e2c3117265c9377e9b8204bf96" "e1498b2416922aa561076edc5c9b0ad7b34d8ff849f335c13364c8f4276904f0" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "a800120841da457aa2f86b98fb9fd8df8ba682cebde033d7dbf8077c1b7d677a" default)))
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(git-commit-summary-max-length 90)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-symbol-idle-delay 0)
 '(highlight-tail-colors
   (quote
    (("#20240E" . 0)
     ("#679A01" . 20)
     ("#4BBEAE" . 30)
     ("#1DB4D0" . 50)
     ("#9A8F21" . 60)
     ("#A75B00" . 70)
     ("#F309DF" . 85)
     ("#20240E" . 100))))
 '(ido-use-faces nil)
 '(ispell-highlight-face (quote flyspell-incorrect))
 '(magit-diff-use-overlays nil)
 '(magit-log-arguments (quote ("--graph" "--color" "--decorate" "-n256")))
 '(org-agenda-files (quote ("~/Dropbox/org/qm.org")))
 '(org-babel-load-languages (quote ((sh . t) (emacs-lisp . t))))
 '(org-capture-templates
   (quote
    (("i" "file to inbox" entry
      (file+headline "~/Dropbox/org/file-this.org" "Inbox")
      ""))))
 '(org-default-notes-file "~/Dropbox/org/file-this.org")
 '(org-support-shift-select nil)
 '(package-selected-packages
   (quote
    (typescript-mode markdown-preview-mode tidy s slack json-reformat neotree ace-window logview org zen-mode rainbow-delimiters rainbow-delimiter base16-theme landmark emacs-home json-snatcher hilight-symbol highlight-symbol hilight-symbol-mode light-symbol light-symbol-mode hydra tea-time aggressive-indent agressive-indent agressive-indent-mode rotate emacs-rotate color-theme spacemacs-theme xquery-mode spotify-el spotify helm-spotify wolfram color-theme-sanityinc-tomorrow powerline company-jedi projectile google-this sgml cider flycheck Flycheck dirtree gitignore-mode scala-mode markdown-mode exec-path-from-shell cmake-mode sublimity-scroll sublimity slime multiple-cursors mc-mode multiple-cursor-mode swift-mode yasnippet company-sourcekit company browse-kill-ring helm js2-mode undo-tree tex auctex-latexmk auctex djinni-mode reveal-in-osx-finder direx dired-x use-package simple-httpd restclient paradox beacon smartparens monokai-theme smex paredit magit ido-vertical-mode ido-ubiquitous ido-at-point flx-ido ace-jump-mode)))
 '(pcomplete-ignore-case t)
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(powerline-default-separator (quote arrow-fade))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(weechat-color-list
   (unspecified "#272822" "#20240E" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(font-lock-comment-face ((t (:inherit nil :foreground "#b0b0b0" :slant italic))))
 '(highlight-symbol-face ((t (:inherit highlight :background "gray33"))) t)
 '(mode-line ((t (:foreground "#000000" :background "#dddddd" :box nil))))
 '(mode-line-buffer-id ((t (:foreground "#000000" :bold t))))
 '(mode-line-buffer-id-inactive ((t (:inherit mode-line-buffer-id))))
 '(mode-line-inactive ((t (:foreground "#000000" :background "#bbbbbb" :box nil))))
 '(org-hide ((t (:inherit default :background "#263238" :foreground "#263238"))))
 '(powerline-active1 ((t (:background "Black" :foreground "White"))))
 '(powerline-active2 ((t (:background "#34352E" :foreground "white"))))
 '(show-paren-match ((t (:background "turquoise" :foreground "gray10"))))
 '(which-func ((t (:foreground "#77aaff"))) t))
