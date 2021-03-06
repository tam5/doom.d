;;; $DOOMDIR/+ui.el -*- lexical-binding: t; -*-
;;;
;;; /----------------------------------------------------------------------------------
;;; | User Interface
;;; |----------------------------------------------------------------------------------
;;; |
;;; | Here is where we organize all configuration that is directly related to the ui
;;; | of the editor. The look and feel of the editor is of the utmost importance,
;;; | so we dedicate an entire section just for making the editor look pretty.
;;; /

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test

(setq doom-font (font-spec :family "Operator Mono 1.2" :size 15)
      doom-variable-pitch-font (font-spec :family "Roboto 1.2" :size 11))

;; let's keep the window nice and minimal
(toggle-scroll-bar -1)
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(setq ns-use-thin-smoothing t
      ns-use-proxy-icon nil
      frame-title-format nil)

(setq-default right-fringe-width 20)

(defface +ui/dashboard-face
  `((t (:family "Operator Mono")))
  "Face to use for the dashboard."
  :group 'faces)

;; set a different font for the dashboard
(add-hook '+doom-dashboard-mode-hook #'+utils/set-dashboard-font)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-seti)
(setq doom-themes-treemacs-theme "doom-colors")

(defun +ui/apply-theme-overrides ()
  "Add any theme overrides after the theme is loaded."
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic))

(add-hook 'doom-load-theme-hook #'+ui/apply-theme-overrides)

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

;; don't collapse treemacs directories with only one node
(after! treemacs
  (setq treemacs-collapse-dirs 0))

(defun +ui/snap-frame-to-view ()
  "Auto set the frame size to 'fullscreen' but with
some uniform gutters to add some breathing room."
  (interactive)
  (let* ((attrs (frame-monitor-workarea))
         (x (+ (pop attrs) 50))
         (y (+ (pop attrs) 60))
         (width (- (pop attrs) 120))
         (height (- (pop attrs) 120)))
    (set-frame-size (selected-frame) width height t)
    (set-frame-position (selected-frame) x y)))

(add-hook 'window-setup-hook #'+ui/snap-frame-to-view)

(defun +ui/company-childrame-ui-hack (orig-fun &rest args)
  "Set some frame parameters AFTER the frame has already been created.
This for whatever reason currently gives us the UI effect we want."
  (let ((frame (apply orig-fun args)))
    (set-frame-parameter frame 'undecorated t)
    (set-frame-parameter frame 'ns-appearance 'light)
    frame))

(when (featurep! :completion company +childframe)
  (advice-add 'company-box--make-frame :around #'+ui/company-childrame-ui-hack))

(defun +ui/highlight-indent-guides--bitmap-dots (width height crep zrep)
  "Defines a dotted guide line, with 2x2 pixel dots, and 3 or 4 dots per row.
Use WIDTH, HEIGHT, CREP, and ZREP as described in
`highlight-indent-guides-bitmap-function'."
  (let* ((left (/ (- width 2) 2))
         (right (- width left 2))
         (space3 (/ height 6))
         (space31 (/ (- space3 2) 2))
         (space4 (/ height 6))
         (space41 (/ (- space4 2) 2))
         (row1 (append (make-list left zrep) (make-list 2 crep) (make-list right zrep)))
         (row2 (make-list (- width 0) zrep))
         space space1 rows)
    (if (< (abs (- space4 space41 space41)) (abs (- space3 space31 space31)))
        (setq space space4 space1 space41)
      (setq space space3 space1 space31))
    (dotimes (i (+ height 2) rows)
      (if (let ((x (mod (- i space1) space))) (or (eq x 0) (eq x 1)))
          (setq rows (cons row1 rows))
        (setq rows (cons row2 rows))))))

(use-package! highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'bitmap
        highlight-indent-guides-responsive 'top
        highlight-indent-guides-bitmap-function '+ui/highlight-indent-guides--bitmap-dots
        highlight-indent-guides-auto-character-face-perc 7
        highlight-indent-guides-auto-top-character-face-perc 10))

;; make flycheck indicators a bit more appealing
(define-fringe-bitmap '+ui/flycheck-fringe-indicator
  (vector #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00011100
          #b00111110
          #b00111110
          #b00111110
          #b00011100
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000))

  (flycheck-define-error-level 'error
    :severity 100
    :compilation-level 2
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap '+ui/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-error
    :error-list-face 'flycheck-error-list-error)
  (flycheck-define-error-level 'warning
    :severity 10
    :compilation-level 1
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap '+ui/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-warning
    :error-list-face 'flycheck-error-list-warning)
  (flycheck-define-error-level 'info
    :severity -10
    :compilation-level 0
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap '+ui/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-info
    :error-list-face 'flycheck-error-list-info)

;; (custom-set-faces!
;;  '((outline-1 outline-2 outline-3 outline-4 outline-5 outline-6)
;;    :weight normal)
;;  '((default region)
;;    :background "red" :weight bold))

;; (custom-set-faces!
;;  `(outline-1 :foreground ,(doom-color 'red))
;;  `(outline-2 :background ,(doom-color 'blue)))

(custom-set-faces!
  `((doom-modeline-project-root-dir doom-modeline-project-dir doom-modeline-buffer-path doom-modeline-buffer-file doom-modeline-buffer-modified doom-modeline-info)
    :foreground ,(doom-color 'fg-alt) :weight normal)
   '((mode-line mode-line-inactive)
     :family "Roboto" :height 125 :weight normal)

   `(treemacs-file-face :foreground ,(doom-color 'fg-alt))
   `(treemacs-directory-face :foreground ,(doom-color 'fg-alt))
   `(treemacs-root-face :foreground ,(doom-color 'fg-alt))

   '(all-the-icons-red :foreground "#B42839")
   '(all-the-icons-lred :foreground "#E54542")
   '(all-the-icons-dred :foreground "#CB3837")
   '(all-the-icons-red-alt :foreground "#671855")
   '(all-the-icons-green :foreground "#ffffff")
   '(all-the-icons-lgreen :foreground "#43D16B")
   '(all-the-icons-dgreen :foreground "#ffffff")
   '(all-the-icons-yellow :foreground "#F0DC3E")
   '(all-the-icons-lyellow :foreground "#EED982")
   '(all-the-icons-dyellow :foreground "#FAA91A")
   '(all-the-icons-blue :foreground "#356EA0")
   '(all-the-icons-blue-alt :foreground "#283249")
   '(all-the-icons-lblue :foreground "#29A8DE")
   '(all-the-icons-dblue :foreground "#1F77CE")
   '(all-the-icons-maroon :foreground "#ffffff")
   '(all-the-icons-lmaroon :foreground "#ffffff")
   '(all-the-icons-dmaroon :foreground "#6C5FA9")
   '(all-the-icons-purple :foreground "#4A37BA")
   '(all-the-icons-purple-alt :foreground "#7F50B1")
   '(all-the-icons-lpurple :foreground "#8C6184")
   '(all-the-icons-dpurple :foreground "#542D8D")
   '(all-the-icons-orange :foreground "#EF7A39")
   '(all-the-icons-lorange :foreground "#F0582B")
   '(all-the-icons-dorange :foreground "#F0582B")
   '(all-the-icons-cyan :foreground "#00E4FF")
   '(all-the-icons-cyan-alt :foreground "#35BAA0")
   '(all-the-icons-lcyan :foreground "#829EC2")
   '(all-the-icons-dcyan :foreground "#ffffff")
   '(all-the-icons-pink :foreground "#FF4893")
   '(all-the-icons-lpink :foreground "#BCA784")
   '(all-the-icons-dpink :foreground "#ffffff")
   '(all-the-icons-silver :foreground "#40535B")
   '(all-the-icons-lsilver :foreground "#ffffff")
   '(all-the-icons-dsilver :foreground "#40535B"))
