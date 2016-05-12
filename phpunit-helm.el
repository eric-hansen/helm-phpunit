;;; phpunit-helm --- Helm integration for phpunit.el

;; Copyright (C) 2016 Eric Hansen

;; Author: Eric Hansen <hansen.c.eric@gmail.com>
;; Version: 1.0.0
;; Package-Requires ((helm "0.0.0") (phpunit "0.7.0"))
;; Keywords: phpunit helm php
;; URL: https://github.com/eric-hansen/phpunit-helm

;;; Commentary:
;; As the author of phpunit.el didn't like the Helm integration I put in
;; while adding in minor mode functionality, I moved the code to its own
;; project.
;; This also requires phpunit.el (the package found at https://github.com/nlamirault/phpunit.el).

;;; Code:

(require 'phpunit)
(require 'helm)

(defun phpunit-helm-get-all-test-candidates ()
  "Populates Helm with a lsit of test functions within a class/file."
  (with-helm-current-buffer
    (let ((test-functions '()))
      (save-excursion
	(beginning-of-buffer)
	(while (search-forward-regexp php-beginning-of-defun-regexp nil t)
	  (add-to-list 'test-functions (match-string-no-properties 1))))
      test-functions)))

(setq phpunit-helm-select-test-source
      '((name . "PHPUnit Tests")
	(candidates . phpunit-helm-get-all-test-candidates)
	(action . (lambda (test)
		    (phpunit-selected-test test)))))

(defun phpunit-helm-select-test ()
  "This is the call that should be ran to pull up Helm and choose the test."
  (interactive)
  (helm :sources '(phpunit-helm-select-test-source)
	:buffer "*phpunit-function-tests*"))

;;;###autoload
(defun phpunit-selected-test (test)
  "Launch PHPUnit on the selected test by Helm."
  (interactive)
  (let ((args (s-concat " --filter '" (phpunit-get-current-class) "::" test-function "'")))
    (phpunit-run args)))

(provide 'phpunit-helm)

;;; phpunit-helm.el ends here
