;;; $DOOMDIR/+keybindings.el -*- lexical-binding: t; -*-
;;;
;;; /-----------------------------------------------------------------------------------------
;;; | Keybindings
;;; |-----------------------------------------------------------------------------------------
;;; |
;;; | The heart and sole of our editor is, of course, the keybindings. Doom itself provides
;;; | most of the keybindings, but we have some extra to add. Additionally, a few things
;;; | here are just habits that have stuck with me even if they don't make any sense.
;;; /

(defconst +keybindings/prefix ","
  "Define the prefix key. This is the equivalent of the <leader> key in vim.")

;;
;; Prefix based
;;
(map!
 :prefix +keybindings/prefix
 :n "ev" (lambda () (interactive) (find-file (file-truename "~/.doom.d/config.el")))
 :n "ek" (lambda () (interactive) (find-file (file-truename "~/.doom.d/+keybindings.el")))
 :n "1" #'+treemacs/toggle
 :n "2" #'+treemacs/find-file
 :n "j" #'counsel-projectile-switch-project
 :n "f" #'evil-avy-goto-word-0
 :n "v" #'evil-window-vsplit
 :n "h" #'evil-window-split
 :n "d" #'kill-this-buffer
 :n "w" #'save-buffer
 :n "q" #'evil-quit
 :n "s" #'+default/search-project
 :v "s" #'+utils/sort-list
 :nv (concat +keybindings/prefix "j") #'json-pretty-print
 :n (concat +keybindings/prefix "b") #'eval-buffer
 :n (concat +keybindings/prefix "s") #'ivy-resume)

;;
;; Non-Prefix based
;;
(map!
 :i "M-`" #'+utils/insert-backtic
 :n "/" #'swiper-isearch
 :n "-" #'dired-jump
 :n "C-p" #'+ivy/projectile-find-file
 :n "gr" #'lsp-find-references
 :ni "C-j" #'emmet-expand-yas
 :nvi "C-a" #'evil-numbers/inc-at-pt
 :nvi "C-s" #'evil-numbers/dec-at-pt
 :nv "M-<down>" #'evil-mc-make-cursor-move-next-line
 :nv "M-<up>" #'evil-mc-make-cursor-move-prev-line
 :nv "s-r" #'imenu
 :nvi "S-s-<return>" #'doom/window-maximize-buffer)

;;
;; Mode specific
;;
(after! restclient-mode
  (map! :mode restclient-mode
        :prefix +keybindings/prefix
        :n "r" #'restclient-http-send-current))

(after! markdown-mode
  (map! :map markdown-mode-map
        :nvi "s-b" #'markdown-insert-bold
        :nvi "s-i" #'markdown-insert-italic
        :i "M-`" #'+utils/insert-backtic))
