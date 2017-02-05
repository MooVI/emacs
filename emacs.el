;Current Packages: (deferred deferred ido-completing-read+ ido-completing-read+ ido-ubiquitous ido-completing-read+ ido-ubiquitous magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async git-commit with-editor dash async dash git-commit with-editor dash async with-editor magit-popup dash async magit-popup async async dash dash mmm-mode mmm-mode yaml-mode yaml-mode auto-complete-rst auto-complete popup color-theme-solarized color-theme flymake ido-ubiquitous ido-completing-read+ jedi auto-complete popup jedi-core python-environment deferred epc ctable concurrent deferred jedi-core python-environment deferred epc ctable concurrent deferred magit git-rebase-mode git-commit-mode mmm-mode popup python-environment deferred yaml-mode)


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
(load-theme 'solarized t)


;R (ESS)

(load "~/Storage/Programming/Emacs/ess/lisp/ess-site")


;Magit
(setq magit-completing-read-function 'magit-ido-completing-read)

;For comint modes, make arrow keys history
(eval-after-load "comint"
'(progn
(define-key comint-mode-map [up]
'comint-previous-matching-input-from-input)
(define-key comint-mode-map [down]
'comint-next-matching-input-from-input)
))


;IDO
(require 'ido)
(ido-mode t)
(ido-everywhere t)

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


(require 'ws-butler)
(add-hook 'python-mode-hook 'ws-butler-mode)

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
python-shell-interpreter-args "--simple-prompt -i"
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
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)




;Git
(global-set-key (kbd "C-c C-g") 'magit-status)
(setq magit-last-seen-setup-instructions "1.4.0")

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
;(add-hook 'python-mode-hook 'flymake-mode)

(require 'tramp-cmds)

(setq password-cache-expiry nil)

(add-hook 'python-mode-hook
	  (lambda ()
	    (when (and buffer-file-name
		       (file-writable-p
			(file-name-directory buffer-file-name))
		       (file-writable-p buffer-file-name)
		       (not (subsetp
			     (list (current-buffer))
			     (tramp-list-remote-buffers))))
	      (local-set-key (kbd "C-c d")
			     'flymake-display-err-menu-for-current-line)
	      (flymake-mode t))))


;Org Mode
(require 'org)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'visual-line-mode)



(run-at-time "00:59" 3600 'org-save-all-org-buffers)



;Org Ediff
;; ediff for org-mode files
(add-hook 'ediff-prepare-buffer-hook 
          (lambda () 
            (cond ((eq major-mode 'org-mode)
                   (visible-mode 1)))))

;Org Word Count
(require 'org-wc)

(defun tidy ()
  "Tidy up a buffer by replacing all special Unicode characters
   (smart quotes, etc.) with their more sane cousins"
  (interactive)
  (let ((unicode-map '(("[\u2018\|\u2019\|\u201A\|\uFFFD]" . "'")
                       ("[\u201c\|\u201d\|\u201e]" . "\"")
                       ("[\u2013\]" . "--")
		       ("[\u2014\]" . "---")
                       ("\u2026" . "...")
                       ("\u00A9" . "(c)")
                       ("\u00AE" . "(r)")
                       ("\u2122" . "TM")
                       ("[\u02DC\|\u00A0]" . " "))))
    (save-excursion
      (loop for (key . value) in unicode-map
            do
            (goto-char (point-min))
            (replace-regexp key value)))))

;(setq org-default-notes-file (concat org-directory "~/notes.org"))

; Targets include this file and any file contributing to the agenda - up to 9 levels deep
(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-completion-use-ido t)

;;;; Refile settings
; Exclude DONE state tasks from refile targets
(defun bh/verify-refile-target ()
  "Exclude todo keywords with a done state from refile targets"
  (not (member (nth 2 (org-heading-components)) org-done-keywords)))

(setq org-refile-target-verify-function 'bh/verify-refile-target)

(setq org-agenda-files "~/org~/agenda_files")

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

;;Ignore Text when exporting
;; backend aware export preprocess hook
;(defun sa-org-export-preprocess-hook ()
;  "My backend aware export preprocess hook."
;  (interactive)
;  (save-excursion
;    (when (eq org-export-current-backend 'latex)
;      ;; ignoreheading tag for bibliographies and appendices
;      (let* ((tag "text"))
;        (org-map-entries (org-cut-subtree)
;                         (concat ":" tag ":"))))))

;(add-hook 'org-export-preprocess-hook 'sa-org-export-preprocess-hook)



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


(require 'ox-odt)


;Org Export
(defun symmetry ()
  "Export symmetry."
  (interactive)
  (shell-command "python3 parse.py")
  (set-buffer (find-file-noselect "~/Storage/Writing/Symmetry/text.org" t))
  (org-latex-export-to-pdf)
  (org-word-count (point-min) (point-max))
  (call-process-shell-command "evince text.pdf&" nil 0)
  (kill-buffer "text.org")
  (shell-command "rm text.org text.tex")
  )

;Export to odt
(defun exp_odt ()
  "Export symmetry."
  (interactive)
  (shell-command "python3 parse.py")
  (set-buffer (find-file-noselect "~/Storage/Writing/Symmetry/text.org" t))
  (org-odt-export-to-odt)
  (org-word-count (point-min) (point-max))
  (call-process-shell-command "gnome-open text.odt&" nil 0)
  (kill-buffer "text.org")
  (shell-command "rm text.org text.tex")
  )

;Org Export
(defun swc ()
  "Export symmetry."
  (interactive)
  (shell-command "python3 parse.py")
  (set-buffer (find-file-noselect "~/Storage/Writing/Symmetry/text.org" t))
  (org-word-count (point-min) (point-max))
  (kill-buffer "text.org")
  (with-temp-buffer (shell-command "rm text.org" t))
  )

;Copy paste
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)



					;Word Frequency
(defvar punctuation-marks '(","
                            "."
                            "'"
                            "&"
                            "\"")
  "List of Punctuation Marks that you want to count.")

(defun count-raw-word-list (raw-word-list)
  (cl-loop with result = nil
           for elt in raw-word-list
           do (incf (cdr (or (assoc elt result)
                             (first (push (cons elt 0) result)))))
           finally return (sort result
                                (lambda (a b) (string< (car a) (car b))))))

(defun word-stats ()
  (interactive)
  (let* ((words (split-string
                 (downcase (buffer-string))
                 (format "[ %s\f\t\n\r\v]+"
                         (mapconcat #'identity punctuation-marks ""))
                 t))
         (punctuation-marks (cl-remove-if-not
                             (lambda (elt) (member elt punctuation-marks))
                             (split-string (buffer-string) "" t )))
         (raw-word-list (append punctuation-marks words))
         (word-list (count-raw-word-list raw-word-list)))
    (with-current-buffer (get-buffer-create "*word-statistics*")
      (erase-buffer)
      (insert "| word | occurences |
               |-----------+------------|\n")

      (dolist (elt word-list)
        (insert (format "| '%s' | %d |\n" (car elt) (cdr elt))))

      (org-mode)
      (indent-region (point-min) (point-max))
      (goto-char 100)
      (org-cycle)
      (goto-char 79)
      (org-table-sort-lines nil ?N)))
  (pop-to-buffer "*word-statistics*"))

  (defun my-insert-file-name (filename &optional args)
    "Insert name of file FILENAME into buffer after point.
  
  Prefixed with \\[universal-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.
  
  Prefixed with \\[negative-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.
  
  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
    ;; Based on insert-file in Emacs -- ashawley 20080926
    (interactive "*fInsert file name: \nP")
    (cond ((eq '- args)
           (insert (file-relative-name filename)))
          ((not (null args))
           (insert (expand-file-name filename)))
          (t
           (insert filename))))

(defun my-insert-relative-file-name (filename &optional args)
    "Insert name of file FILENAME into buffer after point.
  
  Prefixed with \\[negative-argument], expand the file name to
  its fully canocalized path.  See `expand-file-name'.
  
  Prefixed with \\[universal-argument], use relative path to file
  name from current directory, `default-directory'.  See
  `file-relative-name'.
  
  The default with no prefix is to insert the file name exactly as
  it appears in the minibuffer prompt."
    ;; Based on insert-file in Emacs -- ashawley 20080926
    (interactive "*fInsert file name: \nP")
    (cond ((eq '- args)
           (insert (file-relative-name filename)))
          ((not (null args))
           (insert (expand-file-name filename)))
          (t
           (insert filename))))


(global-set-key "\C-c\C-i" 'my-insert-file-name)
(global-set-key "\C-c\C-r" 'my-insert-relative-file-name)
