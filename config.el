;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Gaylon Alfano"
      user-mail-address "gaylon.alfano@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; test
(setq doom-font (font-spec :family "Fira Mono" :size 14))
;;

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-city-lights)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

;; Set indexed directory for faster access
(setq projectile-project-search-path '("~/Code/"))
;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
;; ========================================
;; ROUND 2 Python Elpy attempt following RealPython guide (mostly)
; (use-package! org-super-agenda
;   :after org-agenda
;   :init
;   (setq org-super-agenda-groups '((:name "Today"
;                                   :time-grid t
;                                   :scheduled today)
;                            (:name "Due today"
;                                   :deadline today)
;                            (:name "Important"
;                                   :priority "A")
;                            (:name "Overdue"
;                                   :deadline past)
;                            (:name "Due soon"
;                                   :deadline future)
;                            (:name "Big Outcomes"
;                                   :tag "bo")))
;   :config
;   (org-super-agenda-mode)
; )
; ;; Hide the startup message
; ;; (setq inhibit-startup-message)
; (use-package! pyenv-mode
;     :init
;     (pyenv-mode)
;     :config
;     (setenv "WORKON_HOME" "~/.pyenv/versions/")
;     (setq python-shell-interpreter "~/.pyenv/shims/python3")
;     (defun projectile-pyenv-mode-set ()
;       "Set pyenv version matching project name."
;       (let ((project (projectile-project-name)))
;         (if (member project (pyenv-mode-versions))
;             (pyenv-mode-set project)
;           (pyenv-mode-unset))))

;     (add-hook 'projectile-after-switch-project-hook 'projectile-pyenv-mode-set)

;     (defun ssbb-pyenv-hook ()
;     "Automatically activates pyenv version if .python-version file exists."
;     (f-traverse-upwards
;     (lambda (path)
;       (let ((pyenv-version-path (f-expand ".python-version" path)))
;         (if (f-exists? pyenv-version-path)
;             (pyenv-mode-set (s-trim (f-read-text pyenv-version-path 'utf-8))))))))

;     (add-hook 'find-file-hook 'ssbb-pyenv-hook))

; (setq-hook! python-mode 'eglot-ensure)
; (add-hook! python-mode 'eglot-ensure)
; (add-hook 'python-mode-hook 'eglot-ensure)
(use-package! lsp-mode
  ; :ensure t
  :config

  ;; change nil to 't to enable logging of packets between emacs and the LS
  ;; this was invaluable for debugging communication with the MS Python Language Server
  ;; and comparing this with what vs.code is doing
  (setq lsp-print-io nil)

  ;; lsp-ui gives us the blue documentation boxes and the sidebar info
  (use-package! lsp-ui
    ; :ensure t
    :config
    (setq lsp-ui-sideline-ignore-duplicate t)
    (add-hook 'lsp-mode-hook 'lsp-ui-mode))

  ;; make sure we have lsp-imenu everywhere we have LSP
  (require 'lsp-imenu)
  (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)

  ;; install LSP company backend for LSP-driven completion
  (use-package! company-lsp
    ; :ensure t
    :config
    (push 'company-lsp company-backends))
)

(use-package! lsp-python-ms
  :hook (python-mode . (lambda ()
                          (require 'lsp-python-ms)
                          (lsp))))  ; or lsp-deferred

(use-package! blacken
    ; :straight t
    :hook (python-mode . blacken-mode)
    :config
    (setq blacken-line-length '88))

;; install LSP company backend for LSP-driven completion
; (use-package! company-lsp
; :config
; (push 'company-lsp company-backends))

; (use-package! jupyter
;   ; :straight t
;   :hook
;   (jupyter-repl-mode . (lambda ()
;                          (setq company-backends '(company-capf))))
;   :bind
;   (:map jupyter-repl-mode-map
;         ("C-M-n" . jupyter-repl-history-next)
;         ("C-M-p" . jupyter-repl-history-previous)
;         ("M-n" . jupyter-repl-forward-cell)
;         ("M-p" . jupyter-repl-backward-cell)
;         :map jupyter-repl-interaction-mode-map
;         ("M-i" . nil)
;         ("C-?" . jupyter-inspect-at-point)))

; ;; Company configuration from same Elpy guide
; (use-package! company
;   ; :straight t
;   :diminish company-mode
;   :init
;   (global-company-mode)
;   :config
;   ;; set default `company-backends'
;   (setq company-backends
;         '((company-capf           ; completion-at-point-functions
;            company-files          ; files & directory
;            company-keywords)       ; keywords
;           (company-abbrev company-dabbrev)
;           )))
;   (use-package! company-statistics
;       ; :straight t
;       :init
;       (company-statistics-mode))
;   (use-package! company-web
;       ; :straight t)
;       )
;   (use-package! company-try-hard
;       ; :straight t
;       :bind
;       (("C-<tab>" . company-try-hard)
;        :map company-active-map
;        ("C-<tab>" . company-try-hard)))
;   (use-package! company-quickhelp
;       ; :straight t
;       :config
;       (company-quickhelp-mode))
; )

 ========================================

















;; FAILED Python Elpy attempt:
; (use-package! org-super-agenda
;   :after org-agenda
;   :init
;   (setq org-super-agenda-groups '((:name "Today"
;                                   :time-grid t
;                                   :scheduled today)
;                            (:name "Due today"
;                                   :deadline today)
;                            (:name "Important"
;                                   :priority "A")
;                            (:name "Overdue"
;                                   :deadline past)
;                            (:name "Due soon"
;                                   :deadline future)
;                            (:name "Big Outcomes"
;                                   :tag "bo")))
;   :config
;   (org-super-agenda-mode)
; )
; ;; Hide the startup message
; ;; (setq inhibit-startup-message)

; (use-package! python
;   :hook (inferior-python-mode . fix-python-password-entry)
;   :config

;   (setq python-shell-interpreter "jupyter-console"
;         python-shell-interpreter-args "--simple-prompt"
;         python-shell-prompt-detect-failure-warning nil)
;   (add-to-list 'python-shell-completion-native-disabled-interpreters
;                "jupyter-console")
;   (add-to-list 'python-shell-completion-native-disabled-interpreters
;                "jupyter")

;   (defun fix-python-password-entry ()
;     (push
;      'comint-watch-for-password-prompt comint-output-filter-functions))

;   (defun my-setup-python (orig-fun &rest args)
;     "Use corresponding kernel"
;     (let* ((curr-python (car (split-string (pyenv--version-name) ":")))
;            (python-shell-buffer-name (concat "Python-" curr-python))
;            (python-shell-interpreter-args (if (bound-and-true-p djangonaut-mode)
;                                               "shell_plus -- --simple-prompt"
;                                             (concat "--simple-prompt --kernel=" curr-python)))
;            (python-shell-interpreter (if (bound-and-true-p djangonaut-mode)
;                                          "django-admin"
;                                        python-shell-interpreter)))
;       (apply orig-fun args)))

;   (advice-add 'python-shell-get-process-name :around #'my-setup-python)
;   (advice-add 'python-shell-calculate-command :around #'my-setup-python)


;   (use-package! pyenv
;       ; :straight (:host github :repo "aiguofer/pyenv.el")
;       :config
;       (setq pyenv-use-alias 't)
;       (setq pyenv-modestring-prefix " ")
;       (setq pyenv-modestring-postfix nil)
;       (setq pyenv-set-path nil)

;       (global-pyenv-mode)
;       (defun pyenv-update-on-buffer-switch (prev curr)
;         (if (string-equal "Python" (format-mode-line mode-name nil nil curr))
;             (pyenv-use-corresponding)))
;       (add-hook 'switch-buffer-functions 'pyenv-update-on-buffer-switch))

;   (use-package! buftra
;       ; :recipe (:host github :repo "humitos/buftra.el")
;       )
;   (use-package! py-pyment
;       ; :recipe (:host github :repo "humitos/py-cmd-buffer.el")
;       :config
;       (setq py-pyment-options '("--output=numpydoc")))
;   (use-package! py-isort
;       ; :recipe (:host github :repo "humitos/py-cmd-buffer.el")
;       :hook (python-mode . py-isort-enable-on-save)
;       :config
;       (setq py-isort-options '("--lines=88" "-m=3" "-tc" "-fgw=0" "-ca")))
;   (use-package! py-autoflake
;       ; :recipe (:host github :repo "humitos/py-cmd-buffer.el")
;       :hook (python-mode . py-autoflake-enable-on-save)
;       :config
;       (setq py-autoflake-options '("--expand-star-imports")))
;   (use-package! py-docformatter
;       ; :recipe (:host github :repo "humitos/py-cmd-buffer.el")
;       :hook (python-mode . py-docformatter-enable-on-save)
;       :config
;       (setq py-docformatter-options '("--wrap-summaries=88" "--pre-summary-newline")))
;   (use-package! blacken
;       ; :straight t
;       :hook (python-mode . blacken-mode)
;       :config
;       (setq blacken-line-length '88))
;   (use-package! python-docstring
;       ; :straight t
;       :hook (python-mode . python-docstring-mode))
;   ;; elpy configuration from https://medium.com/analytics-vidhya/managing-a-python-development-environment-in-emacs-43897fd48c6a
;   (use-package! elpy
;       ; :straight t
;       :defer t
;       :bind
;       (:map elpy-mode-map
;             ("C-M-n" . elpy-nav-forward-block)
;             ("C-M-p" . elpy-nav-backward-block))
;       :hook ((elpy-mode . flycheck-mode)
;              (pyenv-mode . elpy-rpc-restart))
;       :init
;       ; (elpy-version)
;       ; (elpy-enable)
;       (advice-add 'python-mode :after 'elpy-enable)
;       :config
;       (setq elpy-modules (delq 'elpy-module-flymake elpy-modules)))
;   (use-package! djangonaut
;       :config
;       (setq pythonic-interpreter "python")
;       (global-djangonaut-mode))
;   (use-package! jupyter
;     ; :straight t
;     :hook
;     (jupyter-repl-mode . (lambda ()
;                            (setq company-backends '(company-capf))))
;     :bind
;     (:map jupyter-repl-mode-map
;           ("C-M-n" . jupyter-repl-history-next)
;           ("C-M-p" . jupyter-repl-history-previous)
;           ("M-n" . jupyter-repl-forward-cell)
;           ("M-p" . jupyter-repl-backward-cell)
;           :map jupyter-repl-interaction-mode-map
;           ("M-i" . nil)
;           ("C-?" . jupyter-inspect-at-point)
;           )
;     )
; )
; ;; Company configuration from same Elpy guide
; (use-package! company
;   ; :straight t
;   :diminish company-mode
;   :init
;   (global-company-mode)
;   :config
;   ;; set default `company-backends'
;   (setq company-backends
;         '((company-files          ; files & directory
;            company-keywords       ; keywords
;            company-capf)          ; completion-at-point-functions
;           (company-abbrev company-dabbrev)
;           ))
;   (use-package! company-statistics
;       ; :straight t
;       :init
;       (company-statistics-mode))
;   (use-package! company-web
;       ; :straight t)
;       )
;   (use-package! company-try-hard
;       ; :straight t
;       :bind
;       (("C-<tab>" . company-try-hard)
;        :map company-active-map
;        ("C-<tab>" . company-try-hard)))
;   (use-package! company-quickhelp
;       ; :straight t
;       :config
;       (company-quickhelp-mode))
; )
