

(defun mc/snippet/python/headline ()
  "Insert python environment and utf8 encoding"
  (interactive)
  (insert "#!/usr/bin/env python
# -*- coding: utf-8 -*-"))


(defun mc/snippet/org/headline ()
  "Insert hidestars"
  (interactive)
  (insert "#+STARTUP: hidestars"))


(provide 'mc-snippets)
