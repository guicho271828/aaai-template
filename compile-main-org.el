(message default-directory)
(add-to-list 'load-path (concat default-directory "org-mode/lisp/"))
(add-to-list 'load-path (concat default-directory "org-mode/contrib/lisp/"))
(add-to-list 'load-path (concat default-directory "org-mode/contrib/babel/langs/"))


(defun compile-org (in out)
  (require 'org)
  (require 'org-table)
  (require 'ox-latex)
  (find-file in)
  (org-latex-export-to-latex nil nil t t)
;;   (replace-regexp "^#.*
;; " "")
;;   (replace-regexp "\\\\label{sec-[0-9][^}]*}" "")
;;   (write-file out)
  )
