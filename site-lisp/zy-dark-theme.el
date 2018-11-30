;;; zy-theme.el --- A retro-groove colour theme for Emacs base on gruvbox

;; Copyright (c) 2018 zeya

;; Package-Requires: ((autothemer "0.2"))

;;; Commentary:

;; Using autothemer since 1.00

;; A port of the Zy colorscheme for Vim, built on top of the new built-in
;; theme support in Emacs 24.
;;
;; This theme contains my own modifications and it's a bit opinionated
;; sometimes, deviating from the original because of it. I try to stay
;; true to the original as much as possible, however. I only make
;; changes where I would have made the changes on the original.
;;
;; Since there is no direct equivalent in syntax highlighting from Vim to Emacs
;; some stuff may look different, especially in stuff like JS2-mode, where it
;; adds stuff that Vim doesn't have, in terms of syntax.

;;; Credits:

;;; Code:
(eval-when-compile
  (require 'cl-lib))

(require 'autothemer)

(unless (>= emacs-major-version 24)
  (error "Requires Emacs 24 or later"))

(defmacro zy-deftheme (name description palette reduced-specs &rest body)
  `(autothemer-deftheme
    ,name
    ,description
    ,palette
    ((default                                   (:background zy-bg :foreground zy-light0))
     (cursor                                    (:background zy-light0))
     (mode-line                                 (:background zy-dark3 :foreground zy-light2 :box nil))
     (mode-line-inactive                        (:background zy-dark1 :foreground zy-light4 :box nil))
     (fringe                                    (:background zy-bg))
     (hl-line                                   (:background zy-dark1))
     (region                                    (:background zy-dark2)) ;;selection
     (secondary-selection                       (:background zy-dark1))
     (minibuffer-prompt                         (:background zy-bg :foreground zy-bright_green :bold t))
     (vertical-border                           (:foreground zy-dark2))
     (window-divider                            (:foreground zy-dark2))
     (link                                      (:foreground zy-faded_blue :underline t))
     (shadow                                    (:foreground zy-dark4))

     ;; Built-in syntax

     (font-lock-builtin-face                            (:foreground zy-bright_orange :bold t))
     (font-lock-constant-face                           (:foreground zy-bright_purple))
     (font-lock-comment-face                            (:foreground zy-dark4))
     (font-lock-function-name-face                      (:foreground zy-bright_yellow :bold t))
     (font-lock-keyword-face                            (:foreground zy-bright_red :bold t))
     (font-lock-string-face                             (:foreground zy-bright_green))
     (font-lock-variable-name-face                      (:foreground zy-bright_blue))
     (font-lock-type-face                               (:foreground zy-bright_purple))
     (font-lock-warning-face                            (:foreground zy-bright_red :bold t))

     ;; Basic faces
     (error                                             (:foreground zy-bright_red :bold t))
     (success                                           (:foreground zy-bright_green :bold t))
     (warning                                           (:foreground zy-bright_yellow :bold t))
     (trailing-whitespace                               (:background zy-bright_red))
     (escape-glyph                                      (:foreground zy-bright_aqua))
     (header-line                                       (:background zy-dark0 :foreground zy-light3 :box nil :inherit nil))
     (highlight                                         (:background zy-dark4 :foreground zy-light0))
     (homoglyph                                         (:foreground zy-bright_yellow))
     (match                                             (:foreground zy-dark0 :background zy-bright_blue))

     ;; Customize faces
     (widget-field                                      (:background zy-dark3))
     (custom-group-tag                                  (:foreground zy-bright_blue :weight 'bold))
     (custom-variable-tag                               (:foreground zy-bright_blue :weight 'bold))

     ;; whitespace-mode

     (whitespace-space                          (:background zy-bg :foreground zy-dark4))
     (whitespace-hspace                         (:background zy-bg :foreground zy-dark4))
     (whitespace-tab                            (:background zy-bg :foreground zy-dark4))
     (whitespace-newline                        (:background zy-bg :foreground zy-dark4))
     (whitespace-trailing                       (:background zy-dark1 :foreground zy-bright_red))
     (whitespace-line                           (:background zy-dark1 :foreground zy-bright_red))
     (whitespace-space-before-tab               (:background zy-bg :foreground zy-dark4))
     (whitespace-indentation                    (:background zy-bg :foreground zy-dark4))
     (whitespace-empty                          (:background nil :foreground nil))
     (whitespace-space-after-tab                (:background zy-bg :foreground zy-dark4))

     ;; RainbowDelimiters

     (rainbow-delimiters-depth-1-face           (:foreground zy-delimiter-one))
     (rainbow-delimiters-depth-2-face           (:foreground zy-delimiter-two))
     (rainbow-delimiters-depth-3-face           (:foreground zy-delimiter-three))
     (rainbow-delimiters-depth-4-face           (:foreground zy-delimiter-four))
     (rainbow-delimiters-depth-5-face           (:foreground zy-delimiter-one))
     (rainbow-delimiters-depth-6-face           (:foreground zy-delimiter-two))
     (rainbow-delimiters-depth-7-face           (:foreground zy-delimiter-three))
     (rainbow-delimiters-depth-8-face           (:foreground zy-delimiter-four))
     (rainbow-delimiters-depth-9-face           (:foreground zy-delimiter-one))
     (rainbow-delimiters-depth-10-face          (:foreground zy-delimiter-two))
     (rainbow-delimiters-depth-11-face          (:foreground zy-delimiter-three))
     (rainbow-delimiters-depth-12-face          (:foreground zy-delimiter-four))
     (rainbow-delimiters-unmatched-face         (:background nil :foreground zy-light0))


     ;; line numbers
     (line-number                               (:foreground zy-dark4 :background zy-dark1))
     (line-number-current-line                  (:foreground zy-bright_orange :background zy-dark2))
     (linum                                     (:foreground zy-dark4 :background zy-dark1))
     (linum-highlight-face                      (:foreground zy-bright_orange :background zy-dark2))
     (linum-relative-current-face               (:foreground zy-bright_orange :background zy-dark2))

     ;; Highlight indentation mode
     (highlight-indentation-current-column-face (:background zy-dark2))
     (highlight-indentation-face                (:background zy-dark1))

     ;; smartparens
     (sp-pair-overlay-face                      (:background zy-dark2))
     (sp-show-pair-match-face                   (:background zy-dark2)) ;; Pair tags highlight
     (sp-show-pair-mismatch-face                (:background zy-bright_red)) ;; Highlight for bracket without pair
     ;;(sp-wrap-overlay-face                     (:inherit 'sp-wrap-overlay-face))
     ;;(sp-wrap-tag-overlay-face                 (:inherit 'sp-wrap-overlay-face))

     ;; elscreen
     (elscreen-tab-background-face              (:background zy-bg :box nil)) ;; Tab bar, not the tabs
     (elscreen-tab-control-face                 (:background zy-dark2 :foreground zy-bright_red :underline nil :box nil)) ;; The controls
     (elscreen-tab-current-screen-face          (:background zy-dark4 :foreground zy-dark0 :box nil)) ;; Current tab
     (elscreen-tab-other-screen-face            (:background zy-dark2 :foreground zy-light4 :underline nil :box nil)) ;; Inactive tab

     ;; ag (The Silver Searcher)
     (ag-hit-face                               (:foreground zy-bright_blue))
     (ag-match-face                             (:foreground zy-bright_red))

     ;; Diffs
     (diff-changed                              (:background nil :foreground zy-light1))
     (diff-added                                (:background nil :foreground zy-bright_green))
     (diff-removed                              (:background nil :foreground zy-bright_red))
     (diff-indicator-changed                    (:inherit 'diff-changed))
     (diff-indicator-added                      (:inherit 'diff-added))
     (diff-indicator-removed                    (:inherit 'diff-removed))

     (js2-warning                               (:underline (:color zy-bright_yellow :style 'wave)))
     (js2-error                                 (:underline (:color zy-bright_red :style 'wave)))
     (js2-external-variable                     (:underline (:color zy-bright_aqua :style 'wave)))
     (js2-jsdoc-tag                             (:background nil :foreground zy-gray))
     (js2-jsdoc-type                            (:background nil :foreground zy-light4))
     (js2-jsdoc-value                           (:background nil :foreground zy-light3))
     (js2-function-param                        (:background nil :foreground zy-bright_aqua))
     (js2-function-call                         (:background nil :foreground zy-bright_blue))
     (js2-instance-member                       (:background nil :foreground zy-bright_orange))
     (js2-private-member                        (:background nil :foreground zy-faded_yellow))
     (js2-private-function-call                 (:background nil :foreground zy-faded_aqua))
     (js2-jsdoc-html-tag-name                   (:background nil :foreground zy-light4))
     (js2-jsdoc-html-tag-delimiter              (:background nil :foreground zy-light3))

     ;; popup
     (popup-face                                (:underline nil :foreground zy-light1 :background zy-dark1))
     (popup-menu-mouse-face                     (:underline nil :foreground zy-light0 :background zy-faded_green))
     (popup-menu-selection-face                 (:underline nil :foreground zy-light0 :background zy-faded_green))
     (popup-tip-face                            (:underline nil :foreground zy-light2 :background zy-dark2))

     ;; helm
     (helm-M-x-key                              (:foreground zy-bright_orange ))
     (helm-action                               (:foreground zy-white :underline t))
     (helm-bookmark-addressbook                 (:foreground zy-bright_red))
     (helm-bookmark-directory                   (:foreground zy-bright_purple))
     (helm-bookmark-file                        (:foreground zy-faded_blue))
     (helm-bookmark-gnus                        (:foreground zy-faded_purple))
     (helm-bookmark-info                        (:foreground zy-turquoise4))
     (helm-bookmark-man                         (:foreground zy-sienna))
     (helm-bookmark-w3m                         (:foreground zy-bright_yellow))
     (helm-buffer-directory                     (:foreground zy-white :background zy-bright_blue))
     (helm-buffer-not-saved                     (:foreground zy-faded_red))
     (helm-buffer-process                       (:foreground zy-burlywood4))
     (helm-buffer-saved-out                     (:foreground zy-bright_red))
     (helm-buffer-size                          (:foreground zy-bright_purple))
     (helm-candidate-number                     (:foreground zy-bright_green))
     (helm-ff-directory                         (:foreground zy-bright_purple))
     (helm-ff-executable                        (:foreground zy-turquoise4))
     (helm-ff-file                              (:foreground zy-sienna))
     (helm-ff-invalid-symlink                   (:foreground zy-white :background zy-bright_red))
     (helm-ff-prefix                            (:foreground zy-black :background zy-bright_yellow))
     (helm-ff-symlink                           (:foreground zy-bright_orange))
     (helm-grep-cmd-line                        (:foreground zy-bright_green))
     (helm-grep-file                            (:foreground zy-faded_purple))
     (helm-grep-finish                          (:foreground zy-turquoise4))
     (helm-grep-lineno                          (:foreground zy-bright_orange))
     (helm-grep-match                           (:foreground zy-bright_yellow))
     (helm-grep-running                         (:foreground zy-bright_red))
     (helm-header                               (:foreground zy-aquamarine4))
     (helm-helper                               (:foreground zy-aquamarine4))
     (helm-history-deleted                      (:foreground zy-black :background zy-bright_red))
     (helm-history-remote                       (:foreground zy-faded_red))
     (helm-lisp-completion-info                 (:foreground zy-faded_orange))
     (helm-lisp-show-completion                 (:foreground zy-bright_red))
     (helm-locate-finish                        (:foreground zy-white :background zy-aquamarine4))
     (helm-match                                (:foreground zy-bright_orange))
     (helm-moccur-buffer                        (:foreground zy-bright_aqua :underline t))
     (helm-prefarg                              (:foreground zy-turquoise4))
     (helm-selection                            (:foreground zy-white :background zy-dark2))
     (helm-selection-line                       (:foreground zy-white :background zy-dark2))
     (helm-separator                            (:foreground zy-faded_red))
     (helm-source-header                        (:foreground zy-light2))
     (helm-visible-mark                         (:foreground zy-black :background zy-light3))

     ;; company-mode
     (company-scrollbar-bg                      (:background zy-dark1))
     (company-scrollbar-fg                      (:background zy-dark0_soft))
     (company-tooltip                           (:background zy-dark0_soft))
     (company-tooltip-annotation                (:foreground zy-bright_green))
     (company-tooltip-annotation-selection      (:inherit 'company-tooltip-annotation))
     (company-tooltip-selection                 (:foreground zy-bright_purple :background zy-dark2))
     (company-tooltip-common                    (:foreground zy-bright_blue :underline t))
     (company-tooltip-common-selection          (:foreground zy-bright_blue :underline t))
     (company-preview-common                    (:foreground zy-light0))
     (company-preview                           (:background zy-lightblue4))
     (company-preview-search                    (:background zy-turquoise4))
     (company-template-field                    (:foreground zy-black :background zy-bright_yellow))
     (company-echo-common                       (:foreground zy-faded_red))

     ;; tool tips
     (tooltip                                   (:foreground zy-light1 :background zy-dark1))

     ;; term
     (term-color-black                          (:foreground zy-dark2 :background zy-dark1))
     (term-color-blue                           (:foreground zy-bright_blue :background zy-bright_blue))
     (term-color-cyan                           (:foreground zy-bright_aqua :background zy-bright_aqua))
     (term-color-green                          (:foreground zy-bright_green :background zy-bright_green))
     (term-color-magenta                        (:foreground zy-bright_purple :background zy-bright_purple))
     (term-color-red                            (:foreground zy-bright_red :background zy-bright_red))
     (term-color-white                          (:foreground zy-light1 :background zy-light1))
     (term-color-yellow                         (:foreground zy-bright_yellow :background zy-bright_yellow))
     (term-default-fg-color                     (:foreground zy-light0))
     (term-default-bg-color                     (:background zy-bg))

     ;; message-mode
     (message-header-to                         (:inherit 'font-lock-variable-name-face))
     (message-header-cc                         (:inherit 'font-lock-variable-name-face))
     (message-header-subject                    (:foreground zy-bright_orange :weight 'bold))
     (message-header-newsgroups                 (:foreground zy-bright_yellow :weight 'bold))
     (message-header-other                      (:inherit 'font-lock-variable-name-face))
     (message-header-name                       (:inherit 'font-lock-keyword-face))
     (message-header-xheader                    (:foreground zy-faded_blue))
     (message-separator                         (:inherit 'font-lock-comment-face))
     (message-cited-text                        (:inherit 'font-lock-comment-face))
     (message-mml                               (:foreground zy-faded_green :weight 'bold))

     ;; org-mode
     (org-hide                                  (:foreground zy-dark0))
     (org-level-1                               (:foreground zy-bright_blue))
     (org-level-2                               (:foreground zy-bright_yellow))
     (org-level-3                               (:foreground zy-bright_purple))
     (org-level-4                               (:foreground zy-bright_red))
     (org-level-5                               (:foreground zy-bright_green))
     (org-level-6                               (:foreground zy-bright_aqua))
     (org-level-7                               (:foreground zy-faded_blue))
     (org-level-8                               (:foreground zy-bright_orange))
     (org-special-keyword                       (:inherit 'font-lock-comment-face))
     (org-drawer                                (:inherit 'font-lock-function-face))
     (org-column                                (:background zy-dark0))
     (org-column-title                          (:background zy-dark0 :underline t :weight 'bold))
     (org-warning                               (:foreground zy-bright_red :weight 'bold :underline nil :bold t))
     (org-archived                              (:foreground zy-light0 :weight 'bold))
     (org-link                                  (:foreground zy-faded_aqua :underline t))
     (org-footnote                              (:foreground zy-bright_aqua :underline t))
     (org-ellipsis                              (:foreground zy-light4))
     (org-date                                  (:foreground zy-bright_blue :underline t))
     (org-sexp-date                             (:foreground zy-faded_blue :underline t))
     (org-tag                                   (:bold t :weight 'bold))
     (org-list-dt                               (:bold t :weight 'bold))
     (org-todo                                  (:foreground zy-bright_red :weight 'bold :bold t))
     (org-done                                  (:foreground zy-bright_aqua :weight 'bold :bold t))
     (org-agenda-done                           (:foreground zy-bright_aqua))
     (org-headline-done                         (:foreground zy-bright_aqua))
     (org-table                                 (:foreground zy-bright_blue))
     (org-formula                               (:foreground zy-bright_yellow))
     (org-document-title                        (:foreground zy-faded_blue))
     (org-document-info                         (:foreground zy-faded_blue))
     (org-agenda-structure                      (:inherit 'font-lock-comment-face))
     (org-agenda-date-today                     (:foreground zy-light0 :weight 'bold :italic t))
     (org-scheduled                             (:foreground zy-bright_yellow))
     (org-scheduled-today                       (:foreground zy-bright_blue))
     (org-scheduled-previously                  (:foreground zy-faded_red))
     (org-upcoming-deadline                     (:inherit 'font-lock-keyword-face))
     (org-deadline-announce                     (:foreground zy-faded_red))
     (org-time-grid                             (:foreground zy-faded_orange))
     (org-latex-and-related                     (:foreground zy-bright_blue))

     ;; org-habit
     (org-habit-clear-face                      (:background zy-faded_blue))
     (org-habit-clear-future-face               (:background zy-bright_blue))
     (org-habit-ready-face                      (:background zy-faded_green))
     (org-habit-ready-future-face               (:background zy-bright_green))
     (org-habit-alert-face                      (:background zy-faded_yellow))
     (org-habit-alert-future-face               (:background zy-bright_yellow))
     (org-habit-overdue-face                    (:background zy-faded_red))
     (org-habit-overdue-future-face             (:background zy-bright_red))

     ;; elfeed
     (elfeed-search-title-face                  (:foreground zy-gray  ))
     (elfeed-search-unread-title-face           (:foreground zy-light0))
     (elfeed-search-date-face                   (:inherit 'font-lock-builtin-face :underline t))
     (elfeed-search-feed-face                   (:inherit 'font-lock-variable-name-face))
     (elfeed-search-tag-face                    (:inherit 'font-lock-keyword-face))
     (elfeed-search-last-update-face            (:inherit 'font-lock-comment-face))
     (elfeed-search-unread-count-face           (:inherit 'font-lock-comment-face))
     (elfeed-search-filter-face                 (:inherit 'font-lock-string-face))

     ;; smart-mode-line
     (sml/global                                (:foreground zy-burlywood4 :inverse-video nil))
     (sml/modes                                 (:foreground zy-bright_green))
     (sml/filename                              (:foreground zy-bright_red :weight 'bold))
     (sml/prefix                                (:foreground zy-light1))
     (sml/read-only                             (:foreground zy-bright_blue))
     (persp-selected-face                       (:foreground zy-bright_orange))

     ;; powerline
     (powerline-active0                         (:background zy-dark4 :foreground zy-light0))
     (powerline-active1                         (:background zy-dark3 :foreground zy-light0))
     (powerline-active2                         (:background zy-dark2 :foreground zy-light0))
     (powerline-inactive0                       (:background zy-dark2 :foreground zy-light4))
     (powerline-inactive1                       (:background zy-dark1 :foreground zy-light4))
     (powerline-inactive2                       (:background zy-dark0 :foreground zy-light4))

     ;; isearch
     (isearch                                   (:foreground zy-black :background zy-bright_orange))
     (lazy-highlight                            (:foreground zy-black :background zy-bright_yellow))
     (isearch-fail                              (:foreground zy-light0 :background zy-bright_red))

     ;; markdown-mode
     (markdown-header-face-1                    (:foreground zy-bright_blue :weight 'bold))
     (markdown-header-face-2                    (:foreground zy-bright_yellow :weight 'bold))
     (markdown-header-face-3                    (:foreground zy-bright_purple :weight 'bold))
     (markdown-header-face-4                    (:foreground zy-bright_red :weight 'bold))
     (markdown-header-face-5                    (:foreground zy-bright_green :weight 'bold))
     (markdown-header-face-6                    (:foreground zy-bright_aqua :weight 'bold))

     ;; anzu-mode
     (anzu-mode-line                            (:foreground zy-bright_yellow :weight 'bold))
     (anzu-match-1                              (:background zy-bright_green))
     (anzu-match-2                              (:background zy-faded_yellow))
     (anzu-match-3                              (:background zy-aquamarine4))
     (anzu-replace-to                           (:foreground zy-bright_yellow))
     (anzu-replace-highlight                    (:inherit 'isearch))

     ;; ace-jump-mode
     (ace-jump-face-background                  (:foreground zy-light4 :background zy-bg :inverse-video nil))
     (ace-jump-face-foreground                  (:foreground zy-bright_red :background zy-bg :inverse-video nil))

     ;; ace-window
     (aw-background-face                        (:forground  zy-light1 :background zy-bg :inverse-video nil))
     (aw-leading-char-face                      (:foreground zy-bright_red :background zy-bg :height 4.0))

     ;; show-paren
     (show-paren-match                          (:background zy-dark3 :foreground zy-bright_blue  :weight 'bold))
     (show-paren-mismatch                       (:background zy-bright_red :foreground zy-dark3 :weight 'bold))

     ;; ivy
     (ivy-current-match                         (:background zy-dark3 :weight 'bold :distant-foreground nil))
     (ivy-minibuffer-match-face-1               (:foreground zy-light0))
     (ivy-minibuffer-match-face-2               (:foreground zy-light0 :background zy-bright_purple :weight 'semi-bold))
     (ivy-minibuffer-match-face-3               (:foreground zy-light0 :background zy-bright_green :weight 'semi-bold))
     (ivy-minibuffer-match-face-4               (:foreground zy-light0 :background zy-bright_orange :weight 'semi-bold))

     ;; ido
     (ido-only-match                            (:foreground zy-faded_green))
     (ido-subdir                                (:foreground zy-faded_red))

     ;; magit
     (magit-bisect-bad                          (:foreground zy-faded_red))
     (magit-bisect-good                         (:foreground zy-faded_green))
     (magit-bisect-skip                         (:foreground zy-faded_yellow))
     (magit-blame-heading                       (:foreground zy-light0 :background zy-dark2))
     (magit-branch-local                        (:foreground zy-bright_blue))
     (magit-branch-current                      (:underline zy-bright_blue :inherit 'magit-branch-local))
     (magit-branch-remote                       (:foreground zy-bright_green))
     (magit-cherry-equivalent                   (:foreground zy-bright_purple))
     (magit-cherry-unmatched                    (:foreground zy-bright_aqua))
     (magit-diff-added                          (:foreground zy-bright_green))
     (magit-diff-added-highlight                (:foreground zy-bright_green :inherit 'magit-diff-context-highlight))
     (magit-diff-base                           (:background zy-faded_yellow :foreground zy-light2))
     (magit-diff-base-highlight                 (:background zy-faded_yellow :foreground zy-light0))
     (magit-diff-context                        (:foreground zy-dark1  :foreground zy-light1))
     (magit-diff-context-highlight              (:background zy-dark1 :foreground zy-light0))
     (magit-diff-hunk-heading                   (:background zy-dark3 :foreground zy-light2))
     (magit-diff-hunk-heading-highlight         (:background zy-dark2 :foreground zy-light0))
     (magit-diff-hunk-heading-selection         (:background zy-dark2 :foreground zy-bright_orange))
     (magit-diff-lines-heading                  (:background zy-faded_orange :foreground zy-light0))
     (magit-diff-removed                        (:foreground zy-bright_red))
     (magit-diff-removed-highlight              (:foreground zy-bright_red :inherit 'magit-diff-context-highlight))
     (magit-diffstat-added                      (:foreground zy-faded_green))
     (magit-diffstat-removed                    (:foreground zy-faded_red))
     (magit-dimmed                              (:foreground zy-dark4))
     (magit-hash                                (:foreground zy-bright_blue))
     (magit-log-author                          (:foreground zy-bright_red))
     (magit-log-date                            (:foreground zy-bright_aqua))
     (magit-log-graph                           (:foreground zy-dark4))
     (magit-process-ng                          (:foreground zy-bright_red :weight 'bold))
     (magit-process-ok                          (:foreground zy-bright_green :weight 'bold))
     (magit-reflog-amend                        (:foreground zy-bright_purple))
     (magit-reflog-checkout                     (:foreground zy-bright_blue))
     (magit-reflog-cherry-pick                  (:foreground zy-bright_green))
     (magit-reflog-commit                       (:foreground zy-bright_green))
     (magit-reflog-merge                        (:foreground zy-bright_green))
     (magit-reflog-other                        (:foreground zy-bright_aqua))
     (magit-reflog-rebase                       (:foreground zy-bright_purple))
     (magit-reflog-remote                       (:foreground zy-bright_blue))
     (magit-reflog-reset                        (:foreground zy-bright_red))
     (magit-refname                             (:foreground zy-light4))
     (magit-section-heading                     (:foreground zy-bright_yellow :weight 'bold))
     (magit-section-heading-selection           (:foreground zy-faded_yellow))
     (magit-section-highlight                   (:background zy-dark1))
     (magit-sequence-drop                       (:foreground zy-faded_yellow))
     (magit-sequence-head                       (:foreground zy-bright_aqua))
     (magit-sequence-part                       (:foreground zy-bright_yellow))
     (magit-sequence-stop                       (:foreground zy-bright_green))
     (magit-signature-bad                       (:foreground zy-bright_red :weight 'bold))
     (magit-signature-error                     (:foreground zy-bright_red))
     (magit-signature-expired                   (:foreground zy-bright_orange))
     (magit-signature-good                      (:foreground zy-bright_green))
     (magit-signature-revoked                   (:foreground zy-bright_purple))
     (magit-signature-untrusted                 (:foreground zy-bright_blue))
     (magit-tag                                 (:foreground zy-bright_yellow))

     ;; flyspell
     (flyspell-duplicate                        (:underline (:color zy-light4 :style 'line)))
     (flyspell-incorrect                        (:underline (:color zy-bright_red :style 'line)))

     ;; langtool
     (langtool-errline                          (:foreground zy-dark0 :background zy-bright_red))
     (langtool-correction-face                  (:foreground zy-bright_yellow :weight 'bold))

     ;; latex
     (font-latex-bold-face                      (:foreground zy-faded_green :bold t))
     (font-latex-italic-face                    (:foreground zy-bright_green :underline t))
     (font-latex-math-face                      (:foreground zy-light3))
     (font-latex-script-char-face               (:foreground zy-faded_aqua))
     (font-latex-sectioning-5-face              (:foreground zy-bright_yellow :bold t))
     (font-latex-sedate-face                    (:foreground zy-light4))
     (font-latex-string-face                    (:foreground zy-bright_orange))
     (font-latex-verbatim-face                  (:foreground zy-light4))
     (font-latex-warning-face                   (:foreground zy-bright_red :weight 'bold))
     (preview-face                              (:background zy-dark1))

     ;; mu4e
     (mu4e-header-key-face                      (:foreground zy-bright_green :weight 'bold ))
     (mu4e-unread-face                          (:foreground zy-bright_blue :weight 'bold ))
     (mu4e-highlight-face                       (:foreground zy-bright_green))

     ;; shell script
     (sh-quoted-exec                            (:foreground zy-bright_purple))
     (sh-heredoc                                (:foreground zy-bright_orange))

     ;; undo-tree
     (undo-tree-visualizer-active-branch-face   (:foreground zy-light0))
     (undo-tree-visualizer-current-face         (:foreground zy-bright_red))
     (undo-tree-visualizer-default-face         (:foreground zy-dark4))
     (undo-tree-visualizer-register-face        (:foreground zy-bright_yellow))
     (undo-tree-visualizer-unmodified-face      (:foreground zy-bright_aqua))

     ;; widget faces
     (widget-button-pressed-face                (:foreground zy-bright_red))
     (widget-documentation-face                 (:foreground zy-faded_green))
     (widget-field                              (:foreground zy-light0 :background zy-dark2))
     (widget-single-line-field                  (:foreground zy-light0 :background zy-dark2))

     ;; dired+
     (diredp-file-name                          (:foreground zy-light2))
     (diredp-file-suffix                        (:foreground zy-light4))
     (diredp-compressed-file-suffix             (:foreground zy-faded_blue))
     (diredp-dir-name                           (:foreground zy-faded_blue))
     (diredp-dir-heading                        (:foreground zy-bright_blue))
     (diredp-symlink                            (:foreground zy-bright_orange))
     (diredp-date-time                          (:foreground zy-light3))
     (diredp-number                             (:foreground zy-faded_blue))
     (diredp-no-priv                            (:foreground zy-dark4))
     (diredp-other-priv                         (:foreground zy-dark2))
     (diredp-rare-priv                          (:foreground zy-dark4))
     (diredp-ignored-file-name                  (:foreground zy-dark4))

     (diredp-dir-priv                           (:foreground zy-faded_blue  :background zy-dark_blue))
     (diredp-exec-priv                          (:foreground zy-faded_blue  :background zy-dark_blue))
     (diredp-link-priv                          (:foreground zy-faded_aqua  :background zy-dark_aqua))
     (diredp-read-priv                          (:foreground zy-bright_red  :background zy-dark_red))
     (diredp-write-priv                         (:foreground zy-bright_aqua :background zy-dark_aqua))

     ;; eshell
     (eshell-prompt-face                         (:foreground zy-bright_aqua))
     (eshell-ls-archive-face                     (:foreground zy-light3))
     (eshell-ls-backup-face                      (:foreground zy-light4))
     (eshell-ls-clutter-face                     (:foreground zy-bright_orange :weight 'bold))
     (eshell-ls-directory-face                   (:foreground zy-bright_yellow))
     (eshell-ls-executable-face                  (:weight 'bold))
     (eshell-ls-missing-face                     (:foreground zy-bright_red :bold t))
     (eshell-ls-product-face                     (:foreground zy-faded_red))
     (eshell-ls-readonly-face                    (:foreground zy-light2))
     (eshell-ls-special-face                     (:foreground zy-bright_yellow :bold t))
     (eshell-ls-symlink-face                     (:foreground zy-bright_red))
     (eshell-ls-unreadable-face                  (:foreground zy-bright_red :bold t))

     ;; which-function-mode
     (which-func                                 (:foreground zy-bright_yellow :bold t)))
    ,@body))

;;; dark
(zy-deftheme
 zy-dark
 "A retro-groove colour theme (dark version, medium contrast)"

 ((((class color) (min-colors #xFFFFFF))        ; col 1 GUI/24bit
   ((class color) (min-colors #xFF)))           ; col 2 Xterm/256

  (zy-dark0_hard      "#1d2021" "#1c1c1c")
  (zy-dark0           "#282828" "#262626")
  (zy-dark0_soft      "#32302f" "#303030")
  (zy-dark1           "#3c3836" "#3a3a3a")
  (zy-dark2           "#504945" "#4e4e4e")
  (zy-dark3           "#665c54" "#626262")
  (zy-dark4           "#7c6f64" "#767676")

  (zy-gray            "#928374" "#8a8a8a")

  (zy-light0_hard     "#ffffc8" "#ffffd7")
  (zy-light0          "#fdf4c1" "#ffffaf")
  (zy-light0_soft     "#f4e8ba" "#ffffaf")
  (zy-light1          "#ebdbb2" "#ffdfaf")
  (zy-light2          "#d5c4a1" "#bcbcbc")
  (zy-light3          "#bdae93" "#a8a8a8")
  (zy-light4          "#a89984" "#949494")

  (zy-bright_red      "#fb4933" "#d75f5f")
  (zy-bright_green    "#b8bb26" "#afaf00")
  (zy-bright_yellow   "#fabd2f" "#ffaf00")
  (zy-bright_blue     "#83a598" "#87afaf")
  (zy-bright_purple   "#d3869b" "#d787af")
  (zy-bright_aqua     "#8ec07c" "#87af87")
  (zy-bright_orange   "#fe8019" "#ff8700")

  (zy-faded_red       "#cc241d" "#d75f5f")
  (zy-faded_green     "#98971a" "#afaf00")
  (zy-faded_yellow    "#d79921" "#ffaf00")
  (zy-faded_blue      "#458588" "#87afaf")
  (zy-faded_purple    "#b16286" "#d787af")
  (zy-faded_aqua      "#689d6a" "#87af87")
  (zy-faded_orange    "#d65d0e" "#ff8700")

  (zy-dark_red        "#421E1E" "#5f0000")
  (zy-dark_blue       "#2B3C44" "#000087")
  (zy-dark_aqua       "#36473A" "#005f5f")

  (zy-delimiter-one   "#458588" "#008787")
  (zy-delimiter-two   "#b16286" "#d75f87")
  (zy-delimiter-three "#8ec07c" "#87af87")
  (zy-delimiter-four  "#d65d0e" "#d75f00")
  (zy-white           "#FFFFFF" "#FFFFFF")
  (zy-black           "#000000" "#000000")
  (zy-sienna          "#DD6F48" "#d7875f")
  (zy-darkslategray4  "#528B8B" "#5f8787")
  (zy-lightblue4      "#66999D" "#5fafaf")
  (zy-burlywood4      "#BBAA97" "#afaf87")
  (zy-aquamarine4     "#83A598" "#87af87")
  (zy-turquoise4      "#61ACBB" "#5fafaf")

  (zy-bg zy-dark0))

 (custom-theme-set-variables 'zy-dark
                             `(ansi-color-names-vector
                               [,zy-dark1
                                ,zy-bright_red
                                ,zy-bright_green
                                ,zy-bright_yellow
                                ,zy-bright_blue
                                ,zy-bright_purple
                                ,zy-bright_aqua
                                ,zy-light1])))

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'zy-dark)

(provide 'zy-dark-theme)

;; Local Variables:
;; eval: (when (fboundp 'rainbow-mode) (rainbow-mode +1))
;; End:

;;; zy-theme.el ends here