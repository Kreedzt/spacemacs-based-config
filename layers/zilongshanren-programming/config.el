;;; config.el --- zilongshanren Layer packages File for Spacemacs
;;
;; Copyright (c) 2015-2016 zilongshanren
;;
;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(spacemacs|add-toggle iimage
  :status iimage-mode
  :on (iimage-mode)
  :off (iimage-mode -1)
  :documentation "Enable iimage mode"
  :evil-leader "oti")

"设置gtags"
;; (setq company-backends '((company-dabbrev-code company-gtags)))

(add-hook 'term-mode-hook 'zilongshanren/ash-term-hooks)

(add-to-list 'exec-path "/usr/bin/sqlite3")
"org-roam 设置"
(setq org-roam-directory "~/org-roam")
(setq org-roam-server-host "127.0.0.1"
      org-roam-server-port 9070
      org-roam-server-authenticate nil
      org-roam-server-export-inline-images t
      ;; org-roam-server-serve-files nil
      ;; org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
      ;; org-roam-server-network-poll t
      ;; org-roam-server-network-arrows nil
      org-roam-server-network-label-truncate t
      org-roam-server-network-label-truncate-length 60
      org-roam-server-network-label-wrap-length 20)

;; (add-hook 'c-mode-hook 'company-mode-hook)
;; (add-hook 'cc-mode 'company-mode-hook)
;; (add-hook 'c++-mode 'company-mode-hook)
;; (global-company-mode)

;; (require 'company-box)
;; (add-hook 'company-mode-hook 'company-box-mode)

"解决fontlock耗时问题"
"@see: https://www.emacswiki.org/emacs/FontLockSpeed"
;; (setq font-lock-support-mode 'jit-lock-mode)
;; (setq jit-lock-stealth-time 16
;;       jit-lock-defer-contextually t
;;       jit-lock-stealth-nice 0.5)
;; (setq-default font-lock-multiline t)

"解决LSP报错问题"
"@see: https://emacs-china.org/t/tide-javascript/7068/24"
;; (setq lsp--silent-errors
;;       '(
;;         -32800                          ;default error in lsp-mode
;;         -32603                          ;error that type in {...}
;;         ))

;; reformat your json file, it requires python
(defun beautify-json ()
  (interactive)
  (let ((b (if mark-active (min (point) (mark)) (point-min)))
        (e (if mark-active (max (point) (mark)) (point-max))))
    (shell-command-on-region b e
                             "python -mjson.tool" (current-buffer) t)))



(add-to-list 'auto-mode-alist (cons (concat "\\." (regexp-opt
                                                   '("xml"
                                                     "xsd"
                                                     "rng"
                                                     "xslt"
                                                     "xsl")
                                                   t) "\\'") 'nxml-mode))
(setq nxml-slash-auto-complete-flag t)



(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . c++-mode))
;; (add-hook 'c++-mode-hook (lambda () (company-mode 1)))



;; return nil to write content to file
(defun zilongshanren/untabify-buffer ()
  (interactive)
  (save-excursion
    (untabify (point-min) (point-max)) nil))

;; (add-hook 'c++-mode-hook
;;           #'(lambda ()
;;               (add-hook 'write-contents-hooks
;;                         'zilongshanren/untabify-buffer nil t)))

(setq auto-mode-alist
      (append
       '(("\\.mak\\'" . makefile-bsdmake-mode))
       auto-mode-alist))


(defmacro zilongshanren|toggle-company-backends (backend)
  "Push or delete the backend to company-backends"
  (let ((funsymbol (intern (format "zilong/company-toggle-%S" backend))))
    `(defun ,funsymbol ()
       (interactive)
       (if (eq (car company-backends) ',backend)
           (setq-local company-backends (delete ',backend company-backends))
         (push ',backend company-backends)))))
