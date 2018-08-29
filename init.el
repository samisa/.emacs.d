;;; init.el

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-utils)
(require 'init-defaults)
(require 'init-package)

;; If loading of groovy mode fails for some reason, manual installation via package-list-packages may help.
(use-package groovy-mode)

(use-package misc
  :bind ("M-z" . zap-up-to-char))

(use-package ibuffer
  :bind ("C-x C-b" . ibuffer))

(use-package whitespace
  :diminish global-whitespace-mode
  :init (setq-default whitespace-style '(face tab-mark trailing))
  :config (global-whitespace-mode 1))

(use-package exec-path-from-shell
  :ensure t
  :if (memq window-system '(mac ns))
  :config (exec-path-from-shell-initialize))

(load-theme 'tsdh-dark t)
(add-to-list 'default-frame-alist '(font .  "DejaVu Sans Mono-9" ))
(set-face-attribute 'default t :font  "DejaVu Sans Mono-9" )

(use-package smart-mode-line
  :ensure t
  :if window-system
  :init (sml/setup))

(use-package ace-jump-mode
  :disabled t
  :ensure t
  :bind ("C-c <SPC>" . ace-jump-mode))

(use-package avy
  :ensure t
  :bind ("C-." . avy-goto-word-1)
  :config (setq avy-all-windows nil))

(use-package ace-window
  :ensure t
  :bind* ("M-o" . ace-window)
  :init (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; (use-package undo-tree
;;   :ensure t
;;   :diminish undo-tree-mode
;;   :config (global-undo-tree-mode))

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

;; (use-package multiple-cursors
;;   :ensure t
;;   :bind ("C-c m c" . mc/edit-lines)
;;   :init (setq mc/list-file (concat my-gen-dir "mc-lists.el")))

(use-package volatile-highlights
  :ensure t
  :diminish volatile-highlights-mode
  :config (volatile-highlights-mode t))

(use-package anzu
  :ensure t
  :diminish anzu-mode
  :config (global-anzu-mode +1))

(use-package company
  :ensure t
  :diminish company-mode
  :init
  (setq company-dabbrev-ignore-case t
        company-dabbrev-downcase nil)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package yasnippet
  :disabled t
  :ensure t
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package magit
  :ensure t
  :bind (("C-c g s" . magit-status)
         ("C-c g b" . magit-blame)
         ("C-c g d" . vc-diff)))

(use-package git-gutter-fringe
  :disabled t
  :ensure t
  :diminish git-gutter-mode
  :init (setq git-gutter-fr:side 'right-fringe)
  :config (global-git-gutter-mode t))

(use-package ag
  :ensure t)

;; (use-package helm
;;   :ensure t
;;   :diminish helm-mode
;;   :bind (("C-c i" . helm-imenu)
;;          ("M-y" . helm-show-kill-ring))
;;   :init
;;   (require 'helm-config)
;;   (helm-mode 1)

;;   ;; https://www.reddit.com/r/emacs/comments/345vtl/make_helm_window_at_the_bottom_without_using_any/
;;   (add-to-list 'display-buffer-alist
;;                `(,(rx bos "*helm" (* not-newline) "*" eos)
;;                  (display-buffer-in-side-window)
;;                  (inhibit-same-window . t)
;;                  (window-height . 0.4)))
;;   (use-package helm-ag
;;     :ensure t
;;     :bind ("C-c h a" . helm-ag))
;;   (use-package helm-spotify
;;     :ensure t)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode)
  (use-package helm-projectile
    :ensure t
    :bind ("C-c p s a" . helm-projectile-ag))
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
)

(use-package flycheck
  :ensure t
  :init
  (setq flycheck-highlighting-mode 'nil)
  (add-hook 'after-init-hook #'global-flycheck-mode)
  :config
  ;; Disable JSHint checker in favor of ESLint.
  (setq-default flycheck-disabled-checkers '(javascript-jshint)))

(use-package smartparens
  :disabled t
  :ensure t
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode 1))

(use-package restclient
  :ensure t)

(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode)
         ("README\\.md\\'" . gfm-mode)))

(use-package json-mode
  :ensure t
  :init (setq js-indent-level 4))

(use-package js2-mode
  :ensure t
  :mode "\\.js\\'"
  :init
  (setq js2-highlight-level 3
        js2-basic-offset 4
        js2-allow-rhino-new-expr-initializer nil
        js2-global-externs '("describe" "before" "beforeEach" "after" "afterEach" "it")
        js2-include-node-externs t)
  (add-hook 'js2-mode-hook (lambda ()
                             (subword-mode 1)
                             (diminish 'subword-mode)))
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode)
  (rename-modeline "js2-mode" js2-mode "JS2")
  :config
  (use-package js-doc
    :ensure t)
  (use-package js2-refactor
    :ensure t
    :diminish js2-refactor-mode
    :init
    (add-hook 'js2-mode-hook #'js2-refactor-mode)
    :config
    (js2r-add-keybindings-with-prefix "C-c r")))

(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.ejs\\'" . web-mode)
         ("\\.jsx\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 4
        web-mode-css-indent-offset 4
        web-mode-code-indent-offset 4
        web-mode-style-padding 2
        web-mode-script-padding 2)

  (defun my-setup-web-mode-html ()
    (message "== setup web-mode for HTML ==")
    (local-set-key (kbd "C-=") 'web-mode-mark-and-expand)
    (flycheck-disable-checker 'javascript-eslint)
    (flycheck-select-checker 'html-tidy))

  (defun my-setup-web-mode-jsx ()
    (message "== setup web-mode for JSX ==")
    (local-set-key (kbd "C-=") 'er/expand-region)
    ;; TODO: Somehow the html-tidy checker is still enabled when a jsx
    ;; file is opened, but the errors disappear after the first
    ;; change. Investigate further.
    (flycheck-disable-checker 'html-tidy)
    (flycheck-select-checker 'javascript-eslint))

  (defun my-setup-web-mode ()
    (if (equal (file-name-extension buffer-file-name) "jsx")
        (my-setup-web-mode-jsx)
      (my-setup-web-mode-html)))

  (defun my-web-mode-hook ()
    (setq-local electric-pair-pairs (append electric-pair-pairs '((?' . ?'))))
    (setq-local electric-pair-text-pairs electric-pair-pairs))

  ;; (defadvice switch-to-buffer (after my-select-web-mode-config activate)
  ;;   (when (equal major-mode 'web-mode)
  ;;       (my-setup-web-mode)))

  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (flycheck-add-mode 'html-tidy 'web-mode)

  (add-hook 'web-mode-hook 'my-web-mode-hook))

(use-package jsx-mode
  :ensure t
  :init (setq jsx-indent-level 4))

(use-package tss
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode))

(use-package css-mode
  :init (setq css-indent-offset 4)
  :config
  (use-package rainbow-mode
    :ensure t
    :diminish rainbow-mode
    :init
    (add-hook 'css-mode-hook (lambda () (rainbow-mode t)))))

(use-package less-css-mode
  :ensure t)

(use-package scss-mode
  :ensure t
  :mode (("\\.sass\\'" . scss-mode)
         ("\\.scss\\'" . scss-mode)
         ("\\.cssm\\'" . scss-mode)
         ("\\.postcss\\'" . scss-mode)))

;; (use-package scala-mode2
;;   :ensure t
;;   :config
;;   (use-package sbt-mode
;;     :ensure t)
;;   (use-package ensime
;;     :ensure t
;;     :init
;;     (add-hook 'scala-mode-hook 'ensime-scala-mode-hook)))

(use-package cider
  :ensure t
  :config
  (add-hook 'clojure-mode-hook #'cider-mode)
  (add-hook 'cider-mode-hook #'eldoc-mode))

(use-package dired+
  :ensure t
  :config
  (diredp-toggle-find-file-reuse-dir 1)
  :init
  (setq diredp-hide-details-initially-flag nil))


(load custom-file 'no-error 'no-message)

;; Autocomplete
(require 'auto-complete-config)
(ac-config-default)

;;; ==================== DIMINISH ==================== ;;;

;; Diminish mode line
(diminish 'anzu-mode)
;;(diminish 'autopair-mode)
(diminish 'global-whitespace-mode)
(diminish 'volatile-highlights-mode)

(provide 'init)
;;; init.el ends here
