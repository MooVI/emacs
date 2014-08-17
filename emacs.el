;Load Path
(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/Storage/Programming/Emacs")
(add-to-list 'load-path "~/Storage/Programming/Emacs/emacs-24.3/lisp/progmodes")
(add-to-list 'custom-theme-load-path "~/Storage/Programming/Emacs/Themes/")

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives 
    '("melpa" . 
      "http://melpa.milkbox.net/packages/"))

;YasSnippet
(add-to-list 'load-path "~/Storage/Programming/Emacs/plugins/yasnippet")

;Theme
(load-theme 'solarized-dark t)


;R (ESS)

(load "~/Storage/Programming/Emacs/ess/lisp/ess-site")


;IDO
(require 'ido)
(ido-mode t)

(require 'ido-ubiquitous)
(ido-ubiquitous-mode t)

(require 'smex) 
(smex-initialize)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)                  



;Fill Column Indicator
(require 'fill-column-indicator)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'c++-mode-hook 'fci-mode)
(add-hook 'python-mode-hook 'fci-mode)
(add-hook 'clojure-mode-hook
          (lambda ()
            (set-fill-column 100)))


;AutoComplete

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20140314.802/dict")
(ac-config-default)


;AucTeX

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(put 'upcase-region 'disabled nil)
(setq ps-print-header-frame nil)
(setq ps-show-n-of-n t)
(setq ps-header-lines 1)
(setq TeX-parse-self t)
(setq TeX-auto-save t)

(require 'ac-math)

(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`

(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
     (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ac-sources)))


(ac-flyspell-workaround)

;(require 'auto-complete-auctex)

;LaTeX Hooks
(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)


;Python

(require 'python)



(defun eval-window-buffer ()
  "Evaluate ./window.py"
  (interactive)
  (python-shell-send-file "./window.py"))

(defun python-mode-keys ()
  "Modify python-mode keys"
  (local-set-key (kbd "C-c C-w") 'eval-window-buffer))


(add-hook 'python-mode-hook 'python-mode-keys)

;; (defun my-compile ()
;;   "Use compile to run python programs"
;;   (interactive)
;;   (compile (concat "python " (buffer-name))))
;; (setq compilation-scroll-output t)


;; (add-hook 'python-mode-hook (local-set-key "\C-c\C-c" 'my-compile))


(defun flymake-create-temp-in-system-tempdir (filename prefix)
  (make-temp-file (or prefix "flymake")))

(setq pycodechecker "pylint_etc_wrapper.py")
(when (load "flymake" t)
  (load-library "flymake-cursor")
  (defun dss/flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" dss/flymake-pycodecheck-init)))


(setq temporary-file-directory "~/.emacs.d/tmp/")
(setq flymake-run-in-place nil)

(defun dss/pylint-msgid-at-point ()
(interactive)
(let (msgid
(line-no (line-number-at-pos)))
(dolist (elem flymake-err-info msgid)
(if (eq (car elem) line-no)
(let ((err (car (second elem))))
(setq msgid (second (split-string (flymake-ler-text err)))))))))

(defun dss/pylint-silence (msgid)
"Add a special pylint comment to silence a particular warning."
(interactive (list (read-from-minibuffer "msgid: " (dss/pylint-msgid-at-point))))
(save-excursion
(comment-dwim nil)
(if (looking-at "pylint:")
(progn (end-of-line)
(insert ","))
(insert "pylint: disable-msg="))
(insert msgid)))

;Ipython

(setq
python-shell-interpreter "ipython3"
python-shell-interpreter-args "--no-autoindent"
python-shell-prompt-regexp "In \\[[0-9]+\\]: "
python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: "
python-shell-completion-setup-code
"from IPython.core.completerlib import module_completion"
python-shell-completion-module-string-code
"';'.join(module_completion('''%s'''))\n"
python-shell-completion-string-code
"';'.join(get_ipython().Completer.all_completions('''%s'''))\n")


;MMM and RST

(require 'mmm-mode)
(setq mmm-global-mode 'maybe)
(mmm-add-classes
 '((python-rst
    :submode rst-mode
    :front "^ *[ru]?\"\"\"[^\"]*$"
    :back "^ *\"\"\""
    :include-front t
    :include-back t
    :end-not-begin t)))
(mmm-add-mode-ext-class 'python-mode nil 'python-rst)


(defun make-rst ()
  "Make and view documentation for pygametest."
  (interactive)
  (shell-command "make singlehtml")
  (save-window-excursion
   (shell-command "firefox ./_build/singlehtml/index.html &")))

(defun rst-mode-keys ()
  "Modify python-mode keys"
  (local-set-key (kbd "C-c C-c") 'make-rst))


(add-hook 'rst-mode-hook 'rst-mode-keys)


;Not working, can't be asked to fix
;(require 'auto-complete-rst)
;(eval-after-load "rst" '(auto-complete-rst-init))

;Jedi
;(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)




;Git
(global-set-key (kbd "C-c C-g") 'magit-status)

;GLSL editing
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.cl\\'" . c-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))


;YAML
 (require 'yaml-mode)
   (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;Gnuplot

;; load the file
(require 'gnuplot-mode)

;; automatically open files ending with .gp or .gnuplot or plt in gnuplot mode
(setq auto-mode-alist 
(append '(("\\.\\(gp\\|gnuplot\\|plt\\)$" . gnuplot-mode)) auto-mode-alist))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-enable-toolbar t)
 '(TeX-PDF-mode t)
 '(TeX-save-query nil)
 '(cua-mode t nil (cua-base))
 '(custom-safe-themes (quote ("fdbe1d8c4ab681385cf679fb2c9d7643a606e6bb048d60320d728f70fcb53727" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" default)))
 '(inhibit-startup-screen t)
 '(preview-auto-cache-preamble t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(defun latex-word-count ()
  (interactive)
  (shell-command (concat "texcount "
                         ; "uncomment then options go here "
                         (buffer-file-name))))

;Flymake
(add-hook 'c-mode-hook 'flymake-mode)
(add-hook 'c++-mode-hook 'flymake-mode)
(add-hook 'python-mode-hook 'flymake-mode)



;Org Mode
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)



;Winner Mode and Moving
(when (fboundp 'winner-mode)
      (winner-mode 1))

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


(windmove-default-keybindings 'meta)


;Moving for Org Mode
(defun move-cursor-next-pane ()
  "Move cursor to the next pane."
  (interactive)
  (other-window 1))

(defun move-cursor-previous-pane ()
  "Move cursor to the previous pane."
  (interactive)
  (other-window -1))


(global-set-key (kbd "C-0") 'move-cursor-next-pane)
(global-set-key (kbd "C-9") 'move-cursor-previous-pane)

;Splitting Windows
(defun split-window-4()
 "Splite window into 4 sub-window"
 (interactive)
 (if (= 1 (length (window-list)))
     (progn (split-window-vertically)
	    (split-window-horizontally)
	    (other-window 2)
	    (split-window-horizontally)
	    )
   )
)

(defun change-split-type (split-fn &optional arg)
  "Change 3 window style from horizontal to vertical and vice-versa"
  (let ((bufList (mapcar 'window-buffer (window-list))))
    (select-window (get-largest-window))
    (funcall split-fn arg)
    (mapcar* 'set-window-buffer (window-list) bufList)))


(defun change-split-type-2 (&optional arg)
  "Changes splitting from vertical to horizontal and vice-versa"
  (interactive "P")
  (let ((split-type (lambda (&optional arg)
                      (delete-other-windows-internal)
                      (if arg (split-window-vertically)
                        (split-window-horizontally)))))
    (change-split-type split-type arg)))

(defun change-split-type-3-v (&optional arg)
  "change 3 window style from horizon to vertical"
  (interactive "P")
  (change-split-type 'split-window-3-horizontally arg))

(defun change-split-type-3-h (&optional arg)
  "change 3 window style from vertical to horizon"
  (interactive "P")
  (change-split-type 'split-window-3-vertically arg))

(defun split-window-3-horizontally (&optional arg)
  "Split window into 3 while largest one is in horizon"
;  (interactive "P")
  (delete-other-windows)
  (split-window-horizontally)
  (if arg (other-window 1))
  (split-window-vertically))

(defun split-window-3-vertically (&optional arg)
  "Split window into 3 while largest one is in vertical"
;  (interactive "P")
  (delete-other-windows)
  (split-window-vertically)
  (if arg (other-window 1))
  (split-window-horizontally))

;Occur in matching modes

(eval-when-compile
  (require 'cl))
 
(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (let ((buffer-mode-matches '()))
   (dolist (buf (buffer-list))
     (with-current-buffer buf
       (if (eq mode major-mode)
           (add-to-list 'buffer-mode-matches buf))))
   buffer-mode-matches))
 
(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))
 
;; global key for `multi-occur-in-this-mode' - you should change this.
(global-set-key (kbd "C-<f2>") 'multi-occur-in-this-mode)


;Renaming
(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))