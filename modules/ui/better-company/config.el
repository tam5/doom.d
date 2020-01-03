;;; ui/better-company/config.el -*- lexical-binding: t; -*-

(defun add-ui-frame-hack (orig-fun &rest args)
  "Set some frame parameters AFTER the frame has already been created.
This for whatever reason currently gives us the UI effect we want."
  (let ((frame (apply orig-fun args)))
    (set-frame-parameter frame 'undecorated t)
    (set-frame-parameter frame 'ns-appearance 'light)
    frame))

(defun luc-prepend-space-to-icon (orig-fun &rest args)
  "Add a space after the icon so it looks a little prettier."
  (let ((orig-val (apply orig-fun args)))
    (format "%s " orig-val)))

(defun luc-remove-company-box-scrollbar (orig-fun &rest args)
  "Remove the company box scrollbar.")

(when (featurep! :completion company +childframe)
  (advice-add 'company-box--add-icon :around #'luc-prepend-space-to-icon)
  (advice-add 'company-box--update-scrollbar :around #'luc-remove-company-box-scrollbar)
  (advice-add 'company-box--make-frame :around #'add-ui-frame-hack))
