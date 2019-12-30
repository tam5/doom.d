;;; $DOOMDIR/+keybindings.el -*- lexical-binding: t; -*-

;; Place all keybinding overrides here

(defconst +tweaks/prefix ","
  "Define the extra prefix key.")

;; prefix based bindings
(map!
 :prefix +tweaks/prefix
 :n "ev" #'+default/browse-emacsd
 :n "ed" #'doom/open-private-config
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
 :v "s" #'+tweaks/sort-list
 :nv (concat +tweaks/prefix "j") #'json-pretty-print
 :n (concat +tweaks/prefix "b") #'eval-buffer
 :n (concat +tweaks/prefix "s") #'ivy-resume)

(map! :mode restclient-mode
      :prefix +tweaks/prefix
      :n "r" #'restclient-http-send-current)

;; non prefix based bindings
(map!
 :i "M-`" #'+tweaks/insert-backtic
 :n "-" #'dired-jump
 :n "C-p" #'+ivy/projectile-find-file
 :n "gr" #'lsp-find-references
 :ni "C-j" #'emmet-expand-yas
 :nvi "C-a" #'evil-numbers/inc-at-pt
 :nvi "C-A" #'evil-numbers/inc-at-pt
 :nv "M-<down>" #'evil-mc-make-cursor-move-next-line
 :nv "M-<up>" #'evil-mc-make-cursor-move-prev-line
 :nv "s-r" #'imenu
 :nvi "S-s-<return>" #'doom/window-maximize-buffer)

;; markdown mode bindings
(after! markdown-mode
  (map! :map markdown-mode-map
        :nvi "s-b" #'markdown-insert-bold
        :nvi "s-i" #'markdown-insert-italic
        :i "M-`" #'+tweaks/insert-backtic))

;; TODO move these somewhere else
(defun +tweaks/insert-backtic ()
  "Fix for my backtick hotkey to iTerm."
  (interactive)
  (insert "`"))

(defun +tweaks/sort-list ()
  (interactive)
  (if (< 1 (count-lines (region-beginning) (region-end)))
      (call-interactively 'sort-lines)
  (sort-regexp-fields nil "[a-z]+" "\\&" (region-beginning) (region-end))))
