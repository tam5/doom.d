;;; $DOOMDIR/+behavior.el -*- lexical-binding: t; -*-
;;;
;;; /-----------------------------------------------------------------------------------------
;;; | Behavior
;;; |-----------------------------------------------------------------------------------------
;;; |
;;; | This file is used to tweak some of the behavior of the features we have enabled. I'm
;;; | not really sure what else to say about this file but maybe when we put more stuff
;;; | here I'll think of something more interesting to put here. Who knows..........
;;; /

(after! company-mode
  ;; make company show up faster
  (setq company-idle-delay 0
        company-minimum-prefix-length 0))
