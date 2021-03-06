
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#839496"])
 '(auto-revert-verbose nil)
 '(company-backends
   (quote
    (company-bbdb company-nxml company-css company-eclim company-semantic company-clang company-xcode company-cmake company-capf company-files
		  (company-dabbrev-code company-gtags company-etags company-keywords)
		  company-oddmuse company-dabbrev company-elisp)))
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#657b83")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "fe666e5ac37c2dfcf80074e88b9252c71a22b6f5d2f566df9a7aa4f9bea55ef8" "6d589ac0e52375d311afaa745205abb6ccb3b21f6ba037104d71111e7e76a3fc" "6b2636879127bf6124ce541b1b2824800afc49c6ccd65439d6eb987dbf200c36" "9fcac3986e3550baac55dc6175195a4c7537e8aa082043dcbe3f93f548a3a1e0" "242527ce24b140d304381952aa7a081179a9848d734446d913ca8ef0af3cef21" "44247f2a14c661d96d2bff302f1dbf37ebe7616935e4682102b68c0b6cc80095" "408e753da5ce585ad73a0388b50749ef4dcf2b047583fb1378516576e40fa71b" "0c3b1358ea01895e56d1c0193f72559449462e5952bded28c81a8e09b53f103f" "69e7e7069edb56f9ed08c28ccf0db7af8f30134cab6415d5cf38ec5967348a3c" "732ccca2e9170bcfd4ee5070159923f0c811e52b019106b1fc5eaa043dff4030" "3e34e9bf818cf6301fcabae2005bba8e61b1caba97d95509c8da78cff5f2ec8e" "b67b2279fa90e4098aa126d8356931c7a76921001ddff0a8d4a0541080dee5f6" "8be07a2c1b3a7300860c7a65c0ad148be6d127671be04d3d2120f1ac541ac103" "60e09d2e58343186a59d9ed52a9b13d822a174b33f20bdc1d4abb86e6b17f45b" "aded4ec996e438a5e002439d58f09610b330bbc18f580c83ebaba026bbef6c82" "50b64810ed1c36dfb72d74a61ae08e5869edc554102f20e078b21f84209c08d1" "6145e62774a589c074a31a05dfa5efdf8789cf869104e905956f0cbd7eda9d0e" "78c1c89192e172436dbf892bd90562bc89e2cc3811b5f9506226e735a953a9c6" "5a7830712d709a4fc128a7998b7fa963f37e960fd2e8aa75c76f692b36e6cf3c" "527df6ab42b54d2e5f4eec8b091bd79b2fa9a1da38f5addd297d1c91aa19b616" "c968804189e0fc963c641f5c9ad64bca431d41af2fb7e1d01a2a6666376f819c" "d9dab332207600e49400d798ed05f38372ec32132b3f7d2ba697e59088021555" "2a998a3b66a0a6068bcb8b53cd3b519d230dd1527b07232e54c8b9d84061d48d" "a61109d38200252de49997a49d84045c726fa8d0f4dd637fce0b8affaa5c8620" "c614d2423075491e6b7f38a4b7ea1c68f31764b9b815e35c9741e9490119efc0" "34ed3e2fa4a1cb2ce7400c7f1a6c8f12931d8021435bad841fdc1192bd1cc7da" "146061a7ceea4ccc75d975a3bb41432382f656c50b9989c7dc1a7bb6952f6eb4" "0961d780bd14561c505986166d167606239af3e2c3117265c9377e9b8204bf96" "e1498b2416922aa561076edc5c9b0ad7b34d8ff849f335c13364c8f4276904f0" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "a800120841da457aa2f86b98fb9fd8df8ba682cebde033d7dbf8077c1b7d677a" default)))
 '(dired-use-ls-dired nil)
 '(ediff-window-setup-function (quote ediff-setup-windows-plain))
 '(elfeed-feeds
   (quote
    ("emacshorrors.com/feed.atom" "cachestocaches.com/feed" "pragmaticemacs.com/feed")))
 '(exec-path-from-shell-arguments (quote ("-l")))
 '(fci-rule-color "#eee8d5")
 '(git-commit-summary-max-length 90)
 '(highlight-changes-colors (quote ("#FD5FF0" "#AE81FF")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#fdf6e3" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#586e75")
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
 '(hl-bg-colors
   (quote
    ("#DEB542" "#F2804F" "#FF6E64" "#F771AC" "#9EA0E5" "#69B7F0" "#69CABF" "#B4C342")))
 '(hl-fg-colors
   (quote
    ("#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3" "#fdf6e3")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(ido-use-faces nil)
 '(ispell-highlight-face (quote flyspell-incorrect))
 '(jdee-db-active-breakpoint-face-colors (cons "#1B2229" "#51afef"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#1B2229" "#98be65"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#1B2229" "#3f444a"))
 '(magit-diff-use-overlays nil)
 '(magit-log-arguments (quote ("--graph" "--color" "--decorate" "-n256")))
 '(mc/always-run-for-all t)
 '(minions-mode nil)
 '(minions-whitelist
   (quote
    ((abbrev-mode)
     (auto-fill-mode)
     (auto-revert-mode)
     (auto-revert-tail-mode)
     (flyspell-mode)
     (font-lock-mode)
     (glasses-mode)
     (hide-ifdef-mode)
     (highlight-changes-mode)
     (outline-minor-mode)
     (overwrite-mode)
     (ruler-mode)
     (projectile-mode))))
 '(moody-mode-line-height 23)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(org-support-shift-select nil)
 '(package-selected-packages
   (quote
    (web-mode eyedropper solarized-theme counsel-tramp ycmd-eldoc company-ycmd ycmd hydra magit nov shrink-path evil-anzu eldoc-eval doom-themes ag irony counsel counsel-mode auto-package-update try company-restclient org-bullets rustic flycheck-rust cargo smex eziam-theme elfeed lua lua-mode yafolding f ido-completing-read+ cider minions moody shell-pop dired-subtree dired-plus ibuffer-vc ibuffer-projectile dired+ snazzy-theme asoc fireplace irony-server docker panda-theme groovy-mode kotlin-imenu kotlin-mode flycheck-kotlin dimmer angular-mode typescript-mode markdown-preview-mode tidy s slack json-reformat ace-window logview org zen-mode rainbow-delimiters rainbow-delimiter base16-theme landmark emacs-home json-snatcher hilight-symbol highlight-symbol hilight-symbol-mode light-symbol light-symbol-mode tea-time aggressive-indent agressive-indent agressive-indent-mode rotate emacs-rotate color-theme spacemacs-theme xquery-mode spotify-el spotify helm-spotify powerline company-jedi google-this sgml flycheck Flycheck dirtree gitignore-mode exec-path-from-shell cmake-mode sublimity-scroll sublimity slime multiple-cursors mc-mode multiple-cursor-mode yasnippet company-sourcekit company browse-kill-ring js2-mode undo-tree tex auctex-latexmk auctex djinni-mode reveal-in-osx-finder direx dired-x use-package simple-httpd restclient paradox beacon smartparens monokai-theme paredit ido-vertical-mode ido-at-point flx-ido ace-jump-mode)))
 '(pcomplete-ignore-case t)
 '(pos-tip-background-color "#A6E22E")
 '(pos-tip-foreground-color "#272822")
 '(powerline-default-separator (quote arrow-fade))
 '(projectile-completion-system (quote ivy))
 '(projectile-indexing-method (quote hybrid))
 '(request-log-level (quote debug))
 '(request-message-level (quote debug))
 '(safe-local-variable-values
   (quote
    ((eval unless
	   (featurep
	    (quote swiftpm-project-settings))
	   (message "loading 'swiftpm-project-settings")
	   (add-to-list
	    (quote load-path)
	    (concat
	     (let
		 ((dlff
		   (dir-locals-find-file default-directory)))
	       (if
		   (listp dlff)
		   (car dlff)
		 (file-name-directory dlff)))
	     "Utilities/Emacs")
	    :append)
	   (require
	    (quote swiftpm-project-settings))))))
 '(scroll-bar-mode nil)
 '(shell-pop-shell-type (quote ("shell" "*shell*" (lambda nil (eshell)))))
 '(shell-pop-universal-key "C-t")
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#eee8d5" 0.2))
 '(term-default-bg-color "#fdf6e3")
 '(term-default-fg-color "#657b83")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#c9485ddd1797")
     (60 . "#bf7e73b30bcb")
     (80 . "#b58900")
     (100 . "#a5a58ee30000")
     (120 . "#9d9d91910000")
     (140 . "#9595943e0000")
     (160 . "#8d8d96eb0000")
     (180 . "#859900")
     (200 . "#67119c4632dd")
     (220 . "#57d79d9d4c4c")
     (240 . "#489d9ef365ba")
     (260 . "#3963a04a7f29")
     (280 . "#2aa198")
     (300 . "#288e98cbafe2")
     (320 . "#27c19460bb87")
     (340 . "#26f38ff5c72c")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (unspecified "#272822" "#20240E" "#F70057" "#F92672" "#86C30D" "#A6E22E" "#BEB244" "#E6DB74" "#40CAE4" "#66D9EF" "#FB35EA" "#FD5FF0" "#74DBCD" "#A1EFE4" "#F8F8F2" "#F8F8F0"))
 '(xterm-color-names
   ["#eee8d5" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#073642"])
 '(xterm-color-names-bright
   ["#fdf6e3" "#cb4b16" "#93a1a1" "#839496" "#657b83" "#6c71c4" "#586e75" "#002b36"]))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 130 :width normal :foundry "nil" :family "Fira Mono"))))
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(cider-fringe-good-face ((t (:background "green4" :foreground "light green"))))
 '(company-scrollbar-fg ((t (:background "gray55"))))
 '(font-lock-comment-face ((t (:inherit nil :foreground "#b0b0b0" :slant italic))))
 '(header-line ((t (:inherit mode-line-inactive :background "gray27" :foreground "#8abeb7"))))
 '(highlight-symbol-face ((t (:inherit highlight :background "gray33"))) t)
 '(mode-line ((t (:foreground "#a5a5a9" :box nil :weight normal))))
 '(org-hide ((t (:inherit default :background "#263238" :foreground "#263238"))))
 '(powerline-active1 ((t (:background "Black" :foreground "White"))) t)
 '(powerline-active2 ((t (:background "#34352E" :foreground "white"))) t)
 '(show-paren-match ((t (:background "turquoise" :foreground "gray10"))))
 '(which-func ((t (:foreground "#77aaff")))))
