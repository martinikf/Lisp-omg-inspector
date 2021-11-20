;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; G) settable-properties
;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Přidání vlastnosti ke grafickým objektům
;;
;;Dopsat settable, dvojklik, otestovat (g)

(defmethod settable-properties ((p point))
  '(x y r phi color thickness))

(defmethod settable-properties ((c circle))
  '(center r color filledp thickness))

(defmethod settable-properties ((p polygon))
  '(items closedp color thickness filledp))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; INSPECTOR WINDOW
;;

(defclass inspector-window (abstract-window)
  ((inspected-window :initform nil)
   (inspected-object :initform nil)))
 
;; Vlastnosti

(defmethod inspected-window ((ins inspector-window))
  (slot-value ins 'inspected-window))

(defmethod set-inspected-window ((ins inspector-window) window)
  (when (inspected-window ins)
    (set-delegate (slot-value ins 'inspected-window) nil))
  (setf (slot-value ins 'inspected-window) window)
  (setf (slot-value ins 'inspected-object) window)
  (set-delegate window ins)
  (display ins window))

(defmethod inspected-object ((ins inspector-window))
  (slot-value ins 'inspected-object))

;; DOUBLE CLICK

(defmethod initialize-instance ((w inspector-window) &key)
  (call-next-method)
  (install-callbacks w)
  w)

(defmethod install-callbacks ((w inspector-window))
  (call-next-method)
  (install-double-click-callback w))

(defmethod install-double-click-callback ((w inspector-window))
  (mg:set-callback 
   (slot-value w 'mg-window) 
   :double-click (lambda (mgw button x y)
		 (declare (ignore mgw))
		 (window-double-click
                  w
                  button
                  (move (make-instance 'point) x y))))
  w)

(defmethod window-double-click ((w inspector-window) button position)
  (let ((shape (find-clicked-shape w position)))
    (when shape
      (btn-click w shape))))
    
(defmethod find-clicked-shape ((w inspector-window) position)
  (when (shape w)
    (find-if (lambda (shape) (contains-point-p shape position))
             (solid-shapes (shape w)))))

(defmethod btn-click ((ins inspector-window) btn)
  (change-property ins btn))

;; Metody

(defmethod display ((ins inspector-window) object)
  (let ((settable-properties (settable-properties object))
        (i 1)
        (shape '()))
    (dolist (property settable-properties)
      (setf shape (cons (move 
                         (set-button-text 
                          (make-instance 'button)
                          (format nil "~a - ~a" property (funcall property object)))
                         5 (* i 30))
                        shape))
      (incf i))
      (do-set-shape ins (set-items (make-instance 'picture) shape))
      (invalidate ins)))
  
;;Klikání

;;Přejmenovat eventy?
(defmethod ev-mouse-down ((ins inspector-window) sender clicked button position)
  (when (eql (slot-value ins 'inspected-window) sender)
    (setf (slot-value ins 'inspected-object) clicked)
    (display ins clicked)))

;;Klikání btns
(defmethod change-property ((ins inspector-window) object)
  (let ((i 0))
    (dolist (btn (reverse (items (shape ins))))
      (when (eql btn object)
        (set-property ins (inspected-object ins) (print i)))
        (incf i))))

(defmethod set-property ((ins inspector-window) object nth)
  (let ((setter (setter-name (nth nth (settable-properties object))))
        (value (multiple-value-list(capi:prompt-for-value "Zadejte novou hodnotu"))))
    (when (cadr value)
      (funcall setter object (car value)))))

;; Změna inspector po změně v inspected
(defmethod ev-change ((ins inspector-window) sender)
  (display ins (slot-value ins 'inspected-object)))

(defun setter-name (prop)
  (values (find-symbol (format nil "SET-~a" prop))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; INSPECTED WINDOW
;;

(defclass inspected-window (window)
  ())

(defmethod settable-properties ((win inspected-window))
  '(background shape))

(defmethod mouse-down-no-shape ((w inspected-window) button position)
  (send-event w 'ev-mouse-down w button position)
  w)


#|

(setf ins (make-instance 'inspector-window))
(setf inp (make-instance 'inspected-window))
(set-inspected-window ins inp)
|#