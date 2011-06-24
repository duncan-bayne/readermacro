;; readermacro - a very simple Octal reader macro in Common Lisp.
;; Copyright (C) 2011 "Duncan Bayne" <dhgbayne@gmail.com>
;; 
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Lesser General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;; 
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU Lesser General Public License for more details.
;; 
;; You should have received a copy of the GNU Lesser General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>


(defun oct-string-to-number 
  (string)
  "Converts an octal string to a number.  Only digits from 0 - 7 are accepted; sign or decimal point symbols will cause oct-to-number to fail"
  (let ((place 1)
	(result 0)
	(pos 0)
	(digits '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7)))
    (loop for char across (reverse string)
	  do 
	  (setq pos (position char digits))
	  (setq result (+ result (* pos place)))
	  (setq place (* 8 place)))
    result))

(defun slurp-octal-digits 
  (stream)
  "Slurps all digits from 0 - 7 from a stream into a string, stopping at EOF, no data, or a non-digit character." 
  (let ((string (make-array 0 :element-type 'character :fill-pointer 0 :adjustable t))
	(digits '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7)))
    (with-output-to-string (out)
			   (let ((char nil)
				 (isnum nil))
			     (loop do
				   (setq char (read-char stream))
				   (if char
				       (progn
					 (setq isnum (find char digits))
					 (if isnum
					     (vector-push-extend char string)
					   (unread-char char stream))))
			     while (not (eq nil isnum)))))
    string))

(defun octal-string-transformer 
  (stream subchar args)
  "Slurps an octal number from stream, and converts it to a number.  Number must be an unsigned integer."
  (let ((oct-string (slurp-octal-digits stream)))
    (oct-string-to-number oct-string)))

;; Sets #z to call octal-string-transformer, so e.g. #z1234 will evaluate to 668.  Use #z as SBCL has #o already :-)
(set-dispatch-macro-character
 #\# #\z
 #'octal-string-transformer)