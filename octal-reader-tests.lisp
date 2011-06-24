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

(require :sb-posix)
(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))
(ql:quickload '("lisp-unit"))
(load "octal-reader.lisp")

(lisp-unit:define-test 
 interprets-octal-value
 (lisp-unit:assert-equal 668 #z1234))

(lisp-unit:define-test 
 stops-parsing-at-end-of-octal
 (lisp-unit:assert-equal '(668 1234) '(#z1234 1234)))

(lisp-unit:run-tests interprets-octal-value
		     stops-parsing-at-end-of-octal)
