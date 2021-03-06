(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "https://marmalade-repo.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))
(package-initialize)

(require 'solarized-dark-theme)

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(tabbar-background-color "gray5")
 '(tabbar-mode t nil (tabbar))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(tabbar-button ((t nil)))
 '(tabbar-button-highlight ((t nil)))
 '(tabbar-highlight ((t nil))))

(global-set-key (kbd "C-M-<next>") 'next-buffer)
(global-set-key (kbd "C-M-<prior>") 'previous-buffer)
(global-unset-key (kbd "C-x C-c"))

(setq line-number-display-limit-width 2000000)

(eval-after-load "sql"
  '(load-library "sql-indent"))

(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))

(setq yaml-indent-offset 4)
