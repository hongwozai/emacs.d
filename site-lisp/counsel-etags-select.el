;;; counsel-etags-select.el --- Select from multiple tags

;; Copyright (C) 2007  Scott Frazer -> 2018 ZeyaLu

;; Author: Scott Frazer <frazer.scott@gmail.com>
;; Maintainer: Scott Frazer <frazer.scott@gmail.com>
;; Created: 07 Jun 2007
;; Version: 1.13
;; Package-Version: 20130824.500
;; Keywords: etags tags tag select

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Open a buffer with file/lines of exact-match tags shown.  Select one by
;; going to a line and pressing return.  pop-tag-mark still works with this
;; code.
;;
;; If there is only one match, you can skip opening the selection window by
;; setting a custom variable.  This means you could substitute the key binding
;; for find-tag-at-point with counsel-etags-select-find-tag-at-point, although it
;; won't play well with tags-loop-continue.  On the other hand, if you like
;; the behavior of tags-loop-continue you probably don't need this code.
;;
;; I use this:
;; (global-set-key "\M-?" 'counsel-etags-select-find-tag-at-point)
;; (global-set-key "\M-." 'counsel-etags-select-find-tag)
;;
;; Contributers of ideas and/or code:
;; David Engster
;; James Ferguson
;;
;;; Change log:
;;
;; 10 May 2018 -- v2.0
;;                use ivy-read.
;;
;; 28 Oct 2008 -- v1.13
;;                Add short tag name completion option
;;                Add go-if-tagnum-is-unambiguous option
;; 13 May 2008 -- v1.12
;;                Fix completion bug for XEmacs etags
;;                Add highlighting of tag after jump
;; 28 Apr 2008 -- v1.11
;;                Add tag completion
;; 25 Sep 2007 -- v1.10
;;                Fix save window layout bug
;; 25 Sep 2007 -- v1.9
;;                Add function to prompt for tag to find (instead of using
;;                what is at point)
;; 25 Sep 2007 -- v1.8
;;                Don't mess up user's window layout.
;;                Add function/binding to go to the tag in other window.
;; 10 Sep 2007 -- v1.7
;;                Disambiguate tags with matching suffixes
;; 04 Sep 2007 -- v1.6
;;                Speed up tag searching
;; 27 Jul 2007 -- v1.5
;;                Respect case-fold-search and tags-case-fold-search
;; 24 Jul 2007 -- v1.4
;;                Fix filenames for tag files with absolute paths
;; 24 Jul 2007 -- v1.3
;;                Handle qualified and implicit tags.
;;                Add tag name to display.
;;                Add tag numbers so you can jump directly to one.
;; 13 Jun 2007 -- v1.2
;;                Need to regexp-quote the searched-for string.

;;; Code:

(require 'custom)
(require 'etags)
(require 'find-file-in-project)

;;; Custom stuff

;;;###autoload
(defcustom counsel-etags-select-no-select-for-one-match t
  "*If non-nil, don't open the selection window if there is only one
matching tag."
  :group 'etags-select-mode
  :type 'boolean)

;;;###autoload
(defcustom counsel-etags-select-highlight-tag-after-jump t
  "*If non-nil, temporarily highlight the tag after you jump to it."
  :group 'etags-select-mode
  :type 'boolean)

;;;###autoload
(defcustom counsel-etags-select-highlight-delay 1.0
  "*How long to highlight the tag."
  :group 'etags-select-mode
  :type 'number)

;;;###autoload
(defface counsel-etags-select-highlight-tag-face
  '((t (:foreground "white" :background "cadetblue4" :bold t)))
  "Font Lock mode face used to highlight tags."
  :group 'etags-select-mode)

;;;###autoload
(defcustom counsel-etags-select-use-short-name-completion nil
  "*Use short tag names during completion.  For example, say you
have a function named foobar in several classes and you invoke
`counsel-etags-select-find-tag'.  If this variable is nil, you would have
to type ClassA::foo<TAB> to start completion.  Since avoiding
knowing which class a function is in is the basic idea of this
package, if you set this to t you can just type foo<TAB>.

Only works with GNU Emacs."
  :group 'etags-select-mode
  :type 'boolean)

 ;;; Variables
(defvar counsel-etags-select-source-buffer nil
  "etags-select source buffer tag was found from.")

(defvar counsel-etags-select-opened-window nil
  "etags-select opened a select window.")

(defconst counsel-etags-select-non-tag-regexp "\\(\\s-*$\\|In:\\|Finding tag:\\)"
  "etags-select non-tag regex.")

(defvar counsel-etags-select--temp-tagname nil)

;;; Functions
(if (string-match "XEmacs" emacs-version)
    (fset 'etags-select-match-string 'match-string)
  (fset 'etags-select-match-string 'match-string-no-properties))

;; I use Emacs, but with a hacked version of XEmacs' etags.el, thus this variable

(defvar counsel-etags-select--use-xemacs-etags-p (fboundp 'get-tag-table-buffer)
  "Use XEmacs etags?")

(defun counsel-etags-select--case-fold-search ()
  "Get case-fold search."
  (when (boundp 'tags-case-fold-search)
    (if (memq tags-case-fold-search '(nil t))
        tags-case-fold-search
      case-fold-search)))

(defun counsel-etags-select--find-matches (tagname tag-file)
  "Insert matches to tagname in tag-file."
  (let ((tag-table-buffer (counsel-etags-select--get-tag-table-buffer tag-file))
        (tag-file-path (file-name-directory tag-file))
        (tag-regex (concat "^.*?\\(" "\^?\\(.+[:.']" tagname "\\)\^A"
                           "\\|" "\^?" tagname "\^A"
                           "\\|" "\\<" tagname "[ \f\t()=,;]*\^?[0-9,]"
                           "\\)"))
        (case-fold-search (counsel-etags-select--case-fold-search))
        full-tagname tag-line filename current-filename tag-lineno
        matches match)
    (set-buffer tag-table-buffer)
    (modify-syntax-entry ?_ "w")
    (goto-char (point-min))
    (while (search-forward tagname nil t)
      (beginning-of-line)
      (when (re-search-forward tag-regex (point-at-eol) 'goto-eol)
        (setq full-tagname (or (etags-select-match-string 2) tagname))
        (beginning-of-line)
        (re-search-forward "\\s-*\\(.*?\\)\\s-*\^?.*?\^A?\\([0-9]+?\\),")
        (setq tag-line (etags-select-match-string 1))
        (setq tag-lineno (etags-select-match-string 2))
        (end-of-line)
        (save-excursion
          (re-search-backward "\f")
          (re-search-forward "^\\(.*?\\),")
          (setq filename (etags-select-match-string 1))
          (unless (file-name-absolute-p filename)
            (setq filename (concat tag-file-path filename))))
        (modify-syntax-entry ?_ "_")
        (save-excursion
          (when (not (string= filename current-filename))
            (setq current-filename filename))
          (setq match
                (concat current-filename ":" tag-lineno ":" tag-line)))
        (push match matches)))
    matches))

(defun counsel-etags-select--get-tag-table-buffer (tag-file)
  "Get tag table buffer for a tag file."
  (if counsel-etags-select--use-xemacs-etags-p
      (get-tag-table-buffer tag-file)
    (visit-tags-table-buffer tag-file)
    (get-file-buffer tag-file)))

(defun counsel-etags-select--complete-tag (string predicate what)
  "Tag completion."
  (counsel-etags-select--build-completion-table)
  (if (eq what t)
      (all-completions string (counsel-etags-select--get-completion-table) predicate)
    (try-completion string (counsel-etags-select--get-completion-table) predicate)))

(defun counsel-etags-select--build-completion-table ()
  "Build tag completion table."
  (save-excursion
    (set-buffer counsel-etags-select-source-buffer)
    (let ((tag-files (counsel-etags-select--get-tag-files)))
      (mapcar (lambda (tag-file) (counsel-etags-select--get-tag-table-buffer tag-file)) tag-files))))

(defun counsel-etags-select--get-tag-files ()
  "Get tag files."
  (if counsel-etags-select--use-xemacs-etags-p
      (buffer-tag-table-list)
    (mapcar 'tags-expand-table-name tags-table-list)))

(defun counsel-etags-select--get-completion-table ()
  "Get the tag completion table."
  (if counsel-etags-select--use-xemacs-etags-p
      tag-completion-table
    (tags-completion-table)))

(defun counsel-etags-select--tags-completion-table-function ()
  "Short tag name completion."
  (let ((table (make-vector 16383 0))
        (tag-regex "^.*?\\(\^?\\(.+\\)\^A\\|\\<\\(.+\\)[ \f\t()=,;]*\^?[0-9,]\\)")
        (progress-reporter
         (make-progress-reporter
          (format "Making tags completion table for %s..." buffer-file-name)
          (point-min) (point-max))))
    (save-excursion
      (goto-char (point-min))
      (while (not (eobp))
        (when (looking-at tag-regex)
          (intern (replace-regexp-in-string ".*[:.']" "" (or (match-string 2) (match-string 3))) table))
        (forward-line 1)
        (progress-reporter-update progress-reporter (point))))
    table))

(unless counsel-etags-select--use-xemacs-etags-p
  (defadvice etags-recognize-tags-table (after etags-select-short-name-completion activate)
    "Turn on short tag name completion (maybe)"
    (when counsel-etags-select-use-short-name-completion
      (setq tags-completion-table-function 'counsel-etags-select--tags-completion-table-function))))

(defun counsel-etags-select--find-etags-action (x)
  "Go to occurrence X in tags source file."
  (when (string-match "\\`\\(.*?\\):\\([0-9]+\\):\\(.*\\)\\'" x)
    (let ((file-name (match-string-no-properties 1 x))
          (line-number (match-string-no-properties 2 x))
          (match-string (match-string-no-properties 3 x)))
      (find-file (expand-file-name
                  file-name
                  (ivy-state-directory ivy-last)))
      (goto-char (point-min))
      (forward-line (1- (string-to-number line-number)))
      (when (re-search-forward counsel-etags-select--temp-tagname
                               (line-end-position)
                               t)
        (goto-char (match-beginning 0))
        (when counsel-etags-select-highlight-tag-after-jump
          (counsel-etags-select--highlight
           (match-beginning 0) (match-end 0))))
      (swiper--ensure-visible)
      (run-hooks 'counsel-grep-post-action-hook)
      (unless (eq ivy-exit 'done)
        (swiper--cleanup)
        (swiper--add-overlays (ivy--regex ivy-text))))))

(defun counsel-etags-select--find (tagname)
  "Core tag finding function."
  (let ((tag-files (counsel-etags-select--get-tag-files))
        (tag-count 0)
        result-list
        result-len)
    (setq counsel-etags-select-source-buffer (buffer-name))
    (setq buffer-read-only nil)
    (dolist (tag-file tag-files)
      (setq result-list
            (concatenate
             'list
             result-list
             (counsel-etags-select--find-matches tagname tag-file))))
    (switch-to-buffer counsel-etags-select-source-buffer)
    (if counsel-etags-select--use-xemacs-etags-p
        (push-tag-mark)
        (ring-insert find-tag-marker-ring (point-marker)))
    (ivy-set-display-transformer 'counsel-etags-select--find
                                 'counsel-git-grep-transformer)
    (setq result-len (length result-list))
    (setq counsel-etags-select--temp-tagname tagname)
    (cond ((= result-len 0)
           (ding)
           (error (concat "No matches for tag \"" tagname "\"")))
          ((= result-len 1)
           (counsel-etags-select--find-etags-action (nth 0 result-list)))
          (t (ivy-read (format "Finding tag at %s: " tagname)
                       result-list
                       :action #'counsel-etags-select--find-etags-action
                       :caller 'counsel-etags-select--find)))
    ))

(defun counsel-etags-select--highlight (beg end)
  "Highlight a region temporarily."
  (if (featurep 'xemacs)
      (let ((extent (make-extent beg end)))
        (set-extent-property extent 'face 'counsel-etags-select-highlight-tag-face)
        (sit-for counsel-etags-select-highlight-delay)
        (delete-extent extent))
    (let ((ov (make-overlay beg end)))
      (overlay-put ov 'face 'counsel-etags-select-highlight-tag-face)
      (sit-for counsel-etags-select-highlight-delay)
      (delete-overlay ov))))

(defun counsel-etags-select--default-directory ()
  (if (featurep 'find-file-in-project)
      (file-name-as-directory
       (or (condition-case nil
               (ffip-project-root)
             (wrong-type-argument nil))
           default-directory))
    (file-name-as-directory default-directory)))

;;;###autoload
(defun counsel-etags-select-find-tag-at-point ()
  "Do a find-tag-at-point, and display all exact matches.  If only one match is
found, see the `counsel-etags-select-no-select-for-one-match' variable to decide what
to do."
  (interactive)
  (let (havetag)
   (if (eq tags-file-name nil)
       (counsel-etags-select-visit-tag-table)
     (setq havetag
           (every (lambda (x)
                    (string-match (file-name-directory (expand-file-name x))
                                  (expand-file-name default-directory)))
                  (counsel-etags-select--get-tag-files))))
   (if (not havetag)
       (counsel-etags-select-visit-tag-table))
   (counsel-etags-select--find (find-tag-default))))

;;;###autoload
(defun counsel-etags-select-find-tag ()
  "Do a find-tag, and display all exact matches.  If only one match is
found, see the `counsel-etags-select-no-select-for-one-match' variable to decide what
to do."
  (interactive)
  (setq counsel-etags-select-source-buffer (buffer-name))
  (let* ((default (find-tag-default))
         (tagname (completing-read
                   (format "Find tag (default %s): " default)
                   'counsel-etags-select--complete-tag nil nil nil 'find-tag-history default)))
    (counsel-etags-select--find tagname)))

;;;###autoload
(defun counsel-etags-select-visit-tag-table ()
  (interactive)
  (let ((filename (concat (counsel-etags-select--default-directory) "TAGS")))
    (if (file-exists-p filename)
        (visit-tags-table filename t)
      (call-interactively #'visit-tags-table))))

;;;###autoload
(defun counsel-etags-select-generate-etags (dir)
  (interactive
   (list (read-directory-name "Directory: "
                              (counsel-etags-select--default-directory))))
  (let* ((delpath (format "\\( -path '*%s/.*/*' -o -path '*/*TAGS' \\)"
                          dir))
         (curpath (concat (file-name-as-directory dir) "TAGS"))
         (ctags-version (shell-command-to-string "ctags --version"))
         (tags-program (if (executable-find "ctags-exuberant")
                           "ctags-exuberant -e -L - --langmap=c++:.h"
                         (cond
                           ((string-match "[Ee]xuberant" ctags-version)
                            "ctags -e -L - ")
                           ((string-match "command not found" ctags-version)
                            "etags - ")
                           (t (error "No Tags Program(ctags|etags|ctags-exuberant)")))))
         (initial-value
          (format "find %s -type f -a -not %s | %s -o %s"
                  dir
                  delpath
                  tags-program
                  curpath))
         (shell (read-shell-command "Command: " initial-value))
         (retstr (shell-command-to-string shell)))
    (if (string-equal retstr "")
        (progn
          (visit-tags-table curpath)
          (message "Successful Generate TAGS at %s" curpath))
      (message "ERROR: %s" retstr))))

;;; find visit generate
(provide 'counsel-etags-select)
;;; counsel-etags-select.el ends here
