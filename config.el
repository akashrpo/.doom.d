;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;
;; customize config
;;

(global-display-line-numbers-mode t)			;; toggle display-line-numbers mode in all buffers

;; autocomplete feature
(use-package auto-complete
:ensure t
:init
(progn
(ac-config-default)
(global-auto-complete-mode t)
))

;; enable mouse inside emacs
(xterm-mouse-mode 1)

;; use tab-to-tab-stop for using default tab functionality
(global-set-key (kbd "TAB") 'tab-to-tab-stop)		;; Insert spaces or tabs to next defined tab-stop column

(setq buffer-undo-list nil) ; discard undo history


;;
;; helm
;;
(require 'helm)

(global-set-key (kbd "C-M-f") 'helm-do-grep-ag)		;; search for a string in all the files from the given location/path


;;
;; F1
;; browse helm-buffers-list
(global-set-key (kbd "<f1>") nil)
(use-package helm
    :bind(
	 ("<f1>," . previous-buffer)			;; goto previous buffer
	 ("<f1>." . next-buffer)			;; goto next buffer
	 )
)


;;
;; F2
;; helm-rtags
(add-hook 'find-file-hook 'rtags-start-process-maybe)	;; autostart rdm service when emacs starts

(global-set-key (kbd "<f2>") nil)			;; unbind <f2>

;; ensure that we use only rtags checking
;; https://github.com/Andersbakken/rtags#optional-1
(defun setup-flycheck-rtags ()
  (interactive)
  (flycheck-select-checker 'rtags)
  ;; RTags creates more accurate overlays.
  (setq-local flycheck-highlighting-mode nil)
  (setq-local flycheck-check-syntax-automatically nil))

;; only run this if rtags is installed
(when (require 'rtags nil :noerror)
  ;; make sure you have company-mode installed
  (require 'company)
  (define-key c-mode-base-map (kbd "<f2>.")
    (function rtags-find-symbol-at-point))
  (define-key c-mode-base-map (kbd "<f2>,")
    (function rtags-location-stack-back))
  ;; disable prelude's use of C-c r, as this is the rtags keyboard prefix
  ;;(define-key prelude-mode-map (kbd "C-c r") nil)
  ;; install standard rtags keybindings. Do M-. on the symbol below to
  ;; jump to definition and see the keybindings.
  (rtags-enable-standard-keybindings)
  ;; comment this out if you don't have or don't use helm
  (setq rtags-use-helm t)
  ;; company completion setup
  (setq rtags-autostart-diagnostics t)
  (rtags-diagnostics)
  (setq rtags-completions-enabled t)
  (push 'company-rtags company-backends)
  (global-company-mode)
  (define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
  ;; use rtags flycheck mode -- clang warnings shown inline
  (require 'flycheck-rtags)
  ;; c-mode-common-hook is also called by c++-mode
  (add-hook 'c-mode-common-hook #'setup-flycheck-rtags))


;;
;; F4
;; helm-find-files, helm-buffers-list etc.
(global-set-key (kbd "<f4>") nil)
(use-package helm
    :bind(
	 ("<f4>f" . helm-for-files)				;; search for a file names in the entire given file location
	 ("<f4>b" . helm-buffers-list)			;; displays all the open buffers/files
	 )
)


;;
;; F5
;; helm-swoop
(helm-autoresize-mode t) 				;; autoresize the pane acc. to the swoop result
(global-set-key (kbd "<f5>") 'helm-swoop)		;; search for a word/string in the entire file


;;
;; F6
;; eshell
(defun eshell-vsplit ()
    (interactive)					;; this line is must; it declares that a function is a command
    (split-window-right)				;; open window in the right
    (other-window 1)					;; switch to other/right window
    (eshell)						;; open eshell
)

(use-package helm
    :bind(	
	 ("<f6><f6>" . eshell-vsplit)			;; open eshell or emacs shell/terminal
	 ("<f6>C"    . eshell-command)  		;; open eshell command prompt
	 ("<f6>c"    . compile) 			;; compile
	 ("<f6>e"    . compile-goto-error)		;; goto error
	 )
)


;;
;; F7
;; helm-semantic
(semantic-mode 1) 					;; turnon semantic mode for helm-semantic
(global-set-key (kbd "<f7>") 'helm-semantic)		;; displays all the semantics or headers and functions of a file


