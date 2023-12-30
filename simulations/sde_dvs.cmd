;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; sde -e -l xx.scm      ;;
;; tecplot_sv xx_msh.tdr ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Limpa
(sde:clear)

; dimensoes
(define Wfin		(/ @W@ 1000))
(define Lfin		(/ @L@ 1000))
(define Hfin 		(/ @H@ 1000))
(define Lfonte 		(/ @Lfd@ 1000))
(define tox 		(/ @tox@ 1000))
(define tbox		(/ @tbox@ 1000))
(define Wbox 		(+ Wfin (* 2 tox) 0.002))
(define dop 		@Nd@e18)
;(define contato		(/ 5000 1000))

;Nome
(define nome 		"L@L@-W@W@-H@H@-tox@tox@-tbox@tbox@-Nd@Nd@e18-Lfd@Lfd@_msh.tdr")

; Refino
(define refino_FD 	0.010)
(define refino_canal	0.010)


;; Variaveis Grade
(sdedr:define-refinement-size      "Si"              0.003 0.10 0.003                0.002 0.090 0.002 )
(sdedr:define-refinement-size      "Ox"              0.020 0.10 0.020                0.010 0.090 0.010 )

;;;;;;;;;;;;;
;; REGIOES ;;
;;;;;;;;;;;;;

; Define o oxido de porta
(define r1 (sdegeo:create-cuboid
	(position (- (+ tox (/ Wfin 2)))  (- (/ Lfin 2))  (- (/ Hfin 2)))
	(position (+ tox (/ Wfin 2))  (/ Lfin 2)  (+ (/ Hfin 2) tox))
	"Oxide" "oxido"
	)
)

; Define o canal
(define r2 (sdegeo:create-cuboid
	(position (- (/ Wfin 2)) (- (+ (/ Lfin 2) Lfonte)) (- (/ Hfin 2)))
	(position (/ Wfin 2)     (+ (/ Lfin 2) Lfonte)     (/ Hfin 2))
	"Silicon" "corpo"
	)
)

(define r21 (sdegeo:create-cuboid
	(position (- (/ Wfin 2)) (- (+ (/ Lfin 2) Lfonte)) (- (/ Hfin 2)))
	(position (/ Wfin 2)     (- 0.010 (+ (/ Lfin 2) Lfonte))     (/ Hfin 2))
	"Silicon" "corpoS"
	)
)
(define r22 (sdegeo:create-cuboid
	(position (- (/ Wfin 2)) (- (+ (/ Lfin 2) Lfonte) 0.010) (- (/ Hfin 2)))
	(position (/ Wfin 2)     (+ (/ Lfin 2) Lfonte)     (/ Hfin 2))
	"Silicon" "corpoD"
	)
)
; Define o substrato
(define r3 (sdegeo:create-cuboid
	(position  (- (/ Wbox 2))    (- (+ (/ Lfin 2) Lfonte))    (- (/ Hfin 2)))
	(position  (/ Wbox 2)        (+ (/ Lfin 2) Lfonte)        (- (+ (/ Hfin 2) tbox)))
	"Oxide" "box"
	)
)

;;;;;;;;;;;;;;
;; CONTATOS ;;
;;;;;;;;;;;;;;

; Contato de porta
(sdegeo:define-contact-set "porta" 0.001 (color:rgb 1 0 0) "##")

(sdegeo:set-current-contact-set "porta")

(sdegeo:define-3d-contact (list	(car (find-face-id (position (- (+ tox (/ Wfin 2)))  0.000   0.000               )))) "porta")
(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000                   0.000   (+ tox (/ Hfin 2))  )))) "porta")
(sdegeo:define-3d-contact (list	(car (find-face-id (position (+ tox (/ Wfin 2))      0.000   0.000               )))) "porta")

; Contato de dreno
(sdegeo:define-contact-set "dreno" 0.001 (color:rgb 1 0 0) "##")

(sdegeo:set-current-contact-set "dreno")

;(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000  (- (+ (/ Lfin 2) Lfonte) (/ contato 2))  (/ Hfin 2)  )))) "dreno")
(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000  (+ (/ Lfin 2) Lfonte) 0  )))) "dreno")

; Contato de fonte
(sdegeo:define-contact-set "fonte" -0.001 (color:rgb 1 0 0) "##")

(sdegeo:set-current-contact-set "fonte")

;(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000   (- (/ contato 2) (+ (/ Lfin 2) Lfonte))   (/ Hfin 2) )))) "fonte")
(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000  (- (+ (/ Lfin 2) Lfonte)) 0  )))) "fonte")


; Contato do substrato
(sdegeo:define-contact-set "substrato" -0.001 (color:rgb 1 0 0) "##")

(sdegeo:set-current-contact-set "substrato")

(sdegeo:define-3d-contact (list	(car (find-face-id (position 0.000 0.000 (- (+ (/ Hfin 2) tbox))  )))) "substrato")


;;;;;;;;;;;;;
;; DOPAGEM ;;
;;;;;;;;;;;;;

; Canal
(sdedr:define-constant-profile "definicao_perfil_constante_canal" "ArsenicActiveConcentration" dop)
(sdedr:define-constant-profile-material "placement_perfil_constante_canal"  "definicao_perfil_constante_canal" "Silicon")

; Dreno
;(sdedr:define-refeval-window "DopGaussDrenoJan" "Cuboid"  (position (- (/ Wfin 2)) (- (+ (/ Lfin 2) Lfonte)) (- (/ Hfin 2)))     (position (/ Wfin 2) (- (/ Lfin 2)) (/ Hfin 2)) )
;(sdedr:define-gaussian-profile "DopGaussDrenoDef" "ArsenicActiveConcentration" "PeakPos" 0  "PeakVal" 5e20 "Length" 0.0015 "Gauss" "Length" 0)
;(sdedr:define-analytical-profile-placement "DopGaussDreno" "DopGaussDrenoDef" "DopGaussDrenoJan" "Both" "NoReplace" "Eval") 

; Fonte
;(sdedr:define-refeval-window "DopGaussFonteJan" "Cuboid"  (position (- (/ Wfin 2)) (+ (/ Lfin 2) Lfonte) (- (/ Hfin 2)))         (position (/ Wfin 2) (/ Lfin 2) (/ Hfin 2)) )
;(sdedr:define-gaussian-profile "DopGaussFonteDef" "ArsenicActiveConcentration" "PeakPos" 0  "PeakVal" 5e20 "Length" 0.0015 "Gauss" "Length" 0)
;(sdedr:define-analytical-profile-placement "DopGaussFonte" "DopGaussFonteDef" "DopGaussFonteJan" "Both" "NoReplace" "Eval") 



;;;;;;;;;;;
;; GRADE ;;
;;;;;;;;;;;


; Definição de janelas
;;Fonte-Canal-Dreno
(sdedr:define-refeval-window "CanalFonte" "Cuboid" 
(position (- (/ Wfin 2))  (- (/ Lfin 2))  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (- refino_canal (/ Lfin 2))  (/ Hfin 2))  )
(sdedr:define-refeval-window "CanalDreno" "Cuboid" 
(position (- (/ Wfin 2))  (/ Lfin 2)  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (- (/ Lfin 2) refino_canal)  (/ Hfin 2))  )
(sdedr:define-refeval-window "Fonte" "Cuboid" 
(position (- (/ Wfin 2))  (- (/ Lfin 2))  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (- (+ refino_FD (/ Lfin 2)))  (/ Hfin 2))  )
(sdedr:define-refeval-window "Dreno" "Cuboid" 
(position (- (/ Wfin 2))  (/ Lfin 2)  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (+ (/ Lfin 2) refino_FD)  (/ Hfin 2))  )

(sdedr:define-refeval-window "ContatoFonte" "Cuboid" 
(position (- (/ Wfin 2))  (- (+ (/ Lfin 2) Lfonte))  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (- refino_canal (+ (/ Lfin 2) Lfonte))  (/ Hfin 2))  )
(sdedr:define-refeval-window "ContatoDreno" "Cuboid" 
(position (- (/ Wfin 2))  (+ (/ Lfin 2) Lfonte)  (- (/ Hfin 2))) 
(position  (/ Wfin 2)  (- (+ (/ Lfin 2) Lfonte) refino_canal)  (/ Hfin 2))  )

; Multibox fonte-canal-dreno
(sdedr:define-multibox-size "MultiboxCanalFonte"
0.020 0.10 0.020
0.010 0.002 0.010
1 1.8 1)

(sdedr:define-multibox-size "MultiboxCanalDreno"
0.020 0.10 0.020
0.010 0.002 0.010
1 -2 1)

(sdedr:define-multibox-size "MultiboxFonte"
0.020 0.10 0.020
0.010 0.002 0.010
1 -2 1)

(sdedr:define-multibox-size "MultiboxDreno"
0.020 0.10 0.020
0.010 0.002 0.010
1 2 1)

(sdedr:define-multibox-size "MultiboxContatoFonte"
0.020 0.10 0.020
0.010 0.001 0.010
1 2 1)

(sdedr:define-multibox-size "MultiboxContatoDreno"
0.020 0.10 0.020
0.010 0.001 0.010
1 -2 1)


; Aplicação refino materiais
(sdedr:define-refinement-material "RefSi" "Si"  "Silicon" )
(sdedr:define-refinement-placement "RefOx" "Ox"  "Oxide" )


; Aplicação multibox
(sdedr:define-multibox-placement "RefMultiboxCanalFonte" "MultiboxCanalFonte" "CanalFonte")
(sdedr:define-multibox-placement "RefMultiboxCanalDreno" "MultiboxCanalDreno" "CanalDreno")
(sdedr:define-multibox-placement "RefMultiboxFonte" "MultiboxFonte" "Fonte")
(sdedr:define-multibox-placement "RefMultiboxDreno" "MultiboxDreno" "Dreno")
(sdedr:define-multibox-placement "RefMultiboxContatoFonte" "MultiboxContatoFonte" "ContatoFonte")
(sdedr:define-multibox-placement "RefMultiboxContatoDreno" "MultiboxContatoDreno" "ContatoDreno")

; Refino Interfaces
(sdedr:define-refinement-function "Si" "MaxLenInt" "Silicon" "Oxide" 0.0005 2.5 "DoubleSide")

;;;;;;;;;;;;;;;;;;;;;;;;;
;; CONSTRUCAO DA GRADE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;


(sde:build-mesh "snmesh" "" nome)


