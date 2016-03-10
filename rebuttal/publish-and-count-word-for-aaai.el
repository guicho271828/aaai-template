
(defun publish-and-count-word-for-aaai ()
  (interactive)
  (let ((filename
         (cond
           ((functionp 'org-export-as-ascii)
            (org-export-as-ascii 0))
           ((functionp 'org-ascii-export-to-ascii)
            (org-ascii-export-to-ascii)))))
    (shell-command (format "./count-word-aaai.sh %s" filename)))
  t)

(add-hook 'after-save-hook 'publish-and-count-word-for-aaai
          nil t)


  
