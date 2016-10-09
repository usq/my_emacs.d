
;;see http://www.gnu.org/software/emacs/manual/html_node/elisp/Faces-for-Font-Lock.html
(setq djinni-font-lock-keywords
      (let (
            (keywords '("interface" "static" ":"))
            (types '("bool" "string" "+o" "+j" "+c" "+o+j" "+j+o"))
            )

        (let (
              (keywords-regexp  (regexp-opt keywords  'words))
              (type-regexp      "\\<bool\\>\\|\\<string\\>\\|\\<generated_[a-zA-Z_]*\\>\\|+o\\|+j\\|+c")
              (event-regexp    "[a-zA-Z_]+:")
              (comments-regexp "#.*")
              )

          `(
            (,type-regexp . font-lock-type-face)
            (,event-regexp . font-lock-function-name-face)
            (,comments-regexp . font-lock-comment-face)
            (,keywords-regexp . font-lock-keyword-face)

            ))))



(define-derived-mode djinni-mode fundamental-mode
  "djinni mode"
  ;; code for syntax highlighting
  (setq font-lock-defaults '((djinni-font-lock-keywords))))

(defun join-string-list (l sep)
  (mapconcat 'identity l sep))

(defun insert-after (lst index newelt)
  (push newelt (cdr (nthcdr index lst)))
  lst)

(defun djinni-enum ()
  (interactive)
  (insert "generated_enum_name = enum\n{\n\toption1;\n}"))

(defun djinni-transform-methods (rstart rend)
  (interactive "r")
  (let* ((buffer (buffer-substring rstart rend))
         (cleanup (replace-regexp-in-string "\\( = 0;\\)\\|virtual |\\(^\\s-*$\\)\n" "" buffer))
         (alllines (split-string cleanup "\n"))
         (implementation-lines nil)
         (class "--Class::"))

    ;;get classname
    (save-excursion
      (goto-char 0)
      (search-forward-regexp "class [a-zA-Z]* {")
      (let* ((p1 (line-beginning-position))
             (p2 (line-end-position))
             (line (buffer-substring-no-properties p1 p2))
             (name (replace-regexp-in-string "Generated" "" (second (split-string line)))))
        (setf class (concat name "::"))))

    (goto-char rend)

    (loop for l in alllines do
          (when (not (string-match-p "^[ ]*$" l))
            ;;build cpp
            (let ((line (append (rest (split-string l)) (list "\n{\n\n}\n"))))
              (setf (nth 1 line) (concat class (nth 1 line)))
              (setf implementation-lines (append implementation-lines
                                                 (list (join-string-list  line " ")))))
            ;;build h
            (let* ((tokens (rest (split-string l)))
                   (ret-to-back (append (rest tokens) (list (first tokens))))
                   (appended (reverse (append (reverse ret-to-back) '("auto"))))
                   (strlist (insert-after
                             appended
                             (- (length appended) 2)
                             "->"))
                   (final (append strlist '("override;"))))
              (newline)
              (insert (join-string-list final " ")))))

    ;;insert cpp
    (newline 3)
    (insert (join-string-list implementation-lines "\n"))
    ))

(provide 'djinni-mode)
