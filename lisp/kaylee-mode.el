(setq kaylee-font-lock-keywords
      (let (
            (keywords '("kaylee"))
            (types '(":asset" ":kayleehook" ":framework"))
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

(define-derived-mode kaylee-mode fundamental-mode
  "kaylee mode"
  ;; code for syntax highlighting
  (setq font-lock-defaults '((kaylee-font-lock-keywords))))




(defun kaylee-create-brew-tarball (folder-name version)
  (interactive "DSelect kaylee folder to tarball:
MSpecify kaylee version (i.e. 0.0.13):")
  
  (let* ((tarball-name (concat  "kaylee_" version ".tar.gz "))
	 (tarball-command (concat "tar " "czf " tarball-name " " folder-name)))
    (message "tarballing...")
;;    (message tarball-command)
    (message (concat "cd " (file-name-as-directory folder-name) ".. && " tarball-command))
    (message "done")))



(defun kaylee-update-brew-with-tarball (tarball-file formula-file)
  "write version, url and sha-256 in tarball from kaylee file"
  (interactive "fSelect tarball:
                fSelect formula:")
  (let* ((~sha-256 tarball-file)
	 (tarball-name (file-name-nondirectory tarball-file))
	 (version (replace-regexp-in-string  ".tar.gz" ""
					     (replace-regexp-in-string "kaylee_" "" tarball-name))))
    (message "here")
    (with-temp-buffer
      (insert (~kaylee-rb version sha))
      (write-file formula-file))))

(defun ~sha-256 (file)
  (unless (~kaylee-tarball? file)
    (error (concat  "file '" file "' is not a tarball")))
  (second (reverse (split-string (shell-command-to-string (concat "shasum -a 256 " file))))))



(defun ~kaylee-tarball? (file)
  (let* ((file-name (file-name-nondirectory file))
	 (components (split-string file-name "\\.")))
    (~last-n-eq-to-p components `("tar" "gz"))))

(defun ~last-n-eq-to-p (list-to-check should-be-equal-to)
  (equalp
   (-take-last (length should-be-equal-to)
	       list-to-check)
   should-be-equal-to))

;;(~sha-256 "~/dev/QM/frameworks/kaylee/www/public/releases/kaylee_0.0.13.tar.gz")


(defun ~kaylee-rb (version sha)
  "returns a brew formula with version and sha inserted"
  (concat  "class Kaylee < Formula
   desc \"\"
   homepage \"\"
   url \"http://kaylee.qmob.de:8080/releases/kaylee_" version ".tar.gz\"
   version \"" version  \""
   sha256 \"" sha "\"

   def install
       bin.install \"kaylee\"
       bin.install \"kaylee-bin\"
       bin.install \"kaylee-hooks\"

       frameworks.install \"CarthageKit.framework\"
   end
 end"))


(provide 'kaylee-mode)



