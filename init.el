(setq inhibit-startup-message t)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

(setq-default indent-tabs-mode nil)

;; Packages
(setq package-list '(evil 
                     evil-collection
                     vertico
                     general
                     key-chord
                     undo-tree
                     projectile
                     which-key
                     exec-path-from-shell
                     company
                     magit
                     doom-modeline
                     org-autolist

                     ;; language specific packages
                     tuareg
                     go-mode))

(require 'package)

(setq package-archives
'(
   ;; ("org" . "https://orgmode.org/elpa/")
   ;; ("gnu" . "https://elpa.gnu.org/packages/")
   ("melpa" . "https://melpa.org/packages/")
   ("melpa-stable" . "https://stable.melpa.org/packages/")
))


(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(use-package doom-modeline
  :ensure t
  :hook (after-init . doom-modeline-mode)
  :config (setq doom-modeline-buffer-name t))

(use-package org-autolist
  :hook (org-mode . org-autolist-mode))

;; Enable Evil
(use-package evil
    :init 
    (setq evil-want-keybinding nil)
    (setq evil-search-module 'evil-search)
    :config
    (evil-mode 1)
    (evil-collection-init)
    (setq evil-undo-system 'undo-tree))

(use-package vertico
     :init
     (vertico-mode))

(use-package savehist
  :init
  (savehist-mode))

;; Minibuffer keymaps
(keymap-set minibuffer-local-map "C-j" 'next-line)
(keymap-set minibuffer-local-map "C-k" 'previous-line)

;; General keymaps
(use-package general
  :after (evil projectile key-chord)
    :config
    (general-define-key
      :states '(normal visual)
      "C-u" 'evil-scroll-up
      "H" 'evil-beginning-of-line
      "L" 'evil-end-of-line)

    (general-create-definer leader-def
        :prefix "SPC")

    (leader-def
      :keymaps 'normal
      "fd" 'dired
      "fj" 'dired-jump
      "ff" 'find-file
      "w" 'save-buffer
      "p" 'projectile-command-map
      "c" 'evil-ex-nohighlight
      "no" (lambda() (interactive) (find-file "~/notes/index.org")))

    (general-define-key :keymaps 'evil-insert-state-map
                    (general-chord "jk") 'evil-normal-state)
    )

(use-package dired
  :config (setq dired-listing-switches "-l"))

(use-package key-chord
  :config
  (key-chord-mode 1)
  )

(use-package undo-tree
  :ensure t
  :after evil
  :diminish
  :config
  (evil-set-undo-system 'undo-tree)
  (setq undo-tree-auto-save-history nil)
  (global-undo-tree-mode 1))

(use-package projectile
  :config
  (setq projectile-track-known-projects-automatically nil)
  (projectile-mode)
  )

(use-package which-key
  :config (which-key-mode)
  )

(use-package exec-path-from-shell
  :config (when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

(use-package company
  :config
  (add-to-list 'company-backends 'company-capf)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1)
  (define-key company-active-map (kbd "C-j") #'company-select-next)
  (define-key company-active-map (kbd "C-k") #'company-select-previous)
  (setq company-global-modes '(not org-mode))
  (global-company-mode))

(use-package eglot
  :ensure t
  :init (setq eglot-sync-connect nil)
  :hook (
	(go-mode . eglot-ensure)
        (go-ts-mode . eglot-ensure)
        (json-ts-mode . eglot-ensure)
        (yaml-ts-mode . eglot-ensure)
        (python-mode . eglot-ensure)
	(tuareg-mode . eglot-ensure)
        ;; https://github.com/joaotavora/eglot/issues/123#issuecomment-444104870
        ;; (eglot--managed-mode . (lambda ()
        ;;                          (eldoc-mode -1)
        ;;                          (flymake-mode -1)))
	)
  :config)

(use-package go-mode
  :init (add-hook 'before-save-hook #'gofmt-before-save)
  :ensure t
  :general
  (:states 'normal
           :prefix "SPC"
           "bf" 'gofmt))

(use-package org
  :hook (org-mode . org-indent-mode))

(use-package magit
  :general
  (:states 'normal "SPC g g" #'magit)
  :config (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))


;; (add-hook 'tuareg-mode-hook 'merlin-mode)

(set-frame-font "FiraCode Nerd Font Mono 12" nil t)

(electric-pair-mode 1)


;; Still don't know how to use this shit properly, figure out later
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go" "v0.20.0")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod" "v1.0.2")))



;; From: https://snarfed.org/gnu_emacs_backup_files
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms '((".*" "~/.config/emacs/autosaves/\\1" t)))
 '(backup-directory-alist '((".*" . "~/.config/emacs/backups/")))
 '(custom-enabled-themes '(gruvbox-dark-medium))
 '(custom-safe-themes
   '("5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d" default))
 '(display-line-numbers-type 'relative)
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(org-autolist doom-modeline magit format-all merlin gruvbox-theme go-mode eldoc-box company company-mode exec-path-from-shell direnv tuareg which-key projectile key-chord evil-collection evil))
 '(tool-bar-mode nil))
;; create the autosave dir if necessary, since emacs won't.
(make-directory "~/.config/emacs/autosaves/" t)




(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
