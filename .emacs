(prefer-coding-system 'utf-8)
;; melpa
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("elpa" . "https://elpa.org/packages/") t)
;; (cua-mode t)
;; (setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode 1) ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(setq inhibit-startup-screen t)

(global-set-key [67108909] (quote undo))
(global-set-key [67108910] (quote repeat-complex-command))

(defun allpasswds ()
  "load encrypted allpasswds file"
  (interactive)
  (if (memq system-type '(windows-nt ms-dos))
      (find-file "//wd/RTL9210B-CG-2/Dokumente/passworte/allpasswds.gpg" t)
    (find-file "/home/konrad/Dokumente/allpasswds.gpg" t))
  )

(defun emacsinit ()
  "load emacs init file on nas"
  (interactive)
  (if (memq system-type '(windows-nt ms-dos))
      (find-file "//wd/RTL9210B-CG-2/Dokumente/scripts/emacsinit.el" t)
    (find-file "/mnt/wd/RTL9210B-CG-2/Dokumente/scripts/emacsinit.el" t))
  )
"//wd/RTL9210B-CG-2/Dokumente/scripts/emacsinit.el"

(defun format-wikifolio-quote-csv-for-google-documents ()
  "reformat csv format of wikifolio kontoauszug, to open with
 google documents import. instruction: 1. download kursdaten, open with librecalc 2. copy paste to emacs buffer wikifolio 3. execute this command"
  (interactive)
  (replace-regexp "^\\([0-9][0-9]\\).\\([0-9][0-9]\\).\\([0-9][0-9][0-9][0-9]\\)" "\\2/\\1/\\3" nil (point-min) (point-max))
  ;; (replace-regexp "^\\(.*\\) \\(.*\\)\t\\(.*\\)\t\\(.*\\)\t\\(.*\\),\\(.*\\)\t\\(.*\\)\t\\(.*\\)" "\\1\t\\5.\\6" nil (point-min) (point-max))
  (replace-regexp "^\\(.*\\) \\(.*\\)	\\(.*\\)	\\(.*\\)	\\(.*\\),\\(.*\\)	\\(.*\\)	\\(.*\\)" "\\1\t\\5.\\6" nil (point-min) (point-max))
)

(defun format-deutscheam-quote-csv-for-google-documents ()
  "reformat csv format of deutscheam.com historical data date nav to open with
 google documents import. Then appends quotes to buffer wikifolio assuming wikifolio
 quotes in buffer wikifolio. This defun can be executed twice with different etf quotes."
  (interactive)
  ;; replace Date to US Date
  (replace-regexp "^\\(..\\).\\(..\\).\\(....\\)" "\\2/\\1/\\3" nil (point-min) (point-max))
  ;; replace number to US format
  (subst-char-in-region (point-min) (point-max) ?, ?.)
  (goto-char (point-min))
  (search-forward "Date\tNAV\n")
  ;; while looking at Date
  (while (looking-at "[0-9][0-9]/[0-9][0-9]/[0-9][0-9][0-9][0-9]")
    (let ((date (buffer-substring (point) (+ (point) 10)))
	  ;; Date string
	(quote (buffer-substring (+ (point) 11) (+ (point) 16))))
      ;; quote string
	(message "date %s quote %s" date quote)
	(append-search-text-to-buffer "wikifolio" date quote))
    (forward-line))
)

(defun append-search-text-to-buffer (buffer search-text text-to-append)
  "Search for search-text in specified buffer and append text-to-append at end of line"
  (interactive "BAppend to buffer: \nssearch text: \nstext to append")
  (let ((oldbuf (current-buffer)))
    (save-current-buffer
      (set-buffer (get-buffer buffer))
      (goto-char (point-min))
      (if (search-forward search-text nil t)
	  (progn 
	    (end-of-line)
	    (insert (concat "\t" text-to-append)))
	(message "Search returned false: text:%s" search-text))))

)

(defun format-yahoo-quote-csv-for-gnumeric ()
  "reformat csv format of yahoo finance historical prices, to open with
 gnumeric text import."
  (interactive)
  (replace-string "," ";" nil (point-min) (point-max))
  (replace-string "." "," nil (point-min) (point-max))
  (goto-char (point-min))
  (forward-line 1)
  (sort-lines nil (point) (point-max))
)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(csv-separators '(","))
 '(delete-old-versions t)
 '(diff-command "c:/program files/git/usr/bin/diff.exe")
 '(dired-guess-shell-alist-user
   '(("\\.pdf'" "C:\\Program Files\\BraveSoftware\\Brave-Browser\\Application\\brave.exe")))
 '(file-coding-system-alist
   '(("internet-access\\.gpg" . utf-8)
     ("\\.dz\\'" no-conversion . no-conversion)
     ("\\.xz\\'" no-conversion . no-conversion)
     ("\\.lzma\\'" no-conversion . no-conversion)
     ("\\.lz\\'" no-conversion . no-conversion)
     ("\\.g?z\\'" no-conversion . no-conversion)
     ("\\.\\(?:tgz\\|svgz\\|sifz\\)\\'" no-conversion . no-conversion)
     ("\\.tbz2?\\'" no-conversion . no-conversion)
     ("\\.bz2\\'" no-conversion . no-conversion)
     ("\\.Z\\'" no-conversion . no-conversion)
     ("\\.elc\\'" . utf-8-emacs)
     ("\\.utf\\(-8\\)?\\'" . utf-8)
     ("\\.xml\\'" . xml-find-file-coding-system)
     ("\\(\\`\\|/\\)loaddefs.el\\'" raw-text . raw-text-unix)
     ("\\.tar\\'" no-conversion . no-conversion)
     ("\\.po[tx]?\\'\\|\\.po\\." . po-find-file-coding-system)
     ("\\.\\(tex\\|ltx\\|dtx\\|drv\\)\\'" . latexenc-find-file-coding-system)
     ("" . find-buffer-file-type-coding-system)))
 '(package-selected-packages '(corfu magit csv-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Code" :foundry "outline" :slant normal :weight normal :height 120 :width normal)))))
(put 'upcase-region 'disabled nil)

; make backups only for files already have one
;(setq version-control t)


(defun filter-monthly-from-daily-quotes-ariva ()
  (interactive)
  ;; delete days 05...09
  (delete-matching-lines "^....-..-0[56789]" (point-min) (point-max))
  ;; delete days 1x 2x 3x
  (delete-matching-lines "^....-..-[123]" (point-min) (point-max))
  ;; remove line with day 02 if the next line has day 01
  ;; have to repeat it for all 12 months bc dont't compare different months
  (replace-regexp "^\\(....-01-02.*\\)\n\\(....-01-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-02.*\\)\n\\(....-02-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-02.*\\)\n\\(....-03-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-02.*\\)\n\\(....-04-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-02.*\\)\n\\(....-05-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-02.*\\)\n\\(....-06-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-02.*\\)\n\\(....-07-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-02.*\\)\n\\(....-08-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-02.*\\)\n\\(....-09-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-02.*\\)\n\\(....-10-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-02.*\\)\n\\(....-11-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-02.*\\)\n\\(....-12-01.*\\)" "\\2" nil (point-min) (point-max))
  ;;(replace-regexp "^\\(....-..-03.*\\)\n\\(....-..-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-01-03.*\\)\n\\(....-01-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-03.*\\)\n\\(....-02-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-03.*\\)\n\\(....-03-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-03.*\\)\n\\(....-04-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-03.*\\)\n\\(....-05-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-03.*\\)\n\\(....-06-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-03.*\\)\n\\(....-07-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-03.*\\)\n\\(....-08-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-03.*\\)\n\\(....-09-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-03.*\\)\n\\(....-10-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-03.*\\)\n\\(....-11-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-03.*\\)\n\\(....-12-01.*\\)" "\\2" nil (point-min) (point-max))
  ;;(replace-regexp "^\\(....-..-04.*\\)\n\\(....-..-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-01-04.*\\)\n\\(....-01-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-04.*\\)\n\\(....-02-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-04.*\\)\n\\(....-03-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-04.*\\)\n\\(....-04-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-04.*\\)\n\\(....-05-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-04.*\\)\n\\(....-06-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-04.*\\)\n\\(....-07-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-04.*\\)\n\\(....-08-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-04.*\\)\n\\(....-09-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-04.*\\)\n\\(....-10-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-04.*\\)\n\\(....-11-01.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-04.*\\)\n\\(....-12-01.*\\)" "\\2" nil (point-min) (point-max))
  ;;(replace-regexp "^\\(....-..-03.*\\)\n\\(....-..-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-01-03.*\\)\n\\(....-01-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-03.*\\)\n\\(....-02-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-03.*\\)\n\\(....-03-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-03.*\\)\n\\(....-04-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-03.*\\)\n\\(....-05-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-03.*\\)\n\\(....-06-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-03.*\\)\n\\(....-07-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-03.*\\)\n\\(....-08-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-03.*\\)\n\\(....-09-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-03.*\\)\n\\(....-10-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-03.*\\)\n\\(....-11-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-03.*\\)\n\\(....-12-02.*\\)" "\\2" nil (point-min) (point-max))
  ;;(replace-regexp "^\\(....-..-04.*\\)\n\\(....-..-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-01-04.*\\)\n\\(....-01-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-04.*\\)\n\\(....-02-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-04.*\\)\n\\(....-03-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-04.*\\)\n\\(....-04-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-04.*\\)\n\\(....-05-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-04.*\\)\n\\(....-06-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-04.*\\)\n\\(....-07-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-04.*\\)\n\\(....-08-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-04.*\\)\n\\(....-09-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-04.*\\)\n\\(....-10-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-04.*\\)\n\\(....-11-02.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-04.*\\)\n\\(....-12-02.*\\)" "\\2" nil (point-min) (point-max))
  ;;(replace-regexp "^\\(....-..-04.*\\)\n\\(....-..-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-01-04.*\\)\n\\(....-01-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-02-04.*\\)\n\\(....-02-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-03-04.*\\)\n\\(....-03-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-04-04.*\\)\n\\(....-04-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-05-04.*\\)\n\\(....-05-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-06-04.*\\)\n\\(....-06-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-07-04.*\\)\n\\(....-07-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-08-04.*\\)\n\\(....-08-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-09-04.*\\)\n\\(....-09-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-10-04.*\\)\n\\(....-10-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-11-04.*\\)\n\\(....-11-03.*\\)" "\\2" nil (point-min) (point-max))
  (replace-regexp "^\\(....-12-04.*\\)\n\\(....-12-03.*\\)" "\\2" nil (point-min) (point-max))

)
;; (server-start)

;; fügt hinter jede Zeile den aktuellen Euro-Referenzkurz für das jeweilige Datum hinzu. Ausgehend vom csv von apexclearing.com
;; Dollarzeichen entfernen
;; kbd-macro tastyworks-append-euro aufrufen
;; Voraussetzungen: anderer buffer enthält Euro-Referenzkurse im Format JJJJ-MM-TT;<Kurs>
;; Link: https://www.bundesbank.de/dynamic/action/de/statistiken/zeitreihen-datenbanken/zeitreihen-datenbank/723452/723452?listId=www_s331_b01012_3&tsId=BBEX3.D.USD.EUR.BB.AC.000
;; aktueller Buffer: Cursor am Zeilenanfang der zweiten Zeile (Datenbeginn)
(fset 'tastyworks-append-euro
      [?\C-s ?, ?\C-s return right ?\C-s ?\C-w ?\C-w ?\C-w return ?\C-x ?o home ?\C-s ?\C-s return right ?\C-  end left ?\M-w ?\C-x ?o end ?, ?\C-y C-left backspace ?. end right])

(put 'narrow-to-region 'disabled nil)
;; frame size
(add-to-list 'default-frame-alist '(left . 0))
(add-to-list 'default-frame-alist '(top . 0))
(add-to-list 'default-frame-alist '(height . 30))
(add-to-list 'default-frame-alist '(width . 133))

(defun eval-line ()
  (interactive)
  (let (start end)
    (beginning-of-line)
    (setq start (point))
    (end-of-line)
    (setq end (point))
  (eval-region start end)))

(global-set-key "l" 'eval-line)

;; 
(defun strip-option-desc-2 ()
  (interactive)
       "Strip strike price and option type (put, call) from description: XYZ 14APR23 100 P -> XYZ 14APR23"
       (let ((oldbuf (current-buffer)))
         (save-current-buffer
           (set-buffer (get-buffer-create "*Optiondescr*"))
           (yank)
	   (goto-char (point-min))
	   (while (re-search-forward " [^ ]+ [PC]" nil t)
	     (replace-match "")
	     )
	   (copy-region-as-kill (point-min) (point-max))
	   (kill-buffer)
	   )))
(defun strip-option-desc-3 ()
  (interactive)
       "Strip all but underlying from description: XYZ 14APR23 100 P -> XYZ"
       (let ((oldbuf (current-buffer)))
         (save-current-buffer
           (set-buffer (get-buffer-create "*Optiondescr*"))
           (yank)
	   (goto-char (point-min))
	   (while (re-search-forward " .+" nil t)
	     (replace-match "")
	     )
	   (copy-region-as-kill (point-min) (point-max))
	   (kill-buffer)
	   )))
(defun strip-option-desc-tastyworks-positions ()
  (interactive)
       "Strip all but underlying from description: XYZ 230519C00003000 -> XYZ or ./MESABCDEFG -> MES"
       (let ((oldbuf (current-buffer)))
         (save-current-buffer
           (set-buffer (get-buffer-create "*Optiondescr*"))
           (yank)
	   (goto-char (point-min))
	   (while (re-search-forward " .+" nil t)
	     (replace-match "")
	     )
	   (goto-char (point-min))
	   (while (re-search-forward "\\./\\(ZN\\|MES\\).+" nil t)
	     (replace-match "\\1")
	     )
	   (copy-region-as-kill (point-min) (point-max))
	   (kill-buffer)
	   )))

(defun ib-append-code (field)
  (goto-char (point-min))
  (while (search-forward "," nil t field)
      (progn
	;; match XYZ 21JUL23 or MBTM3
	(if (looking-at "\\w+ \\w+")
	    (message (concat "found" (match-string 0)))
	  (progn (re-search-forward "\\w+") (message (concat "found only symbol " (match-string 0))))
	  )
	(end-of-line)
	(message (concat "inserting " (match-string 0) " at end-of-line"))
	(insert (match-string 0))
	)
    )
  )

(setq users-downloads (expand-file-name "~/Downloads"))

(defun ib-get-csv-output-filename ()
  (let* ((directory-files "c:/Users/konra/Downloads" nil "U7450653")
	 (date-string (format-time-string "%m/%d/%Y" (time-add (current-time) (days-to-time -1))))
	 (buffer-name (concat "realized" (format-time-string "%Y%m%d" (time-add (current-time) (days-to-time -1))) ".csv"))
	 (downloads users-downloads)
	 (open-file-name (concat downloads "/" open-buffer-name))
	 (file-name (concat downloads "/U7450653_" (format-time-string "%Y%m%d" (time-add (current-time) (days-to-time -1))) ".csv"))
	 )
    file-name
    )
  )

(defun ib-get-csv-input-filename ()
  (let* ((file-pattern (concat downloads "/U7450653_*.csv"))
	 (file-names (file-expand-wildcards file-pattern))
	 (file-name (car file-names))
	 )
    file-name
    )
  )


(defun ib-realized-strip-head-tail ()
  (interactive)
       "Strip first and last lines not containing realized values of asset"
       (let* ((oldbuf (current-buffer))
	     (date-string (format-time-string "%m/%d/%Y" (time-add (current-time) (days-to-time -1))))
	     (realized-buffer-name (concat "realized" (format-time-string "%Y%m%d" (time-add (current-time) (days-to-time -1))) ".csv"))
	     (downloads users-downloads)
	     (realized-file-name (concat downloads "/" realized-buffer-name))
	     (file-name (ib-get-csv-input-filename))
	     )
         (save-current-buffer
           (set-buffer (get-buffer-create realized-buffer-name))
	   (delete-region (point-min) (point-max))
           (insert-file-contents file-name)
	   (goto-char (point-min))
	   (search-forward "Gesamt,Gesamt,Code")
	   (delete-region (point-min) (point))
	   (kill-whole-line)
	   (search-forward "Übersicht  zur realisierten und unrealisierten Performance,Data,Devisen")
	   (beginning-of-line)
	   (delete-region (point) (point-max))
	   (goto-char (point-min))
	   (while (re-search-forward "^.+Data,Gesamt.+$" nil t)
	     (kill-whole-line)
	     )
	   (goto-char (point-min))
	   (while (re-search-forward "Übersicht  zur realisierten und unrealisierten Performance" nil t)
	     (replace-match date-string)
	     )
	   ;; append code for each line
	   (ib-append-code 3)
	   (set-visited-file-name realized-file-name)
	   (save-buffer)
	   (copy-region-as-kill (point-min) (point-max))
	   ;; (kill-buffer)
	   )))

(defun ib-open-strip-head-tail ()
  (interactive)
       "Strip first and last lines not containing open values of asset"
       (let* ((oldbuf (current-buffer))
	     (date-string (format-time-string "%m/%d/%Y" (time-add (current-time) (days-to-time -1))))
	     (open-buffer-name (concat "open" (format-time-string "%Y%m%d" (time-add (current-time) (days-to-time -1))) ".csv"))
	     (downloads users-downloads)
	     (open-file-name (concat downloads "/" open-buffer-name))
	     (file-name (ib-get-csv-input-filename))
	     )
         (save-current-buffer
           (set-buffer (get-buffer-create open-buffer-name))
	   (delete-region (point-min) (point-max))
           (insert-file-contents file-name)
	   (goto-char (point-min))
	   (search-forward "Wert,Unrealisierter G/V,Code")
	   (delete-region (point-min) (point))
	   (kill-whole-line)
	   (search-forward "Devisenpositionen,Header")
	   (beginning-of-line)
	   (delete-region (point) (point-max))
	   (goto-char (point-min))
	   (while (re-search-forward "^Offene Positionen,\\(Total\\|Header\\)" nil t)
	     (kill-whole-line)
	     )
	   (goto-char (point-min))
	   (while (re-search-forward "Offene Positionen" nil t)
	     (replace-match date-string)
	     )
	   ;; append code for each line
	   (ib-append-code 5)
	   (set-visited-file-name open-file-name)
	   (save-buffer)
	   (copy-region-as-kill (point-min) (point-max))
	   ;; (kill-buffer)
	   )))
;; ctrl-ä
(global-set-key [67109092] 'ib-realized-strip-head-tail)

;; ctrl-ö
(global-set-key [67109110] 'ib-open-strip-head-tail)

(defun git-bash () (interactive)
  (let ((explicit-shell-file-name "c:/Program Files/git/bin/bash"))
    (call-interactively 'shell)))
(setq explicit-shell-file-name "C:/Program Files/git/bin/bash.exe")
(setq explicit-bash.exe-args '("--login" "-i"))

;; gnus
(setq user-mail-address "konrad.scham@gmail.com"
      user-full-name "Konrad Scham")

(setq gnus-select-method '(nnnil nil))

(setq gnus-secondary-select-methods
      '((nnimap "gmail"
	       (nnimap-address "imap.gmail.com")  ; it could also be imap.googlemail.com if that's your server.
	       (nnimap-server-port "993")
	       (nnimap-stream ssl)
	       (nnir-search-engine imap))
	(nnimap "mail-de"
                (nnimap-address "imap.mail.de")
                (nnimap-server-port "993")
                (nnimap-stream ssl)
                (nnir-search-engine imap))))

(setq smtpmail-smtp-server "smtp.gmail.com"
      smtpmail-smtp-service 587
      gnus-ignored-newsgroups "^to\\.\\|^[0-9. ]+\\( \\|$\\)\\|^[\"]\"[#'()]")
;(smtpmail-auth-credentials . (expand-file-name "/path/to/corresponding/authinfo.gpg"))

; ide form https://justinbarclay.ca/posts/from-zero-to-ide-with-emacs-and-lsp/
(use-package emacs
   :ensure nil
   :init
   (load-theme 'wombat)
   (fido-vertical-mode))

(when scroll-bar-mode
  (scroll-bar-mode -1))

(tool-bar-mode -1)

(menu-bar-mode -1)

(require 'treesit)
(setq major-mode-remap-alist
      '((python-mode . python-ts-mode)))
(require 'corfu)
(global-corfu-mode)
(setq tab-always-indent 'complete)
