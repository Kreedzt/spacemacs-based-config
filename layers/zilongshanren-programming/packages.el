;;; packages.el --- zilongshanren Layer packages File for Spacemacs
;;
;; Copyright (c) 2014-2016 zilongshanren
;;
;; Author: zilongshanren <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.

(setq zilongshanren-programming-packages
      '(
        css-mode
        ;; paredit
        ;; lispy
        caps-lock
        ;; cmake-font-lock
        ;; cmake-mode
        ;; flycheck
        (nodejs-repl-eval :location local)
        (compile-dwim :location local)
        js2-mode
        js2-refactor
        json-mode
        ;; racket-mode
        web-mode
        js-doc
        ;; (cc-mode :location built-in)
        ;; flycheck-clojure
        ;; etags-select
        ;; (python :location built-in)
        ;; (emacs-lisp :location built-in)
        ;; clojure-mode
        company
        ;; company-box
        (eldoc :location built-in)
        graphviz-dot-mode
        ;; cider
        ;; editorconfig
        ;; robe
        ;; exec-path-from-shell
        lsp-mode
        typescript-mode
        org-roam
        ))

(defun zilongshanren-programming/post-init-typescript-mode ()
  ;; (add-hook 'typescript-mode-hook 'my-ts-mode-hook)
  (company-mode '((company-dabbrev-mode :width company-keywords) company-files company-dabbrev))
  )

(defun zilongshanren-programming/post-init-org-roam ()
  (add-hook 'after-init-hook 'org-roam-mode)
  )

(defun zilongshanren-programming/post-init-lsp-mode ()
  (progn
    (defun zilongshanren-refresh-imenu-index ()
      (when (or (eq major-mode 'js2-mode)
                (eq major-mode 'typescript-mode)
                (eq major-mode 'typescript-tsx-mode))
        (progn
          (setq imenu-create-index-function 'js2-imenu-make-index)


          (when (memq 'company-lsp company-backends)
            (setq-local company-backends (remove 'company-lsp company-backends))
            (add-to-list 'company-backends '(company-lsp :with company-dabbrev-code :separate))))))

    ;; (add-hook 'lsp-after-open-hook 'zilongshanren-refresh-imenu-index)

    (setq lsp-eldoc-render-all nil)
    (setq lsp-ui-doc-enable nil)


    (setq lsp-auto-configure t)
    ;; 禁用lsp缩进冲突问题
    (custom-set-variables '(lsp-enable-indentation nil))
    (setq lsp-prefer-flymake nil)
    ;; 提升lsp性能
    (setq company-lsp-cache-candidates t)
    ;; 启动emacs原生json转换器: v27有效
    ;; (setq lsp-use-native-json t)
    ;; 设置 Rust 后端为 RA (低配电脑慎用)
    ;; (setq lsp-rust-server 'rust-analyzer)
    (setq lsp-rust-server 'rls)
    ))

(defun zilongshanren-programming/init-compile-dwim ()
  (use-package compile-dwim
    :commands (compile-dwim-run compile-dwim-compile)
    :init))

;; (defun zilongshanren-programming/init-exec-path-from-shell ()
;;   (use-package exec-path-from-shell
;;     :init
;;     (when (memq window-system '(mac ns))
;;       (exec-path-from-shell-initialize))))

(defun zilongshanren-programming/init-caps-lock ()
  (use-package caps-lock
    :init
    (progn
      (bind-key* "s-e" 'caps-lock-mode))))

(defun zilongshanren-programming/init-editorconfig ()
  (use-package editorconfig
    :init
    (progn
      (defun conditional-enable-editorconfig ()
        (if (and (zilongshanren/git-project-root)
                 (locate-dominating-file default-directory ".editorconfig"))
            (editorconfig-apply)))
      (add-hook 'prog-mode-hook 'conditional-enable-editorconfig))))

(defun zilongshanren-programming/post-init-cider ()
  (setq cider-cljs-lein-repl
        "(do (require 'figwheel-sidecar.repl-api)
           (figwheel-sidecar.repl-api/start-figwheel!)
           (figwheel-sidecar.repl-api/cljs-repl))")

  (defun zilongshanren/cider-figwheel-repl ()
    (interactive)
    (save-some-buffers)
    (with-current-buffer (cider-current-repl-buffer)
      (goto-char (point-max))
      (insert "(require 'figwheel-sidecar.repl-api)
             (figwheel-sidecar.repl-api/start-figwheel!) ; idempotent
             (figwheel-sidecar.repl-api/cljs-repl)")
      (cider-repl-return)))

  (global-set-key (kbd "C-c C-f") #'zilongshanren/cider-figwheel-repl))

(defun zilongshanren-programming/post-init-graphviz-dot-mode ()
  (with-eval-after-load 'graphviz-dot-mode
      (require 'company-keywords)
      (push '(graphviz-dot-mode  "digraph" "node" "shape" "subgraph" "label" "edge" "bgcolor" "style" "record") company-keywords-alist)))

(defun zilongshanren-programming/post-init-clojure-mode ()
  )

(defun zilongshanren-programming/post-init-emacs-lisp ()
    (remove-hook 'emacs-lisp-mode-hook 'auto-compile-mode))

(defun zilongshanren-programming/post-init-python ()
  (add-hook 'python-mode-hook #'(lambda () (modify-syntax-entry ?_ "w")))
  ;; if you use pyton3, then you could comment the following line
  (setq python-shell-interpreter "python"))

(defun zilongshanren-programming/post-init-js-doc ()
  (setq js-doc-mail-address "zhaozisong1@live.com@gmail.com"
        js-doc-author (format "Kreedzt <%s>" js-doc-mail-address)
        js-doc-url "https://github.com/Kreedzt"
        js-doc-license "MIT")

  )


;; (defun zilongshanren-programming/init-ctags-update ()
;;   (use-package ctags-update
;;     :init
;;     :defer t
;;     :config
;;     (spacemacs|hide-lighter ctags-auto-update-mode)))

;; nodejs-repl is much better now.
;; (defun zilongshanren-programming/init-js-comint ()
;;   (use-package js-comint
;;     :init
;;     (progn
;;       ;; http://stackoverflow.com/questions/13862471/using-node-js-with-js-comint-in-emacs
;;       (setq inferior-js-mode-hook
;;             (lambda ()
;;               ;; We like nice colors
;;               (ansi-color-for-comint-mode-on)
;;               ;; Deal with some prompt nonsense
;;               (add-to-list
;;                'comint-preoutput-filter-functions
;;                (lambda (output)
;;                  (replace-regexp-in-string "\033\\[[0-9]+[GKJ]" "" output)))))
;;       (setq inferior-js-program-command "node"))))

(defun zilongshanren-programming/post-init-web-mode ()
  (with-eval-after-load "web-mode"
    (web-mode-toggle-current-element-highlight)
    (web-mode-dom-errors-show))
  (setq company-backends-web-mode '((company-dabbrev-code
                                     company-keywords
                                     )
                                    company-files company-dabbrev)))


(defun zilongshanren-programming/post-init-json-mode ()
  (add-to-list 'auto-mode-alist '("\\.tern-project\\'" . json-mode))
  (add-to-list 'auto-mode-alist '("\\.fire\\'" . json-mode))
  (add-to-list 'auto-mode-alist '("\\.fire.meta\\'" . json-mode))
  ;; (spacemacs/set-leader-keys-for-major-mode 'json-mode
  ;;   "ti" 'my-toggle-web-indent)
  )



;; (defun zilongshanren-programming/init-flycheck-package ()
;;   (use-package flycheck-package))

;; (defun zilongshanren-programming/post-init-flycheck ()
;;   (with-eval-after-load 'flycheck
;;     (progn
;;       (setq flycheck-display-errors-delay 0.9)
;;       (setq flycheck-idle-change-delay 2.0)
;;       )))

(defun zilongshanren-programming/post-init-eldoc ()
  (setq eldoc-idle-delay 0.4))


(defun zilongshanren-programming/post-init-js2-refactor ()
  (progn
    
    (defun js2r-toggle-object-property-access-style ()
      "Toggle js object property access style."
      (interactive)
      (js2r--guard)
      (js2r--wait-for-parse
       (save-excursion
         (let ((node (js2-node-at-point)))
           (if (js2-string-node-p node)
               (let* ((start (js2-node-abs-pos node))
                      (end (+ start (js2-node-len node))))
                 (when (memq (char-before start) '(?\[))
                   (save-excursion
                     (goto-char (-  end 1)) (delete-char 2)
                     (goto-char (+ start 1)) (delete-char -2) (insert "."))))
             (let* ((start (js2-node-abs-pos node))
                    (end (+ start (js2-node-len node))))
               (when (memq (char-before start) '(?.))
                 (save-excursion
                   (goto-char end) (insert "\']")
                   (goto-char start) (delete-char -1) (insert "[\'")))))))))

    ;; (spacemacs/set-leader-keys-for-major-mode 'js2-mode
    ;;   "r>" 'js2r-forward-slurp
    ;;   "r<" 'js2r-forward-barf
    ;;   "r." 'js2r-toggle-object-property-access-style
    ;;   "rep" 'js2r-expand-call-args)
    )
  )

(defun zilongshanren-programming/post-init-js2-mode ()
  (progn
    ;; (add-hook 'js2-mode-hook 'my-setup-develop-environment)

    ;; (add-hook 'web-mode-hook 'my-setup-develop-environment)

    (spacemacs|define-jump-handlers js2-mode)
    ;; (add-hook 'spacemacs-jump-handlers-js2-mode 'etags-select-find-tag-at-point)

    (setq company-backends-js2-mode '((company-dabbrev-code :with company-keywords 
                                                            )
                                      company-files company-dabbrev))

    (setq company-backends-js-mode '((company-dabbrev-code :with company-keywords
                                                           )
                                     company-files company-dabbrev))

    ;; (add-hook 'js2-mode-hook 'my-js2-mode-hook)

    ;; add your own keywords highlight here
    (font-lock-add-keywords 'js2-mode
                            '(("\\<\\(cc\\)\\>" 1 font-lock-type-face)))

    ;; (spacemacs/declare-prefix-for-mode 'js2-mode "ms" "repl")

    (with-eval-after-load 'js2-mode
      (progn
        ;; these mode related variables must be in eval-after-load
        ;; https://github.com/magnars/.emacs.d/blob/master/settings/setup-js2-mode.el
        (setq-default js2-allow-rhino-new-expr-initializer nil)
        (setq-default js2-auto-indent-p nil)
        (setq-default js2-enter-indents-newline nil)
        (setq-default js2-global-externs '("module" "ccui" "require" "buster" "sinon" "assert" "refute" "setTimeout" "clearTimeout" "setInterval" "clearInterval" "location" "__dirname" "console" "JSON"))
        (setq-default js2-idle-timer-delay 0.2)
        (setq-default js2-mirror-mode nil)
        (setq-default js2-strict-inconsistent-return-warning nil)
        (setq-default js2-include-rhino-externs nil)
        (setq-default js2-include-gears-externs nil)
        (setq-default js2-concat-multiline-strings 'eol)
        (setq-default js2-rebind-eol-bol-keys nil)
        (setq-default js2-auto-indent-p t)

        (setq-default js2-bounce-indent nil)
        (setq-default js-indent-level 2)
        (setq-default js2-basic-offset 2)
        (setq-default js-switch-indent-offset 2)
        ;; Let flycheck handle parse errors
        (setq-default js2-mode-show-parse-errors nil)
        (setq-default js2-mode-show-strict-warnings nil)
        (setq-default js2-highlight-external-variables t)
        (setq-default js2-strict-trailing-comma-warning nil)

        (add-hook 'web-mode-hook 'my-web-mode-indent-setup)
        ))

    (evilified-state-evilify js2-error-buffer-mode js2-error-buffer-mode-map)

    ))

(defun zilongshanren-programming/post-init-css-mode ()
  (progn
    (dolist (hook '(css-mode-hook sass-mode-hook less-mode-hook))
      (add-hook hook 'rainbow-mode))

    (defun css-imenu-make-index ()
      (save-excursion
        (imenu--generic-function '((nil "^ *\\([^ ]+\\) *{ *$" 1)))))

    (add-hook 'css-mode-hook
              (lambda ()
                (setq imenu-create-index-function 'css-imenu-make-index)))))

(defun zilongshanren-programming/post-init-tagedit ()
  (add-hook 'web-mode-hook (lambda () (tagedit-mode 1))))

;; https://atlanis.net/blog/posts/nodejs-repl-eval.html
(defun zilongshanren-programming/init-nodejs-repl-eval ()
  (use-package nodejs-repl-eval
    :commands (nodejs-repl-eval-buffer nodejs-repl-eval-dwim nodejs-repl-eval-function)
    ;; :init
    ;; (progn
    ;;   (spacemacs/declare-prefix-for-mode 'js2-mode
    ;;                                      "ms" "REPL")
    ;;   (spacemacs/set-leader-keys-for-major-mode 'js2-mode
    ;;     "sb" 'nodejs-repl-eval-buffer
    ;;     "sf" 'nodejs-repl-eval-function
    ;;     "sd" 'nodejs-repl-eval-dwim)
    ;;   )
    :defer t
    ))

;; (defun zilongshanren-programming/init-flycheck-clojure ()
;;   (use-package flycheck-clojure
;;     :defer t
;;     :init
;;     (eval-after-load 'flycheck '(flycheck-clojure-setup))))

(defun zilongshanren-programming/post-init-company ()
  (progn
    (setq company-minimum-prefix-length 1
          company-idle-delay 0.08)

    (when (configuration-layer/package-usedp 'company)
      (spacemacs|add-company-backends :modes shell-script-mode makefile-bsdmake-mode sh-mode lua-mode nxml-mode conf-unix-mode json-mode graphviz-dot-mode js2-mode js-mode))
    ))

;; (defun zilongshanren-programming/post-init-company-c-headers ()
;;   (progn
;;     (setq company-c-headers-path-system
;;           (quote
;;            ("/Users/kreedzt/anaconda3/include/c++/v1")))))
