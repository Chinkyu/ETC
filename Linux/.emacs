;; -*- Mode: Emacs-Lisp -*-

;;; This is a sample .emacs file.
;;;
;;; The .emacs file, which should reside in your home directory, allows you to
;;; customize the behavior of Emacs.  In general, changes to your .emacs file
;;; will not take effect until the next time you start up Emacs.  You can load
;;; it explicitly with `M-x load-file RET ~/.emacs RET'.
;;;
;;; There is a great deal of documentation on customization in the Emacs
;;; manual.  You can read this manual with the online Info browser: type
;;; `C-h i' or select "Emacs Info" from the "Help" menu.



;; for size 

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'default-frame-alist '(width . 100)) ; character
(add-to-list 'default-frame-alist '(height . 52)) ; lines


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                      Basic Customization                         ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable the command `narrow-to-region' ("C-x n n"), a useful
;; command, but possibly confusing to a new user, so it's disabled by
;; default.
(put 'narrow-to-region 'disabled nil)

;;; Define a variable to indicate whether we're running XEmacs/Lucid Emacs.
;;; (You do not have to defvar a global variable before using it --
;;; you can just call `setq' directly like we do for `emacs-major-version'
;;; below.  It's clearer this way, though.)

(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Make the sequence "C-x w" execute the `what-line' command, 
;; which prints the current line number in the echo area.
(global-set-key "\C-xw" 'what-line)

;; set up the function keys to do common tasks to reduce Emacs pinky
;; and such.

;; Make F1 invoke help
(global-set-key [f1] 'help-command)
;; Make F2 be `undo'
(global-set-key [f2] 'undo)
;; Make F3 be `find-file'
;; Note: it does not currently work to say
;;   (global-set-key 'f3 "\C-x\C-f")
;; The reason is that macros can't do interactive things properly.
;; This is an extremely longstanding bug in Emacs.  Eventually,
;; it will be fixed. (Hopefully ..)
(global-set-key [f3] 'find-file)

;; Make F4 be "mark", F5 be "copy", F6 be "paste"
;; Note that you can set a key sequence either to a command or to another
;; key sequence.
(global-set-key [f4] 'set-mark-command)
(global-set-key [f5] "\M-w")
(global-set-key [f6] "\C-y")

;; Shift-F4 is "pop mark off of stack"
(global-set-key [(shift f4)] (lambda () (interactive) (set-mark-command t)))

;; Make F7 be `save-buffer'
(global-set-key [f7] 'save-buffer)

;; Make F8 be "start macro", F9 be "end macro", F10 be "execute macro"
(global-set-key [f8] 'start-kbd-macro)
(global-set-key [f9] 'end-kbd-macro)
(global-set-key [f10] 'call-last-kbd-macro)

;; Here's an alternative binding if you don't use keyboard macros:
;; Make F8 be `save-buffer' followed by `delete-window'.
;;(global-set-key 'f8 "\C-x\C-s\C-x0")

;; If you prefer delete to actually delete forward then you want to
;; uncomment the next line (or use `Customize' to customize this).
;; (setq delete-key-deletes-forward t)


(cond (running-xemacs
       ;;
       ;; Code for any version of XEmacs/Lucid Emacs goes here
       ;;

       ;; Change the values of some variables.
       ;; (t means true; nil means false.)
       ;;
       ;; Use the "Describe Variable..." option on the "Help" menu
       ;; to find out what these variables mean.
       (setq find-file-use-truenames nil
             find-file-compare-truenames t
             minibuffer-confirm-incomplete t
             complex-buffers-menu-p t
             next-line-add-newlines nil
             mail-yank-prefix "> "
             kill-whole-line t
             )

       ;; When running ispell, consider all 1-3 character words as correct.
       (setq ispell-extra-args '("-W" "3"))

       (cond ((or (not (fboundp 'device-type))
                  (equal (device-type) 'x))
              ;; Code which applies only when running emacs under X goes here.
       ;; (We check whether the function `device-type' exists
       ;; before using it.  In versions before 19.12, there
       ;; was no such function.  If it doesn't exist, we
       ;; simply assume we're running under X -- versions before
       ;; 19.12 only supported X.)

              ;; Remove the binding of C-x C-c, which normally exits emacs.
       ;; It's easy to hit this by mistake, and that can be annoying.
       ;; Under X, you can always quit with the "Exit Emacs" option on
       ;; the File menu.
       (global-set-key "\C-x\C-c" nil)

              ;; Uncomment this to enable "sticky modifier keys" in 19.13
       ;; and up.  With sticky modifier keys enabled, you can
       ;; press and release a modifier key before pressing the
       ;; key to be modified, like how the ESC key works always.
       ;; If you hold the modifier key down, however, you still
       ;; get the standard behavior.  I personally think this
       ;; is the best thing since sliced bread (and a *major*
       ;; win when it comes to reducing Emacs pinky), but it's
       ;; disorienting at first so I'm not enabling it here by
       ;; default.

              ;;(setq modifier-keys-are-sticky t)

              ;; This changes the variable which controls the text that goes
       ;; in the top window title bar.  (However, it is not changed
       ;; unless it currently has the default value, to avoid
       ;; interfering with a -wn command line argument I may have
       ;; started emacs with.)
       (if (equal frame-title-format "%S: %b")
                  (setq frame-title-format
                        (concat "%S: " invocation-directory invocation-name
                                " [" emacs-version "]"
                                (if nil ; (getenv "NCD")
                             ""
                                  "   %b"))))

              ;; If we're running on display 0, load some nifty sounds that
       ;; will replace the default beep.  But if we're running on a
       ;; display other than 0, which probably means my NCD X terminal,
       ;; which can't play digitized sounds, do two things: reduce the
       ;; beep volume a bit, and change the pitch of the sound that is
       ;; made for "no completions."
       ;;
       ;; (Note that sampled sounds only work if XEmacs was compiled
       ;; with sound support, and we're running on the console of a
       ;; Sparc, HP, or SGI machine, or on a machine which has a
       ;; NetAudio server; otherwise, you just get the standard beep.)
       ;;
       ;; (Note further that changing the pitch and duration of the
       ;; standard beep only works with some X servers; many servers
       ;; completely ignore those parameters.)
       ;;
       (cond ((string-match ":0" (getenv "DISPLAY"))
                     (load-default-sounds))
                    (t
                     (setq bell-volume 40)
                     (setq sound-alist
                           (append sound-alist '((no-completion :pitch 500))))
                     ))

              ;; Make `C-x C-m' and `C-x RET' be different (since I tend
       ;; to type the latter by accident sometimes.)
       (define-key global-map [(control x) return] nil)

              ;; Change the pointer used when the mouse is over a modeline
       (set-glyph-image modeline-pointer-glyph "leftbutton")

              ;; Change the continuation glyph face so it stands out more
       (and (fboundp 'set-glyph-property)
                   (boundp 'continuation-glyph)
                   (set-glyph-property continuation-glyph 'face 'bold))

              ;; Change the pointer used during garbage collection.
       ;;
       ;; Note that this pointer image is rather large as pointers go,
       ;; and so it won't work on some X servers (such as the MIT
       ;; R5 Sun server) because servers may have lamentably small
       ;; upper limits on pointer size.
       ;;(if (featurep 'xpm)
       ;;   (set-glyph-image gc-pointer-glyph
       ;;   (expand-file-name "trash.xpm" data-directory)))

              ;; Here's another way to do that: it first tries to load the
       ;; pointer once and traps the error, just to see if it's
       ;; possible to load that pointer on this system; if it is,
       ;; then it sets gc-pointer-glyph, because we know that
       ;; will work.  Otherwise, it doesn't change that variable
       ;; because we know it will just cause some error messages.
       (if (featurep 'xpm)
                  (let ((file (expand-file-name "recycle.xpm" data-directory)))
                    (if (condition-case error
                            ;; check to make sure we can use the pointer.
                     (make-image-instance file nil
                                                 '(pointer))
                          (error nil))      ; returns nil if an error occurred.
                 (set-glyph-image gc-pointer-glyph file))))

              (when (featurep 'menubar)
                ;; Add `dired' to the File menu
         (add-menu-button '("File") ["Edit Directory" dired t])

                ;; Here's a way to add scrollbar-like buttons to the menubar
         (add-menu-button nil ["Top" beginning-of-buffer t])
                (add-menu-button nil ["<<<" scroll-down         t])
                (add-menu-button nil [" . " recenter            t])
                (add-menu-button nil [">>>" scroll-up           t])
                (add-menu-button nil ["Bot" end-of-buffer       t]))

              ;; Change the behavior of mouse button 2 (which is normally
       ;; bound to `mouse-yank'), so that it inserts the selected text
       ;; at point (where the text cursor is), instead of at the
       ;; position clicked.
       ;;
       ;; Note that you can find out what a particular key sequence or
       ;; mouse button does by using the "Describe Key..." option on
       ;; the Help menu.
       (setq mouse-yank-at-point t)

              ;; When editing C code (and Lisp code and the like), I often
       ;; like to insert tabs into comments and such.  It gets to be
       ;; a pain to always have to use `C-q TAB', so I set up a more
       ;; convenient binding.  Note that this does not work in
       ;; TTY frames, where tab and shift-tab are indistinguishable.
       (define-key global-map '(shift tab) 'self-insert-command)

              ;; LISPM bindings of Control-Shift-C and Control-Shift-E.
       ;; Note that "\C-C" means Control-C, not Control-Shift-C.
       ;; To specify shifted control characters, you must use the
       ;; more verbose syntax used here.
       (define-key emacs-lisp-mode-map '(control C) 'compile-defun)
              (define-key emacs-lisp-mode-map '(control E) 'eval-defun)

              ;; If you like the FSF Emacs binding of button3 (single-click
       ;; extends the selection, double-click kills the selection),
       ;; uncomment the following:

              ;; Under 19.13, the following is enough:
              ;(define-key global-map 'button3 'mouse-track-adjust)

              ;; But under 19.12, you need this:
              ;(define-key global-map 'button3
              ;    (lambda (event)
              ;      (interactive "e")
              ;      (let ((default-mouse-track-adjust t))
              ;        (mouse-track event))))

              ;; Under both 19.12 and 19.13, you also need this:
              ;(add-hook 'mouse-track-click-hook
              ;          (lambda (event count)
              ;            (if (or (/= (event-button event) 3)
              ;                    (/= count 2))
              ;                nil ;; do the normal operation
              ;              (kill-region (point) (mark))
              ;              t ;; don't do the normal operations.
              ;              )))

              ))

       ))

;;; Older versions of emacs did not have these variables
;;; (emacs-major-version and emacs-minor-version.)
;;; Let's define them if they're not around, since they make
;;; it much easier to conditionalize on the emacs version.

(if (and (not (boundp 'emacs-major-version))
         (string-match "^[0-9]+" emacs-version))
    (setq emacs-major-version
          (string-to-int (substring emacs-version
                                    (match-beginning 0) (match-end 0)))))
(if (and (not (boundp 'emacs-minor-version))
         (string-match "^[0-9]+\\.\\([0-9]+\\)" emacs-version))
    (setq emacs-minor-version
          (string-to-int (substring emacs-version
                                    (match-beginning 1) (match-end 1)))))

;;; Define a function to make it easier to check which version we're
;;; running.

(defun running-emacs-version-or-newer (major minor)
  (or (> emacs-major-version major)
      (and (= emacs-major-version major)
           (>= emacs-minor-version minor))))

(cond ((and running-xemacs
            (running-emacs-version-or-newer 19 6))
       ;;
       ;; Code requiring XEmacs/Lucid Emacs version 19.6 or newer goes here
       ;;
       ))

(cond ((>= emacs-major-version 19)
       ;;
       ;; Code for any vintage-19 emacs goes here
       ;;
       ))

(cond ((and (not running-xemacs)
            (>= emacs-major-version 19))
       ;;
       ;; Code specific to FSF Emacs 19 (not XEmacs/Lucid Emacs) goes here
       ;;
       ))

(cond ((< emacs-major-version 19)
       ;;
       ;; Code specific to emacs 18 goes here
       ;;
       ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;              Customization of Specific Packages                  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Load gnuserv, which will allow you to connect to XEmacs sessions
;;; using `gnuclient'.

;; If you never run more than one XEmacs at a time, you might want to
;; always start gnuserv.  Otherwise it is preferable to specify
;; `-f gnuserv-start' on the command line to one of the XEmacsen.
; (gnuserv-start)



;;; ********************
;;; Load the default-dir.el package which installs fancy handling
;;;  of the initial contents in the minibuffer when reading
;;; file names.

(if (and running-xemacs
         (or (and (= emacs-major-version 20) (>= emacs-minor-version 1))
             (and (= emacs-major-version 19) (>= emacs-minor-version 15))))
    (require 'default-dir))


;; This adds additional extensions which indicate files normally
;; handled by cc-mode.
(setq auto-mode-alist
      (append '(("\\.C$"  . cc-mode)
                ("\\.cc$" . cc-mode)
                ("\\.hh$" . cc-mode)
                ("\\.c$"  . cc-mode)
                ("\\.h$"  . cc-mode))
              auto-mode-alist))


;;; ********************
;;; cc-mode (the mode you're in when editing C, C++, and Objective C files)

;; Tell cc-mode not to check for old-style (K&R) function declarations.
;; This speeds up indenting a lot.
(setq c-recognize-knr-p nil)

;; Change the indentation amount to 4 spaces instead of 2.
;; You have to do it in this complicated way because of the
;; strange way the cc-mode initializes the value of `c-basic-offset'.
(add-hook 'c-mode-hook (lambda () (setq c-basic-offset 4)))

;;
;; google coding style
;;
;(setq c-default-style "linux")
;(setq c-basic-offset 4)
;(require 'cc-mode)
;;(require 'google-c-style)
;;(add-hook 'c-mode-common-hook 'google-make-newline-indent)

(setq c-default-style "cc-mode")
(require 'cc-mode)
(add-hook 'c-mode-common-hook '(lambda () (c-set-style "cc-mode")))


;;; ********************
;;; Edebug is a source-level debugger for emacs-lisp programs.
;;;
(define-key emacs-lisp-mode-map "\C-xx" 'edebug-defun)


;;; ********************
;;; func-menu is a package that scans your source file for function
;;; definitions and makes a menubar entry that lets you jump to any
;;; particular function definition by selecting it from the menu.  The
;;; following code turns this on for all of the recognized languages.
;;; Scanning the buffer takes some time, but not much.
;;;
;;; Send bug reports, enhancements etc to:
;;; David Hughes <ukchugd@ukpmr.cs.philips.nl>
;;;
(cond (running-xemacs
       (require 'func-menu)
       (define-key global-map 'f8 'function-menu)
       (add-hook 'find-file-hooks 'fume-add-menubar-entry)
       (define-key global-map "\C-cl" 'fume-list-functions)
       (define-key global-map "\C-cg" 'fume-prompt-function-goto)

       ;; The Hyperbole information manager package uses (shift button2) and
       ;; (shift button3) to provide context-sensitive mouse keys.  If you
       ;; use this next binding, it will conflict with Hyperbole's setup.
       ;; Choose another mouse key if you use Hyperbole.
       (define-key global-map '(shift button3) 'mouse-function-menu)

       ;; For descriptions of the following user-customizable variables,
       ;; type C-h v <variable>
       (setq fume-max-items 25
             fume-fn-window-position 3
             fume-auto-position-popup t
             fume-display-in-modeline-p t
             fume-menubar-menu-location "File"
             fume-buffer-name "*Function List*"
             fume-no-prompt-on-valid-default nil)
       ))


;;; ********************
;;; MH is a mail-reading system from the Rand Corporation that relies on a
;;; number of external filter programs (which do not come with emacs.)
;;; Emacs provides a nice front-end onto MH, called "mh-e".
;;;
;; Bindings that let you send or read mail using MH
;(global-set-key "\C-xm"  'mh-smail)
;(global-set-key "\C-x4m" 'mh-smail-other-window)
;(global-set-key "\C-cr"  'mh-rmail)

;; Customization of MH behavior.
(setq mh-delete-yanked-msg-window t)
(setq mh-yank-from-start-of-msg 'body)
(setq mh-summary-height 11)

;; Use lines like the following if your version of MH
;; is in a special place.
;(setq mh-progs "/usr/dist/pkgs/mh/bin.svr4/")
;(setq mh-lib "/usr/dist/pkgs/mh/lib.svr4/")


;;; ********************
;;; W3 is a browser for the World Wide Web, and takes advantage of the very
;;; latest redisplay features in XEmacs.  You can access it simply by typing 
;;; 'M-x w3'; however, if you're unlucky enough to be on a machine that is 
;;; behind a firewall, you will have to do something like this first:

;(setq w3-use-telnet t
;      ;;
;      ;; If the Telnet program you use to access the outside world is
;      ;; not called "telnet", specify its name like this.
;      w3-telnet-prog "itelnet"
;      ;;
;      ;; If your Telnet program adds lines of junk at the beginning
;      ;; of the session, specify the number of lines here.
;      w3-telnet-header-length 4
;      )


;(setq load-path (append load-path (list "~/emacs_site_lisp")))
;(setq load-path (append load-path (list "~/emacs_site_lisp/color-theme-6.6.0")))

;:(require 'color-theme)
;(color-theme-initialize)

;(require 'color-theme)
;(eval-after-load "color-theme"
;  '(progn
;     (color-theme-initialize)
;     (color-theme-charcoal-black)
;     (color-theme-hober)
;     ))


;; do not use tab
(setq-default indent-tabs-mode nil)



;; for P4
;(load-library "p4")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (tango-dark)))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(show-trailing-whitespace t)
 '(speedbar-default-position (quote left))
 '(speedbar-directory-button-trim-method (quote trim))
 '(speedbar-smart-directory-expand-flag nil)
 '(speedbar-verbosity-level 1)
 '(tab-stop-list (quote (4 8 12 16 20 24 28)))
 '(tab-width 4)
 '(tool-bar-mode nil))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 101 :width normal)))))



;;for ggtags
(add-hook 'prog-mode-hook
          '(lambda ()
             (evil-local-mode)
             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'rust-mode)
               (ggtags-mode 1))))

(global-set-key [f8]  'ggtags-prev-mark)
(global-set-key [f9] 'ggtags-next-mark)
;;(global-set-key [f9] 'gtags-pop-tag)
;;(global-set-key [f10] 'gtags-show-matching-tags)

;; for sr-speedbar
(require 'sr-speedbar)


;; for speedbar
;;(when window-system          ; start speedbar if we're using a window system
;;  (sr-speedbar t))

; (setq speedbar-mode-hook '(lambda ()
;    (interactive)
;    (other-frame 0)))


;; disable toolbar
(tool-bar-mode -1)
