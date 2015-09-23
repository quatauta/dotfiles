(package-initialize)

;; Load user local packages
(add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp"))

(require 'filladapt)
(require 'shell-command)
(shell-command-completion-mode)

;; (autoload 'bst-mode "bst-mode" "BibTeX style definition file mode" t)
;; (autoload 'gedcom-mode "gedcom")
;; (autoload 'pov-mode "pov-mode" "PoVray scene file mode" t)

;; (add-to-list 'auto-mode-alist '("\\.bst$" . bst-mode))
;; (add-to-list 'auto-mode-alist '("lltmp[0-9a-zA-Z]+$" . gedcom-mode))
;; (add-to-list 'auto-mode-alist '("\\.ged$" . gedcom-mode))
;; (add-to-list 'auto-mode-alist '("\\.pov$" . pov-mode))
;; (add-to-list 'auto-mode-alist '("\\.inc$" . pov-mode))


(defun system-name-simple ()
  "Returns the host-part of (system-name).  Simply returns the
  substring from the beginning up to the first dot."
  (substring system-name 0 (string-match "\\..+" system-name)))

(cond (window-system
       (let ((title-format (concat "%b - " invocation-name "@" (system-name-simple))))
	 (setq frame-title-format title-format)
	 (setq icon-title-format  title-format)
	 )))


;; Custom Settings
(setq custom-file "~/.emacs.d/custom.el")
(load "~/.emacs.d/custom.el" t t)


;; Names for calendar command
(defvar calendar-day-name-array ["Sonntag" "Montag" "Dienstag" "Mittwoch" "Donnerstag" "Freitag" "Samstag"])
(defvar calendar-month-name-array ["Januar" "Februar" "März" "April" "Mai" "Juni"
				   "Juli" "August" "September" "Oktober" "November" "Dezember"])


;; Java Development Environment for Emacs (JDE) Setup
;;
;; If you want Emacs to defer loading the JDE until you open a
;; Java file, edit the following line (nil: load JDE on Emacs
;; startup, t: load JDE on opening first java-file).
; (setq defer-loading-jde t)
; (if defer-loading-jde
;     (progn
;       (autoload 'jde-mode "jde" "JDE mode." t)
;       (setq auto-mode-alist
;             (append
;              '(("\\.java\\'" . jde-mode))
;              auto-mode-alist)))
;   (require 'jde))


;;;;;;
;; AUC TeX related
;(require 'tex-site)
; (load "auctex.el" nil t t)

;; Reftex activation (Reftex is included with Emacs 21.1)
; (autoload 'reftex-mode     "reftex" "RefTeX Minor Mode" t)
; (autoload 'turn-on-reftex  "reftex" "RefTeX Minor Mode" t)
; (autoload 'reftex-citation "reftex-cite" "Make citation" t)
; (autoload 'reftex-index-phrase-mode "reftex-index" "Phrase mode" t)
; (autoload 'turn-on-bib-cite "bib-cite")

;; settings for bib-cite.el (provided with auctex)
; (require 'imenu)
; (define-key global-map [S-mouse-3] 'imenu)

;; OUTLINE
; (setq outline-minor-mode-prefix "\C-c\C-o")
; (setq TeX-outline-extra
;       '(("[ \t]*\\\\\\(bib\\)?item\\b" 7)
;         ("\\\\bibliography\\b" 2)))
;;;;;


;;;;;;
;; Ruby
(add-hook 'ruby-mode-hook
	  (lambda ()
            (local-unset-key "{")
            (local-unset-key "}")
            (local-set-key "\r" 'newline-and-indent)
	    ))
;;;;;;


;; Set windmove default key-bindings Shift-(left|right|up|down)
(require 'windmove)
(windmove-default-keybindings)


;; Answer y instead of yes on prompts.
(defalias 'yes-or-no-p 'y-or-n-p)


;; Enable the function "downcase-region" (C-x C-l)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)


(defun fill-sentence ()
  "Fill sentence"
  (interactive)
  (save-excursion
    (forward-sentence -1)
    (let ((beg (point)))
      (forward-sentence)
      (fill-region-as-paragraph beg (point)))))
(global-set-key "\M-Q" 'fill-sentence)


(defun indent-buffer ()
  "Indent whole buffer."
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


;; key bindings
(global-set-key (kbd "<f11>") 'next-error)
; (global-set-key (kbd "\C-x b") 'bs-show)

(require 'home-end)
(global-set-key [end]  'home-end-end)
(global-set-key [home] 'home-end-home)

;; Set FFAP (find-file at point) bindings
(ffap-bindings)

;; css-mode indenter
(setq cssm-indent-function #'cssm-c-style-indenter)

;; Load inkpot theme
(load-theme 'inkpot)
