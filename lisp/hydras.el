;;; package --- Summary
;;; Commentary:
;;; Code:

(defhydra hydra-font-size ()
  "
Font size hydra
"
  ("g" text-scale-increase "increase font size")
  ("l" text-scale-decrease "decrease font size")
  ("q" nil))


(defhydra hydra-debug-python ()
  "
Debug python
"
  ("p" pdb "start pdb" :exit 1)
  ("b" gud-break "set breakpoint at current line")
  ("c" gud-cont "continue until next breakpoint")
  ("n" gud-next "step to next line")
  ("q" nil))

(global-set-key (kbd "M-h")
		(defhydra hydra-all (:color red)
		  "
_f_ change font size
_p_ python debugging
"
		  ("f" hydra-font-size/body :exit t)
		  ("p" hydra-debug-python/body :exit t)
		  ("q" nil)
		  ))

(provide 'hydras)
;;; hydras.el ends here
