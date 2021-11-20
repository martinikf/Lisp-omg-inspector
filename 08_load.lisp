;; 08.load

#|
Načtením tohoto souboru načtete všechny soubory potřebné k práci 
s knihovnou OMG ve verzi z 8. přednášky.

Adresář s knihovnou micro-graphics a ostatní potřebné soubory musí být 
ve stejném adresáři jako tento soubor.

Pokud chcete načíst jinou verzi knihovny, nejprve ukončete LispWorks.
|#

(in-package "CL-USER")

(defsystem pp3-08 ()
  :members ("micro-graphics/load" "08" "05_bounds" "08_text-shape" "08_button")
  :rules ((:compile :all 
           (:requires (:load :previous)))))

(compile-system 'pp3-08 :load t)