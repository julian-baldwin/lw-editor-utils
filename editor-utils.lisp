(defpackage #:lw-editor-utils
  (:add-use-defaults t)
  (:use #:editor)
  (:export #:bind-default-keys))

(in-package #:lw-editor-utils)

(declaim (optimize (speed 3)))

(defun bind-default-keys ()
  "Set up default key bindings for LW-EDITOR-UTILS functions."
  (bind-key "Beginning of Form" "Meta-Ctrl-a")
  (bind-key "End of Form" "Meta-Ctrl-e")
  (bind-key "Backward Down List" "Meta-Ctrl-J")
  (bind-key "Splice Form" "Meta-Ctrl-=")
  (bind-key "Join Forms" "Meta-Ctrl--")
  (bind-key "Slurp Forward" "Meta-Ctrl-]")
  (bind-key "Barf Forward" "Meta-Ctrl-}")
  (bind-key "Slurp Backward" "Meta-Ctrl-[")
  (bind-key "Barf Backward" "Meta-Ctrl-{"))

(defcommand "Beginning of Form" (p)
     "Move point to the beginning of the current form."
     "Move point to the beginning of the current form."
  (declare (ignore p))
  (backward-up-list-command 1)
  (down-list-command 1))

(defcommand "End of Form" (p)
     "Move point to the end of the current form."
     "Move point to the end of the current form."
  (declare (ignore p))
  (forward-up-list-command 1)
  (backward-character-command 1))

(defcommand "Backward Down List" (p)
     "Move point to the end of the previous deeper list."
     "Move point to the end of the previous deeper list."
  (declare (ignore p))
  (backward-list-command 1)
  (down-list-command 1)
  (end-of-form-command 1))

(defcommand "Splice Form" (p)
     "Splice the current form into the parent by removing its delimiters."
     "Splice the current form into the parent by removing its delimiters."
  (declare (ignore p))
  (save-excursion
    (backward-up-list-command 1)
    (save-excursion
      (forward-list-command 1)
      (delete-previous-character-command 1))
    (delete-next-character-command 1)
    (beginning-of-defun-command nil)
    (indent-command nil)))

(defcommand "Join Forms" (p)
     "Join two adjacent forms together."
     "Join two adjacent forms together."
  (declare (ignore p))
  (save-excursion
    (backward-list-command 1)
    (forward-list-command 1)
    (delete-previous-character-command 1)
    (forward-list-command 1)
    (backward-list-command 1)
    (delete-next-character-command 1)
    (beginning-of-defun-command nil)
    (indent-command nil)))

(defcommand "Slurp Forward" (p)
     "Extend the current form to include the next P forms."
     "Extend the current form to include the next P forms."
  (let ((p (or p 1)))
    (save-excursion
      (forward-up-list-command 1)
      (let ((close (character-at (current-point) -1)))
        (delete-previous-character-command 1)
        (ignore-errors (forward-form-command p))
        (insert-character (current-point) close))
      (beginning-of-defun-command nil) ;
      (indent-command nil))))

(defcommand "Slurp Backward" (p)
     "Extend the current form backwards to include the previous P forms."
     "Extend the current form backwards to include the previous P forms."
  (let ((p (or p 1)))
    (save-excursion
      (backward-up-list-command 1)
      (let ((open (character-at (editor:current-point) 0)))
        (delete-next-character-command 1)
        (ignore-errors (backward-form-command p))
        (insert-character (current-point) open))
      (beginning-of-defun-command nil)
      (indent-command nil))))

(defcommand "Barf Forward" (p)
     "Retract the end of the current form to exclude the last P forms."
     "Retract the end of the current form to exclude the last P forms."
  (let ((p (or p 1)))
    (save-excursion
      (forward-up-list-command 1)
      (let ((close (character-at (current-point) -1)))
        (delete-previous-character-command 1)
        (ignore-errors
          ;; 1+ then forward one to ensure point is end of a form
          (backward-form-command (1+ p))
          (forward-form-command 1))
        (insert-character (current-point) close))
      (beginning-of-defun-command nil)
      (indent-command nil))))

(defcommand "Barf Backward" (p)
     "Retract the start of the current form to exclude the first P forms."
     "Retract the start of the current form to exclude the first P forms."
  (let ((p (or p 1)))
    (save-excursion
      (beginning-of-form-command nil)
      (let ((open (character-at (current-point) -1)))
        (delete-previous-character-command 1)
        (ignore-errors
          (forward-form-command (1+ p))
          (backward-form-command 1))
        (insert-character (current-point) open))
      (beginning-of-defun-command nil)
      (indent-command nil))))
