;; Define a variable to indicate whether we're running XEmacs/Lucid Emacs.  (You do not have to defvar a global
;; variable before using it -- you can just call `setq' directly.  It's clearer this way, though.  Note also
;; how we check if this variable already exists using `boundp', because it's defined in recent versions of
;; XEmacs.)

(or (boundp 'running-xemacs)
    (defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version)))

;; Define a function to make it easier to check which version we're running.  This function already exists in
;; recent XEmacs versions, and in fact all we've done is copied the definition.  Note again how we check to
;; avoid clobbering an existing definition. (It's good style to do this, in case some improvement was made to
;; the already-existing function -- otherwise we might subsitute an older definition and possibly break some
;; code elsewhere.)
;;
;; NOTE ALSO: It is in general *NOT* a good idea to do what we're doing -- i.e. provide a definition of a
;; function that is present in newer versions of XEmacs but not older ones.  The reason is that it may confuse
;; code that notices the presence of the function and proceeds to use it and other functionality that goes
;; along with it -- but which we may not have defined.  What's better is to create the function with a
;; different name -- typically, prefix it with the name of your module, which in this case might be `Init-'.
;; For `emacs-version>=' we make an exception because (a) the function has been around a long time, (b) there
;; isn't really any other functionality that is paired with it, (c) it's definition hasn't changed and isn't
;; likely to, and (d) the calls to `emacs-version>=' or its renamed replacement would be scattered throughout
;; the code below, and with a replacement name the code would become significantly less portable into someone
;; else's init.el file. (BUT NOTE BELOW: We do follow the procedure outlined above with renaming in a different
;; case where the specifics are much different.)
;;
;; TIP: At this point you may be wondering how I wrote all these nice, long, nicely-justified textual stretches
;; -- didn't I go crazy sticking in the semicolons everywhere and having to delete them and rearrange
;; everything whenever I wanted to make any corrections to the text?  The answer is -- of course not!  Use M-q.
;; This does all the magic for you, justifying and breaking lines appropriately and putting any necessary
;; semicolons or whatever at the left (it figures out what this ought to be by looking in a very clever fashion
;; at what's already at the beginning of each line in the paragraph).  You may need `filladapt' set up (it's
;; done below in this file) in order for this to work properly.  Finally, if you want to turn on automatic
;; filling (like in a word processor, but not quite as automatic), use M-x auto-fill-mode or the binding set up
;; below in this file (Meta-F9).

(or (fboundp 'emacs-version>=)
    (defun emacs-version>= (major &optional minor patch)
      "Return true if the Emacs version is >= to the given MAJOR, MINOR, and PATCH numbers.  The MAJOR version
number argument is required, but the other arguments argument are optional. Only the Non-nil arguments are used
in the test."
      (let ((emacs-patch (or emacs-patch-level emacs-beta-version -1)))
	(cond ((> emacs-major-version major))
	      ((< emacs-major-version major) nil)
	      ((null minor))
	      ((> emacs-minor-version minor))
	      ((< emacs-minor-version minor) nil)
	      ((null patch))
	      ((>= emacs-patch patch))))))

;; Here are some example code snippets that you can use if you need to
;; conditionalize on a particular version of Emacs (in general, though,
;; it is much better to use `fboundp', `featurep', or other such
;; feature-specific checks rather than version-specific checks):

(cond (running-xemacs
       ;; Code requiring XEmacs
       (load "~/.xemacs/xemacs.el" t t))
      ((not running-xemacs)
       ;; Code specific to GNU Emacs
       (load "~/.emacs.d/emacs.el" t t)))


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))
