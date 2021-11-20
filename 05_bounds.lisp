;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; 05_bounds.lisp - příklad k přednášce 5
;;;;


#|

Rozšíření třídy shape a jejích potomků o metody left, top, right, bottom.

|#

(defmethod left ((shape shape))
  +1D++0 #| double-float plus-infinity |#)

(defmethod top ((shape shape))
  +1D++0 #| double-float plus-infinity |#)

(defmethod right ((shape shape))
  -1D++0 #| double-float minus-infinity |#)

(defmethod bottom ((shape shape))
  -1D++0 #| double-float minus-infinity |#)

(defmethod left ((shape point))
  (x shape))

(defmethod top ((shape point))
  (y shape))

(defmethod right ((shape point))
  (x shape))

(defmethod bottom ((shape point))
  (y shape))

(defmethod left ((shape circle))
  (- (x (center shape)) (radius shape)))

(defmethod top ((shape circle))
  (- (y (center shape)) (radius shape)))

(defmethod right ((shape circle))
  (+ (x (center shape)) (radius shape)))

(defmethod bottom ((shape circle))
  (+ (y (center shape)) (radius shape)))

(defmethod left ((shape compound-shape))
  (if (items shape)
      ;; reduce je v tomto případě ekvivalentní s apply,
      ;; ale bezpečnější. Detaily nejsou podstatné.
      (reduce 'min (mapcar 'left (items shape)))
    (call-next-method)))

(defmethod top ((shape compound-shape))
  (if (items shape)
      (reduce 'min (mapcar 'top (items shape)))
    (call-next-method)))

(defmethod right ((shape compound-shape))
  (if (items shape)
      (reduce 'max (mapcar 'right (items shape)))
    (call-next-method)))

(defmethod bottom ((shape compound-shape))
  (if (items shape)
      (reduce 'max (mapcar 'bottom (items shape)))
    (call-next-method)))

