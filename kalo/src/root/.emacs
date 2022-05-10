
;;; Kaloyan's emacs config
;; -*- mode: emacs-lisp -*-
;;
;; (load-file "<this_file>") ;to enamble
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar first-time t)


(setq auto-mode-alist (cons '("\\.zsh" . shell-script-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.h" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cpp" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.C" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.steer" . c++-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tex" . latex-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.cgi" . perl-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.fr" . text-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.js" . javascript-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.html" . html-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.tmpl" . html-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.php" . html-mode) auto-mode-alist))
(setq auto-save-default nil);disable auto save
(setq backup-inhibited t);disable backup
(setq c-default-style "k&r")
;(setq c-basic-offset 4)
(setq compile-command "make" compilation-ask-about-save nil)
(setq display-time-24hr-format t)
(setq display-time-day-and-date t)
(setq fill-column 79)
(setq font-lock-maximum-decoration t)
(setq font-lock-maximum-size nil)
(setq font-lock-support-mode 'jit-lock-mode)
(setq font-lock-face-attributes
      '((font-lock-comment-face          "red") ;;//
	(font-lock-string-face         "green") ;;"Hello"
	(font-lock-keyword-face         "cyan") ;;for,if,delete
	(font-lock-function-name-face   "blue") ;;Set(),Get()
	(font-lock-variable-name-face "yellow")	;;a,b,c
	(font-lock-type-face         "magenta") ;;int,Int_t,TH1F
	(font-lock-doc-string-face     "green") ;;??
	))
(setq inhibit-startup-message t)
(setq jit-lock-stealth-time 100)
(setq kill-whole-line t)
(setq line-move-visual nil)
(setq mail-archive-file-name "~/mail/sent")
(setq make-backup-files nil)
(setq mark-even-if-inactive t)
(setq max-lisp-eval-depth '4000000) ;; should work
(setq max-specpdl-size '10000000)   ;; better with tables ? i added one zero myself
(setq next-line-add-newlines nil)
(setq scroll-step 1)
(setq show-trailing-whitespace t)
(setq skeleton-pair t)
(setq skeleton-pair-on-word t)
(setq suggest-key-bindings nil)
(setq undo-outer-limit 100000000)
(setq visible-bell t)
(setq-default indent-tabs-mode nil) ;; tabs written as spaces
(setq font-lock-maximum-decoration 2);;font-lock-maximum-decoration' to 2


(defun good-colors ()
  (progn
    (set-foreground-color "snow")
    (set-background-color "black");???Ca fais rien
    (set-cursor-color "red")
    (set-border-color "cyan")
    (set-mouse-color "DarkSlateBlue")

    (set-face-foreground 'default "white");;fg
    (set-face-background 'default "black");;bg

    (set-face-foreground 'region "black");;mark fg
    (set-face-background 'region "white");;mark bg

;;    (set-face-foreground 'modeline "magenta");;bottom line fg
;;    (set-face-background 'modeline "black");;bottom line bg


    (set-face-foreground 'highlight "LightGray")  ;;; DimGray")
    (set-face-background 'highlight "DarkSlateBlue")
    (set-face-attribute 'default nil :height 88)

    ))

(good-colors)  ;; calls the previously-defined function


(column-number-mode 			1)
(display-time-mode 			1)
(display-battery-mode 			1)
(global-font-lock-mode 			1)
(line-number-mode 			1)
(menu-bar-mode 			       -1)
;; (tool-bar-mode                         -1)

(normal-erase-is-backspace-mode 	1)
(show-paren-mode			1)
(transient-mark-mode		        1)



					;(defconst user-mail-address "kaloyan.krastev@lpsc.in2p3.fr, kaloyan@mail.desy.de")
(fset 'yes-or-no-p 'y-or-n-p)
					;(put 'eval-expression 'disabled nil)
					;(put 'narrow-to-region 'disabled nil)
					;(put 'set-goal-column 'disabled nil)


(add-to-list 'load-path (expand-file-name "~/Myxa/mode/emacs"))
(add-to-list 'load-path (expand-file-name "~/Myxa/mode/emacs/php-mode/lisp"))



;;(require 'multi-term)
;;(setq multi-term-program "/bin/tcsh")


(require 'ispell)
(setq ispell-program-name "aspell")
;;(ispell-change-dictionary "french") ; morla dérangée
;;(setq ispell-change-dictionary "french")
;;(setenv "LANG" "fr_FR")
(setq ispell-personal-dictionary "~/Myxa/mode/latex/metathesis/ispell_personal")
(setq ispell-minor-mode t)

(require 'flyspell)
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t) ;;spell check


(autoload 'ispell-word "ispell"
  "Check the spelling of word in buffer." t)
(global-set-key "\e$" 'ispell-word)
(autoload 'ispell-region "ispell"
  "Check the spelling of region." t)
(autoload 'ispell-buffer "ispell"
  "Check the spelling of buffer." t)
(autoload 'ispell-complete-word "ispell"
  "Look up current word in dictionary and try to complete it." t)
(autoload 'ispell-change-dictionary "ispell"
  "Change ispell dictionary." t)
(autoload 'ispell-message "ispell"
  "Check spelling of mail message or news post.")
(autoload 'ispell-minor-mode "ispell"
  "Toggle mode to automatically spell check words as they are typed in.")




(require 'bs)

;;(load "~/Myxa/mode/emacs/php-mode/lisp/php-mode.el")
(load-file "~/Myxa/mode/emacs/csh-mode.el")
(load-file "~/Myxa/mode/emacs/csh-mode.el")

(add-to-list 'auto-mode-alist '("\\.[Cc][Ss][Vv]\\'" . csv-mode))
(autoload 'csv-mode "csv-mode"
  "Major mode for editing comma-separated value files." t)


(require 'ps-print)
(setq ps-font-size 5)
;(setq ps-number-of-columns 2)
;(setq ps-paper-type 'a4)
;(setq ps-landscape-mode nil)
;;(setq lpr-command "/usr/bin/a2ps")
(setq ps-print-header nil)
(setq ps-print-color-p nil)


;(require 'csh-mode)

(defun cshrc ()(interactive)(find-file "~/Myxa/mode/tcsh/.cshrc"))
(defun reload-file ()(interactive)(find-file (buffer-name)))
(defun login ()(interactive)(find-file "~/Myxa/mode/tcsh/.login"))
(defun ali ()(interactive)(find-file "~/Myxa/mode/tcsh/.aliases"))
(defun emacs ()(interactive)(find-file "~/Myxa/mode/emacs/kaloyan.el"))
(defun work ()(interactive)(find-file "~/Myxa/mode/ascii/work"))
(defun makefile ()(interactive)(find-file "~/Myxa/mode/Makefile/Makefile.k3"))
(defun insert-date-string ()(interactive)(insert (format-time-string "%Y-%m-%d")))
(defun alt-shell-dwim (arg)
  "Run an inferior shell like `shell'. If an inferior shell as its I/O
 through the current buffer, then pop the next buffer in `buffer-list'
 whose name is generated from the string \"*shell*\". When called with
 an argument, start a new inferior shell whose I/O will go to a buffer
 named after the string \"*shell*\" using `generate-new-buffer-name'."
  (interactive "P")
  (let* ((shell-buffer-list
	  (let (blist)
	    (dolist (buff (buffer-list) blist)
	      (when (string-match "^\\*shell\\*" (buffer-name buff))
		(setq blist (cons buff blist))))))
	 (name (if arg
		   (generate-new-buffer-name "*shell*")
		 (car shell-buffer-list))))
    (shell name)))

(defun print-to-pdf ()
  (interactive)
  (ps-spool-buffer-with-faces)
  (switch-to-buffer "*PostScript*")
  (write-file "/tmp/tmp.ps")
  (kill-buffer "tmp.ps")
  (setq cmd (concat "ps2pdf14 /tmp/tmp.ps " (buffer-name) ".pdf"))
  (shell-command cmd)
  (shell-command "rm /tmp/tmp.ps")
  (message (concat "Saved to:  " (buffer-name) ".pdf"))
  )


(defun indent-whole-buffer()
  "Indent whole buffer (using indent-region)."
  (interactive)
  (normal-mode)
  (save-excursion
    (mark-whole-buffer)
    (call-interactively 'indent-region)
    )
  (message "%s" "Indented whole global.")
  )


;; (global-set-key [f1] 'reload-file)
;; (global-set-key [f2] 'query-replace)
;; (global-set-key [f3] 'reload-file)
;; (global-set-key [f4] 'reload-file)
;; (global-set-key [f5] 'buffer-menu)

(global-set-key [f6] 'find-file)
(global-set-key [f7] 'alt-shell-dwim)
(global-set-key [f8] '(lambda () (interactive) (reload-file)))
(global-set-key [f9] 'bs-show)
(global-set-key [f10] '(lambda () (interactive) (load-file "~/Myxa/mode/emacs/kaloyan.el")))


(global-set-key "\M-j" '(lambda () (interactive) (load-file "~/Myxa/mode/emacs/kaloyan.el")))
(global-set-key "\M-m" 'bs-show)
(global-set-key "\M-c" 'comment-region)
(global-set-key "\M-d" 'insert-date-string)
(global-set-key "\M-i" 'ispell-word)
(global-set-key "\M-l" 'goto-line)
(global-set-key "\M-t" 'next-multiframe-window);;genial
(global-set-key "\M-o" 'print-to-pdf)
(global-set-key "\M-s" 'flyspell-buffer)
(global-set-key "\M-u" 'uncomment-region)

(global-set-key "\C-r" 'reload-file)
(global-set-key (kbd "C-c s") 'shell)
(global-set-key [C-tab] "\C-q\t")

(global-set-key "{" 'skeleton-pair-insert-maybe)
(global-set-key "(" 'skeleton-pair-insert-maybe)
(global-set-key "[" 'skeleton-pair-insert-maybe)

(keyboard-translate ?\C-? ?\C-h)	;backspace do what it
(global-set-key [?\C-h] 'delete-backward-char) ;should do

(global-set-key [up] 'backward-sentence)
(global-set-key [down] 'forward-sentence)
(global-set-key [left] 'backward-word)
(global-set-key [right] 'forward-word)

(global-set-key [M-up] 'backward-line)
(global-set-key [M-down] 'forward-line)
(global-set-key [M-right] 'forward-char)
(global-set-key [M-left] 'backward-char)

(global-set-key [C-up] 'backward-line)
(global-set-key [C-down] 'forward-line)
(global-set-key [C-right] 'forward-char)
(global-set-key [C-left] 'backward-char)

(global-set-key [home] 'beginning-of-buffer)
(global-set-key [end]  'end-of-buffer)
(global-set-key [prior] "\M-v")
(global-set-key [next] "\C-v")

(global-set-key [C-home] "\M-<")
(global-set-key [C-end] "\M->")
(global-set-key [C-prior] "\M-<")
(global-set-key [C-next] "\M->")

(global-set-key [insertchar] 'overwrite-mode)


;;(defun my-latex ()
;;  (auto-fill-mode)
;;  (setq tex-dvi-view-command "xdvi")
;;  (setq tex-print-command "dvips")
;;  (setq tex-dvi-print-command "dvips")
;;  )

(defun ff/flyspell-mode (arg) (interactive "p")
  (flyspell-mode)
  (when flyspell-mode (flyspell-buffer))
  )



(setq text-mode-hook
      '(lambda () "Défauts pour le mode text."
         (setq ispell-personal-dictionary "~/Myxa/mode/emacs/ispell.dic")
         (setenv "LANG" "fr_FR")
         (ispell-change-dictionary "francais")
         ))


(add-hook 'text-mode-hook 'table-recognize)
(add-hook 'text-mode-hook 'flyspell-mode)
;;(add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'tex-mode-hook 'flyspell-mode)
(add-hook 'tex-mode-hook 'turn-on-auto-fill)

(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-hook 'python-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)
            (setq tab-width 4)
            (setq python-indent-offset 4)))



(require 'desktop)

;; (if (> emacs-major-version 21)
;;     (progn
;;       (setq load-path (cons "~/Myxa/mode/emacs" load-path))
;;       (require 'root-help)
;;       )
;;   )

(if first-time
    (progn
      (server-start)
      (if (> emacs-major-version 21)
	  (desktop-save-mode 1)
	(progn
	  (desktop-load-default)
	  (desktop-read)
	  )
	)
      )
  )



(setq desktop-globals-to-save
      (append '((extended-command-history . 30)
                (file-name-history        . 100)
                (grep-history             . 30)
                (compile-history          . 30)
                (minibuffer-history       . 50)
                (query-replace-history    . 60)
                (read-expression-history  . 60)
                (regexp-history           . 60)
                (regexp-search-ring       . 20)
                (search-ring              . 20)
                (shell-command-history    . 50)
                tags-file-name
                register-alist)))

(setq first-time nil)
(setq debug-on-error nil)

(defun mp-display-message ()
  (message "kaloyan.el loaded, %s%s" (user-login-name) ".")
  (interactive)
  )

(mp-display-message)


(setenv "TERM" "emacs") ;????
					;(switch-to-buffer "*Messages*")
