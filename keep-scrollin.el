;;; -*- lexical-binding: t; -*-

(autoload 'View-scroll-half-page-forward "view")
(autoload 'View-scroll-half-page-backward "view")
(global-set-key (kbd "C-v") 'View-scroll-half-page-forward)
(global-set-key (kbd "M-v") 'View-scroll-half-page-backward)

(global-set-key (kbd "C-M-v")
  'my-View-scroll-half-page-forward-other-window)
(global-set-key (kbd "C-M-S-v")
  'my-View-scroll-half-page-backward-other-window)

(defun my-View-scroll-half-page-forward-other-window ()
  (interactive)
  (with-selected-window (next-window)
    (call-interactively 'View-scroll-half-page-forward)))

(defun my-View-scroll-half-page-backward-other-window ()
  (interactive)
  (with-selected-window (next-window)
    (call-interactively 'View-scroll-half-page-backward)))

(setq scroll-preserve-screen-position 'always)

(advice-add #'View-scroll-half-page-forward :around
            #'my-indicate-scroll-forward)

(advice-add #'View-scroll-half-page-backward :around
            #'my-indicate-scroll-backward)

(defun my-indicate-scroll-get-line (pos)
  (save-excursion
    (goto-char pos)
    (string-to-number (format-mode-line "%l"))))

(defun my-indicate-scroll (linep f args)
  (let ((linen (my-indicate-scroll-get-line linep))
        (pulse-delay 0.1))
    (save-excursion
      (goto-line linen)
      (pulse-momentary-highlight-one-line (point) 'highlight))
    (sit-for 0.1)
    (apply f args)))

(defun my-indicate-scroll-forward (f &rest args)
  (my-indicate-scroll (1- (window-end)) f args))

(defun my-indicate-scroll-backward (f &rest args)
  (my-indicate-scroll (window-start) f args))


(defun my-indicate-scroll (linep f args)
  (let ((linen (my-indicate-scroll-get-line linep))
        (pulse-delay 0.1))
    (set-transient-map
     `(keymap (?v . ,real-this-command)))
    (save-excursion
      (goto-line linen)
      (pulse-momentary-highlight-one-line (point) 'highlight))
    (sit-for 0.1)
    (apply f args)))
