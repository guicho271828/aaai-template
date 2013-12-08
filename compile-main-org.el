(add-to-list 'load-path "org-mode/lisp/")
(add-to-list 'load-path "org-mode/contrib/lisp/")
(add-to-list 'load-path "org-mode/contrib/babel/langs/")
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

(require 'org)
(autoload 'org-latex-export-as-latex "ox-latex")

(defun compile-org (in out)
  (find-file in)
  (org-latex-export-as-latex nil nil nil t)
  (write-file out))