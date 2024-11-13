;; -*- lexical-binding: t; eval: (local-set-key (kbd "C-c i") #'consult-outline); outline-regexp: ";;;"; -*-

;;; Package Repositories
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;; Custom Settings
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file t)

;;; Core UI Changes
(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

;;; Undo Tree
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode 1)
  (setq undo-tree-auto-save-history nil))

;;; Key Bindings

;; Which Key
(use-package which-key
  :ensure t
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-allow-imprecise-window-fit nil
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit nil
	which-key-separator " → " ))

;; General
(use-package general
  :ensure t
  :demand t
  :config
  (general-evil-setup)

  (general-create-definer sb/leader-keys
			  :states '(normal insert visual emacs)
			  :keymaps 'override
			  :prefix "SPC"
			  :global-prefix "M-SPC")

  (sb/leader-keys
   "." '(find-file :wk "Find file"))

  (sb/leader-keys
   "f" '(:ignore t :wk "Files")    
   "f i" '((lambda () (interactive)
	     (find-file (concat (file-name-as-directory user-emacs-directory) "init.el"))) 
	   :wk "Open init.el"))

  (sb/leader-keys
   "h" '(:ignore t :wk "Help")
   "h a" '(counsel-apropos :wk "Apropos")
   "h b" '(describe-bindings :wk "Describe bindings")
   "h c" '(describe-char :wk "Describe character under cursor")
   "h d" '(:ignore t :wk "Emacs documentation")
   "h d a" '(about-emacs :wk "About Emacs")
   "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
   "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
   "h d m" '(info-emacs-manual :wk "The Emacs manual")
   "h d n" '(view-emacs-news :wk "View Emacs news")
   "h d o" '(describe-distribution :wk "How to obtain Emacs")
   "h d p" '(view-emacs-problems :wk "View Emacs problems")
   "h d t" '(view-emacs-todo :wk "View Emacs todo")
   "h d w" '(describe-no-warranty :wk "Describe no warranty")
   "h e" '(view-echo-area-messages :wk "View echo area messages")
   "h f" '(describe-function :wk "Describe function")
   "h F" '(describe-face :wk "Describe face")
   "h g" '(describe-gnu-project :wk "Describe GNU Project")
   "h i" '(info :wk "Info")
   "h I" '(describe-input-method :wk "Describe input method")
   "h k" '(describe-key :wk "Describe key")
   "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
   "h L" '(describe-language-environment :wk "Describe language environment")
   "h m" '(describe-mode :wk "Describe mode")
   "h r" '(:ignore t :wk "Reload")
   "h r r" '((lambda () (interactive)
	       (load-file "~/.config/emacs/init.el")
					;(ignore (elpaca-process-queues))
	       )
	     :wk "Reload emacs config")
   "h t" '(load-theme :wk "Load theme")
   "h v" '(describe-variable :wk "Describe variable")
   "h w" '(where-is :wk "Prints keybinding for command if set")
   "h x" '(describe-command :wk "Display full documentation for command"))
  )

;; Evil
(use-package evil
  :ensure t
  :demand t
  :init      
  (setq evil-want-integration t  
	evil-want-keybinding nil
	evil-vsplit-window-right t
	evil-split-window-below t
	evil-undo-system 'undo-tree)
  (evil-mode))

(use-package evil-collection
  :ensure t
  :demand t
  :after evil
  :config
  (add-to-list 'evil-collection-mode-list 'help)
  (evil-collection-init))

(use-package evil-org
  :ensure t
  :after (evil org)
  :hook ((org-mode . evil-org-mode)
         (org-agenda-mode . evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-set-key-theme '(navigation todo insert textobjects additional))
  (evil-org-agenda-set-keys))

(with-eval-after-load 'org
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(use-package evil-tutor
  :ensure t)

;; Using RETURN to follow links in Org/Evil 
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map (kbd "SPC") nil)
  (define-key evil-motion-state-map (kbd "RET") nil)
  (define-key evil-motion-state-map (kbd "TAB") nil))
;; Setting RETURN key in org-mode to follow links
(setq org-return-follows-link  t)
	     
;;; Completions
(use-package vertico
  :ensure t
  :bind (:map vertico-map
	      ("C-j" . vertico-next)
	      ("C-k" . vertico-previous)
	      ("C-f" . vertico-exit)
	      :map minibuffer-local-map
	      ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
  :init
  (vertico-mode))

(use-package marginalia
  :after vertico
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)
	read-buffer-completion-ignore-case t
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :ensure t
  :bind
  (;; C-c bindings in `mode-specific-map'
   ("C-c M-x" . consult-mode-command)
   ("C-c h" . consult-history)
   ("C-c k" . consult-kmacro)
   ("C-c m" . consult-man)
   ("C-c i" . consult-info)
   ([remap Info-search] . consult-info)
   ;; C-x bindings in `ctl-x-map'
   ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
   ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
   ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
   ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
   ("C-x t b" . consult-buffer-other-tab)    ;; orig. switch-to-buffer-other-tab
   ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
   ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
   ;; Custom M-# bindings for fast register access
   ("M-#" . consult-register-load)
   ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
   ("C-M-#" . consult-register)
   ;; Other custom bindings
   ("M-y" . consult-yank-pop)                ;; orig. yank-pop
   ;; M-g bindings in `goto-map'
   ("M-g e" . consult-compile-error)
   ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
   ("M-g g" . consult-goto-line)             ;; orig. goto-line
   ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
   ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
   ("M-g m" . consult-mark)
   ("M-g k" . consult-global-mark)
   ("M-g i" . consult-imenu)
   ("M-g I" . consult-imenu-multi)
   ;; M-s bindings in `search-map'
   ("M-s d" . consult-find)                  ;; Alternative: consult-fd
   ("M-s c" . consult-locate)
   ("M-s g" . consult-grep)
   ("M-s G" . consult-git-grep)
   ("M-s r" . consult-ripgrep)
   ("M-s l" . consult-line)
   ("M-s L" . consult-line-multi)
   ("M-s k" . consult-keep-lines)
   ("M-s u" . consult-focus-lines)
   ;; Isearch integration
   ("M-s e" . consult-isearch-history)
   :map isearch-mode-map
   ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
   ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
   ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
   ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
   ;; Minibuffer history
   :map minibuffer-local-map
   ("M-s" . consult-history)                 ;; orig. next-matching-history-element
   ("M-r" . consult-history))                ;; orig. previous-matching-history-element
  )

(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  :init
  (global-corfu-mode))

;;; Theming

;; Color Theme
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-nova t)
  (doom-themes-org-config))

;; Fonts
(set-face-attribute 'default nil
		    :font "JetBrains Mono"
		    :height 140
		    :weight 'medium)
(set-face-attribute 'variable-pitch nil
		    :font "Ubuntu Nerd Font"
		    :height 150
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :font "JetBrains Mono"
		    :height 140
		    :weight 'medium)

;; Icons
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-corfu
  :ensure t)

;; Modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 35      ;; sets modeline height
        doom-modeline-bar-width 5    ;; sets right bar width
        doom-modeline-persp-name t   ;; adds perspective name to modeline
        doom-modeline-persp-icon t)) ;; adds folder icon next to persp name

;;; Magit
(use-package magit
  :ensure t)
