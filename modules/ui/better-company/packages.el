;; -*- no-byte-compile: t; -*-
;;; ui/better-company/packages.el

;; Overwrite existing package! declaration of company-box so we can use our fork
(when (featurep! :completion company +childframe)
  (package! company-box :recipe (:host github :repo "tam5/company-box")))
