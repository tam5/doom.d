;;; $DOOMDIR/+utils.el -*- lexical-binding: t; -*-
;;;
;;; /---------------------------------------------------------------------------------------
;;; | Configuration Utilities
;;; |---------------------------------------------------------------------------------------
;;; |
;;; | This file contains additional utilities that can be used by the rest of the config.
;;; | The file should only contain definitions, but shouldn't actually impact anything
;;; | unless these functions are called or invoked somewhere else in the directory.
;;; /

(defun +utils/set-dashboard-font ()
  "Set the font for the doom dashboard."
  (setq buffer-face-mode-face '+ui/dashboard-face)
  (buffer-face-mode))

(defun +utils/insert-backtic ()
  "Insert a backtick character. Since I have backtick mapped as
a hotkey for iTerm, we sometimes need to programmitcally insert one."
  (interactive)
  (insert "`"))

(defun +utils/sort-list ()
  "Sort the list in the current region alphabetically. When a
a single line is selected, the words of the line will be sorted. When
multiple lines are selected, the lines will sort themselves instead."
  (interactive)
  (if (< 1 (count-lines (region-beginning) (region-end)))
      (call-interactively 'sort-lines)
  (sort-regexp-fields nil "[a-z]+" "\\&" (region-beginning) (region-end))))

(defun +utils/what-face (pos)
  "Get the faces of the current position. Used for debugging."
    (interactive "d")
        (let ((face (or (get-char-property (point) 'read-face-name)
            (get-char-property (point) 'face))))
    (if face (message "Face: %s" face) (message "No face at %d" pos))))
