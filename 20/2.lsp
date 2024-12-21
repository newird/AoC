(load (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname)))

(ql:quickload "cl-heap")
(asdf:load-system 'cl-heap)
(ql:quickload :alexandria)

(defun make-hash-set (&key (test 'eql))
  (make-hash-table :test test))

(defun set-insert (set elem)
  (setf (gethash elem set) t))

(defun set-get (set elem)
  (gethash elem set))

(defun get-aoc-map-ele (m coord)
  (gethash coord m))

(defun neighboor (m coord)
  (let ((x (first coord))
        (y (second coord)))
    (remove-if #'null
               (list
                (list x (1+ y))
                (list x (1- y))
                (list (1+ x) y)
                (list (1- x) y)
                ))))

(defun dijkstra (m start end)
  (let ((distance-table (make-hash-table :test 'equal))
        (visited (make-hash-set :test 'equal)))
    (setf (gethash start distance-table) 0)
    (do* ((this start)
          (next-round (make-instance 'cl-heap:binary-heap
                                   :sort-fun #'<
                                   :key #'second))
          (this-to-start-value (gethash this distance-table)
                              (gethash this distance-table)))
         ((or (equal this end) (not this))
          distance-table)
      (if (set-get visited this)
          nil
          (loop for next in (neighboor m this)
                unless (equal (get-aoc-map-ele m next) #\#)
                  unless (set-get visited next)
                    do (if (or (not (gethash next distance-table))
                             (> (gethash next distance-table)
                                (+ this-to-start-value 1)))
                           (progn
                             (setf (gethash next distance-table)
                                   (+ this-to-start-value 1))
                             (cl-heap:add-to-heap next-round
                                                 (list next (+ this-to-start-value 1)))))))
      (set-insert visited this)
      (setf this (let ((tt (cl-heap:pop-heap next-round)))
                   (if tt (first tt) nil))))))

(defun read-file-by-line (path)
  (with-open-file (stream path :direction :input)
    (loop for line = (read-line stream nil)
          while line
          collect line)))

(defun parse-map (lines)
  (let ((map (make-hash-table :test 'equal)))
    (loop for y from 0
          for row in lines
          do (loop for x from 0
                   for ele across row
                   do (setf (gethash (list x y) map) ele)))
    map))

(defun find_ele (m target)
  (let (result)
    (maphash (lambda (coord char)
               (when (char= char target)
                 (push coord result)))
             m)
    result))

(defun manhattan-distance (x y)
  (+ (abs (- (first x) (first y)))
     (abs (- (second x) (second y)))))

(defun solve (input save-step)
  (let* ((m (parse-map (read-file-by-line input)))
         (start (first (find_ele m #\S)))
         (end (first (find_ele m #\E))))

    (let ((distance-table (dijkstra m start end))
          cheat-table)
      (setf cheat-table
            (do ((all-path (sort (alexandria:hash-table-alist distance-table) #'< :key #'cdr)
                           (cdr all-path))
                 (table (make-hash-table :test 'equal)))
                ((not all-path) table)
              (loop with this = (first all-path)
                    for n in (cdr all-path)
                    when (<= (manhattan-distance (car this) (car n)) 20)
                      do
                         (push (list (car this) (car n))
                               (gethash (- (abs (- (cdr this) (cdr n)))
                                           (manhattan-distance (car this) (car n)))
                                        table nil)))))
      (loop for n in (alexandria:hash-table-keys cheat-table)
            when (>= n save-step)
              sum (length (gethash n cheat-table))))))

(format t "~a~%" (solve "1.in" 100))
