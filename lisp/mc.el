
;;;  Code:
(require 'cl)
(cl-defun mc-async-cmd-logging (cmd buffer &optional (name "cmd"))
  "Run CMD, logging asynchronously to BUFFER."
  (start-process-shell-command name
			       buffer
			       cmd)
  )

(provide 'mc)
