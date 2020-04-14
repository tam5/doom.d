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
; (setq doom-font (font-spec :family "Operator Mono 1.3" :size 14)
;       doom-variable-pitch-font (font-spec :family "Operator Mono"))

(setq doom-font (font-spec :family "Menlo" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "sans" :size 16))

(defface +ui/dashboard-face
  `((t (:family "Menlo")))
  "Face to use for the dashboard."
  :group 'faces)

;; set a different font for the dashboard
(add-hook '+doom-dashboard-mode-hook #'+utils/set-dashboard-font)

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-moonlight)

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

;; don't collapse treemacs directories with only one node
(after! treemacs
  (setq treemacs-collapse-dirs 0))

(after! highlight-indent-guides
  (setq highlight-indent-guides-character ?\┊))


;; let's keep the window nice and minimal
(setq default-frame-alist '((undecorated . t)))
(add-to-list 'default-frame-alist '(drag-internal-border . 1))
(add-to-list 'default-frame-alist '(internal-border-width . 1))
(toggle-scroll-bar -1)

(defvar +ui/frame-gutter-factor 20)

;; auto set the frame size to 'fullscreen' but with
;; some uniform gutters to add some breathing room
(setq frame-resize-pixelwise t)

(set-frame-size
 (selected-frame)
 (- (display-pixel-width) (* 3 +ui/frame-gutter-factor))
 (- (display-pixel-height) (* 6 +ui/frame-gutter-factor))
 t)

(defun +ui/reposition ()
  "Reposition the frame to be centered on the screen."
  (set-frame-position (selected-frame) +ui/frame-gutter-factor (* 2 +ui/frame-gutter-factor)))

(add-hook 'window-setup-hook #'+ui/reposition)
