#lang racket

;(require test-engine/racket-tests) ;; vreau rezultatele de la teste în consolă
(require test-engine/racket-gui) ;; vreau rezultatele de la teste în fereastră separată

(define (to-curry f)    (λ (x) (λ (y) (f x y))))
(define (to-uncurry f)  (λ args (foldl (λ (arg fp) (fp arg)) f args)))
(define (to-curryN N f) (if (zero? N) (let ((lista (reverse f))) (apply (car lista) (cdr lista))) (λ (x) (to-curryN (- N 1) (cons x (if (list? f) f (list f)))))))
(define (compose f g)   (λ (x) (f (g x))))

;; Ne propunem sa realizam o aplicatie care sa certifice stapanirea urmatoarelor concepte/competente:
;; - abstractizarea la nivel de date (tipuri de date abstracte care ofera o interfata (constructori + operatori)
;;   utilizatorului, astfel incat acesta sa nu fie nevoit sa cunoasca implementarea interna)
;; - abstractizarea la nivel de proces (abilitatea de a folosi functionale)
;; - caracteristica functiilor de a fi valori de ordinul intai
;; - abilitatea de a implementa un program mai mare ca o serie de functii care se apeleaza unele pe altele
;; - folosirea expresiilor de legare statica a variabilelor (let, let*, letrec, named let)

;; Pentru aceasta, definim structura de date graf orientat

;; retinem un graf ca pe o lista de noduri si o lista de arce
(define (make-directed-graph V E) (cons V E))
(define G1 (make-directed-graph 
            '(a b c d e f g) 
            '((a b) (c b) (c d) (d a) (d e) (d f) (e g) (f e) (g b) (g c) (g f))))
(define G2 (make-directed-graph 
            '(a b c d e f g) 
            '((a b) (c b) (c d) (d a) (d e) (d f) (f e) (g b) (g c) (g e) (g f))))

;; 1. (3p)
;; Completati tipul de date graf orientat cu urmatorii operatori:

;; intoarce lista de noduri din graf (0,25p)
(define (get-nodes G)
  (car G))

(check-expect (get-nodes G1) '(a b c d e f g))

;; intoarce lista de arce din graf (0,25p)
(define (get-edges G)
  (cdr G))

(check-expect (get-edges G2) '((a b) (c b) (c d) (d a) (d e) (d f) (f e) (g b) (g c) (g e) (g f)))

;; lista nodurilor catre care nodul v are arc (1,25p)
;; se va implementa obligatoriu folosind functionale si/sau functii anonime, fara recursivitate
(define (outgoing G v)
  (flatten (map (λ(y) (cdr y)) (filter (λ(x) (equal? (car x) v)) (cdr G)))))

(check-expect (outgoing G1 'g) '(b c f))

;; lista nodurilor care au arc catre nodul v (1,25p)
;; se va implementa obligatoriu folosind functionale si/sau functii anonime, fara recursivitate
(define (incoming G v)
  (flatten (map (λ(y) (car y)) (filter (λ(x) (equal? (car (cdr x)) v)) (cdr G)))))

(check-expect (incoming G2 'e) '(d f g))

;; 2. (4p)
;; Realizati parcurgerea DFS a grafului G pornind dintr-un nod dat v. 
;; Rezultatul final va trebui sa fie o lista ordonata de perechi cu punct de forma (nod-vizitat . parinte).
;; Folositi diverse forme de let.
;; Folositi functii auxiliare, daca aveti nevoie.

(define (viziteaza L nod)
  (append L (list nod)))

(define (vizitat? L nod)
  (member nod L))

(define (start G v vizitari vecini res)
  (foldl (λ(x y)
           (if (equal? (vizitat? vizitari (car vecini)) #f) 
               (start G (car x) (viziteaza vizitari (car x)) x (append res (list (cons (car x) v))))
               res)
           )
         res
         vecini
  )
)

(define (dfs G v)
  (start G v (append '() (list v)) (outgoing G v) (list (cons v 'none))))

(check-expect (dfs G1 'd) '((d . none) (a . d) (b . a) (e . d) (g . e) (c . g) (f . g)))

;; 3. (4p)
;; Determinati o cale intre nodurile v1 si v2 din graful G, folosind functia de mai sus.
;; Rezultatul final va fi o lista de noduri sau o lista vida, daca o asemenea cale nu exista.
;; Folositi diverse forme de let.
;; Folositi functii auxiliare, daca aveti nevoie.
(define (get-path G v1 v2)
  'your-code-here)

(check-expect (get-path G1 'c 'f) '(c d e g f))

;; 4. BONUS (4p)
;; Determinati daca un graf orientat are cicluri sau nu.
(define (has-cycle? G)
  'your-code-here)

(check-expect (has-cycle? G1) #t)
(check-expect (has-cycle? G2) #f)

(test)