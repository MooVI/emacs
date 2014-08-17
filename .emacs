(add-hook 'after-init-hook (lambda () (load "~/emacs.el")))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-enable-toolbar t)
 '(TeX-PDF-mode t)
 '(TeX-save-query nil)
 '(TeX-source-correlate-mode t)
 '(TeX-source-correlate-start-server t)
 '(TeX-view-program-selection (quote (((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi") (output-pdf "Evince") (output-html "xdg-open"))))
 '(cua-mode t nil (cua-base))
 '(cua-remap-control-z t)
 '(custom-safe-themes (quote ("fdbe1d8c4ab681385cf679fb2c9d7643a606e6bb048d60320d728f70fcb53727" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(doc-view-continuous t)
 '(inhibit-startup-screen t)
 '(org-capture-templates (quote (("p" "Plain" entry (file "~/org~/notes.org") "* %?") ("n" "Notes" entry (file "~/org~/notes.org") "* %? :Note:
	    %U"))))
 '(preview-auto-cache-preamble t)
 '(safe-local-variable-values (quote ((column-number-mode . true)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
