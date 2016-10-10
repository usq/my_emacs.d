(setq punic-font-lock-keywords
      (let (
            (keywords '("punic"))
            (types '(":asset" ":punichook" ":framework"))
            )

        (let (
              (keywords-regexp  (regexp-opt keywords 'words))
              (type-regexp      "src:")
              (event-regexp    "(?:)[a-zA-Z0-9_-]+")
              (comments-regexp "#.*\\|//.*")
              )
          `(
            (,type-regexp . font-lock-type-face)
            (,event-regexp . font-lock-function-name-face)
            (,comments-regexp . font-lock-comment-face)
            (,keywords-regexp . font-lock-keyword-face)

            ))))

(define-derived-mode punic-mode fundamental-mode
  "punic mode"
  ;; code for syntax highlighting
  (setq font-lock-defaults '((punic-font-lock-keywords))))


(defun punic-create-brew-tarball (folder-name version)
  (interactive "DSelect punic folder to tarball:
MSpecify punic version (i.e. 0.0.13):")
  
  (let* ((tarball-name (concat  "punic_" version ".tar.gz "))
	 (tarball-command (concat "tar " "czf " tarball-name " " folder-name)))
    (message "tarballing...")
    (shell-command tarball-command)
    (message "done")))

(defun punic-update-brew-with-tarball (tarball-file formula-file)
  (interactive "fSelect tarball:
fSelect formula:")
  (let* ((sha-256 (shell-command-to-string (concat "shasum -a 256 " tarball-file)))
	 (sha (second (reverse (split-string sha-256))))
	 (tarball-name (car (last (split-string tarball-file "/"))))
	 (version (replace-regexp-in-string  ".tar.gz" ""
					     (replace-regexp-in-string "punic_" "" tarball-name))))    	 (with-temp-buffer
	   (insert (punic-rb version sha))
	   (write-file formula-file))))

(defun punic-rb (version sha)
  "returns a brew formula with version and sha inserted"
  (concat  "class Punic < Formula
   desc \"\"
   homepage \"\"
   url \"http://punic.qmob.de:8080/releases/punic_" version ".tar.gz\"
   version " version  "
   sha256 \"" sha "\"

   def install
       bin.install \"punic\"
       bin.install \"punic-bin\"
       bin.install \"punic-hooks\"

       frameworks.install \"CarthageKit.framework\"
   end
 end"))


(provide 'punic-mode)



