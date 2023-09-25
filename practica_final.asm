.area PROG (ABS)

        ; definimos una constante
fin     .equ 0xFF01
pantalla .equ 0xFF00
teclado  .equ 0xFF02

.org 0x100
;variables
grado1: .word 0
grado2: .word 0
grado_monomio: .word 0
coeficiente_monomio: .word 0
coeficiente_grado3_polinomio1:	.word 0
coeficiente_grado2_polinomio1:	.word 0
coeficiente_grado1_polinomio1:	.word 0	
coeficiente_grado0_polinomio1:	.word 0
coeficiente_grado3_polinomio2:	.word 0
coeficiente_grado2_polinomio2:	.word 0
coeficiente_grado1_polinomio2:	.word 0	
coeficiente_grado0_polinomio2:	.word 0
contador_signos_negativos: .word 0
signos_negativos: .word 0
signos_negativos2: .word 0
temp: .word 0
temp2: .word 0
temp3: .word 0
temp4: .word 0
escalar: .word 0
;peticiones de datos
titulo: .asciz "OPERACIONES CON POLINOMIOS"
grado_polinomio1: .asciz "Introduce el grado del primer polinomio (maximo 3): "
grado_polinomio2: .asciz "Introduce el grado del segundo polinomio (maximo 3): "
error_grado_polinomio: .asciz "Error en la lectura del grado del polinomio. El grado del polinomio debe ser de 0 a 3."
cadena_grado3: .asciz "Introduzca el coeficiente del termino de tercer grado: "
cadena_grado2: .asciz "Introduzca el coeficiente del termino de segundo grado: "
cadena_grado1: .asciz "Introduzca el coeficiente del termino de primer grado: "
cadena_grado0: .asciz "Introduzca el coeficiente del termino independiente: "
error_coeficiente: .asciz "Error en la lectura del coeficiente del polinomio. El coeficiente debe ser de -20 a 20."
error_especial_coeficiente: .asciz "Por circunstancias especiales los coeficientes tampoco pueden valer 0"
polinomio: .asciz "Polinomio Introducido : "
introduce_escalar: .asciz "Introduzca un escalar:"
cadena_grado_monomio: .asciz "Introduce el grado del monomio (maximo 3): "
cadena_monomio: .asciz "Introduce el coeficiente del monomio: "
escoger_polinomio: .asciz "Que polinomio deseas multiplicar (1/2)?: "
error_desbordamiento: .asciz "El resultado de la operacion esta fuera de rango"
escoger_polinomio_divisor: .asciz "Que polinomio quieres que sea el dividendo (1/2)?: "
error_grados_division: .asciz "El grado del dividendo el menor que el grado del divisor"
error_coeficiente_principal_divisor: .asciz "El coeficiente principal del divisor es distinto de 1"


; MENÚ
opcion_1: .asciz "1. Suma de los polinomios."
opcion_2: .asciz "2. Resta de los polinomios."
opcion_3: .asciz "3. Multiplicacion por un escalar."
opcion_4: .asciz "4. Multiplicacion por un monomio."
opcion_5: .asciz "5. Multiplicacion de polinomios."
opcion_6: .asciz "6. Division entre polinomios."
opcion_7: .asciz "7. Salir."
peticion_opcion: .asciz "Introduzca la opcion deseada: "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.globl programa
programa:
        lds #0xF000
        ldu #0xE000
        ldx #titulo
        jsr imprimir_cadena

        lda #'\n
        sta pantalla

        ldx #grado_polinomio1
        jsr leer_grado_polinomio
        stb grado1
        
        lda grado1
        jsr leer_coeficientes_polinomio

        ldy #0xD010
        pulu b
        stb coeficiente_grado0_polinomio1
        sex
        std ,--y
        pulu b
        stb coeficiente_grado1_polinomio1
        sex
        std ,--y
        pulu b
        stb coeficiente_grado2_polinomio1
        sex
        std ,--y
        pulu b
        stb coeficiente_grado3_polinomio1
        sex
        std ,--y

 
 
	ldx #polinomio
	jsr imprimir_cadena
        ldb #3
        jsr imprimir_polinomio


        
        lda #'\n
        sta pantalla

        ldx #grado_polinomio2
        jsr leer_grado_polinomio
        stb grado2

	lda grado2
        jsr leer_coeficientes_polinomio

        ldy #0xD008
        pulu b
        stb coeficiente_grado0_polinomio2
        sex
        std ,--y
        pulu b
        stb coeficiente_grado1_polinomio2
        sex
        std ,--y
        pulu b
        stb coeficiente_grado2_polinomio2
        sex
        std ,--y
        pulu b
        stb coeficiente_grado3_polinomio2
        sex
        std ,--y
 
 
	ldx #polinomio
	jsr imprimir_cadena
        ldb #3
        jsr imprimir_polinomio

menu:
        jsr presentacion_menu
	
	ldy #0xC000
	ldd #suma_polinomios
	std 1,y
	ldd #resta_polinomios
	std 3,y
	ldd #mult_escalar
	std 5,y
	ldd #mult_monomio
	std 7,y
	ldd #mult_polinomio
	std 9,y
	ldd #div_polinomio
	std 11,y
	ldd #final
        std 13,y

	ldx #peticion_opcion
	jsr imprimir_cadena
	jsr eleccion_menu

        cmpy #0XFA11
        beq no_imprimir_polinomio
        ldb #3
        jsr imprimir_polinomio
no_imprimir_polinomio:
        bra menu

final:  ; imprimimos un salto de lInea
        ldb #'\n
        stb pantalla

        ; el programa acaba
        clra          
        sta fin

cargar_pila_polinomio1:       
        ldy #0xD010
        ldb -1,y
        pshu b
        ldb -3,y
        pshu b
        ldb -5,y
        pshu b
        ldb -7,y
        pshu b
        rts

cargar_pila_polinomio2:
        ldy #0xD008
        ldb -1,y
        pshu b
        ldb -3,y
        pshu b
        ldb -5,y
        pshu b
        ldb -7,y
        pshu b
        rts


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprimir_cadena:
        ldb ,x+
        cmpb #'\0
        beq fin_imprimir_cadena
        stb pantalla
        bra imprimir_cadena

fin_imprimir_cadena:
        rts 



leer_grado_polinomio:
        tfr x,y
        lda #'\n
        sta pantalla
        jsr imprimir_cadena
        ldb teclado
        lda #'\n
        sta pantalla
        cmpb #'0
        blo error_leer_grado_polinomio
        cmpb #'3
        bhi error_leer_grado_polinomio
        subb #'0
        rts

error_leer_grado_polinomio:
        ldx #error_grado_polinomio
        jsr imprimir_cadena
        tfr y,x 
        bra leer_grado_polinomio


	
leer_coeficientes_polinomio:
	cmpa #3
	beq grado_3
        ldb #0
        pshu b
	cmpa #2
	beq grado_2
        ldb #0
        pshu b
	cmpa #1
	beq grado_1
        ldb #0
        pshu b
	bra grado_0
	
grado_3:
        ldx #cadena_grado3
        jsr leer_coeficiente

grado_2:
        ldx #cadena_grado2
        jsr leer_coeficiente

grado_1:
        ldx #cadena_grado1
        jsr leer_coeficiente

grado_0:
        ldx #cadena_grado0
        jsr leer_coeficiente
        rts


        
leer_coeficiente:
        tfr x,y
        ldb #'\n
        stb pantalla
        lda #0
        sta contador_signos_negativos
        jsr imprimir_cadena

lectura_coeficiente:
        ldb teclado
        cmpb #'-
        beq coeficiente_negativo
        cmpb #'0
        blo error_leer_coeficiente
        cmpb #'9
        bhi error_leer_coeficiente
        subb #'0
        lda teclado
        cmpa #'\n
        beq sacar_coeficiente     
        cmpa #'0
        blo error_leer_coeficiente
        cmpa #'9
        bhi error_leer_coeficiente
        suba #'0
        bra descomponer

coeficiente_negativo:
        cmpa #1
        beq par
        cmpa #0
        beq impar

impar:
        lda #1
        sta contador_signos_negativos
        bra lectura_coeficiente

par:
        lda #0
        sta contador_signos_negativos
        bra lectura_coeficiente

descomponer:
	cmpb #0
	beq comprobar_coeficiente
	adda #10
	subb #1
	bra descomponer

comprobar_coeficiente:
        tfr a,b
        cmpb #20
	bhi error_leer_coeficiente
        lda #'\n
        sta pantalla
        bra sacar_coeficiente

error_leer_coeficiente:  
        lda #'\n
        sta pantalla
        ldx #error_coeficiente
        jsr imprimir_cadena
        tfr y,x
        bra leer_coeficiente

error_especial_leer_coeficiente:
        lda #'\n
        sta pantalla
        ldx #error_especial_coeficiente
        jsr imprimir_cadena
        tfr y,x
        bra leer_coeficiente
        
sacar_coeficiente:
        cmpb #0
        beq error_especial_leer_coeficiente
        lda contador_signos_negativos
        cmpa #1
        beq negar_coeficiente
        bra fin_leer_coeficiente

negar_coeficiente:
        negb
        bra fin_leer_coeficiente

fin_leer_coeficiente:
        pshu b
        rts


imprimir_polinomio:
        stb temp
	ldd ,y++
        cmpd #0
        beq sgte4
	cmpd #32768
	bhs imprimir_coeficiente_negativo
        pshs d
        ldb temp2
        cmpb #1
        beq imprimir_signo_positivo
        puls d

sgte1:  cmpd #1
        beq facil
        jsr descomponer_coeficiente
        bra sgte2
facil:  ldb temp
        cmpb #0
        bne sgte2
        ldb #1
        addb #'0
        stb pantalla
 
sgte2:  ldb #1
        stb temp2
        ldb temp
        cmpb #0
        bhi imprimir_incognita
        
sgte3:  cmpb #1
        bhi imprimir_exponente
sgte4:  ldb temp
        cmpb #0
        beq fin_imprimir_polinomio
        subb #1
	jmp imprimir_polinomio	

fin_imprimir_polinomio:  
        stb temp2
        ldb #'\n
        stb pantalla
        rts

imprimir_signo_positivo:
        ldb #'+
        stb pantalla
        puls d
        bra sgte1

imprimir_coeficiente_negativo:	
	pshs d
        ldb #'-
	stb pantalla
        puls d
	negb
        nega
        suba #1
 	bra sgte1
	
imprimir_incognita:
       	lda #'x
	sta pantalla
        bra sgte3

imprimir_exponente:
        lda #'^
	sta pantalla
        addb #'0
        stb pantalla
        subb #'0
        bra sgte4	



descomponer_coeficiente:	
        cmpd #10
        blo unidades
        cmpd #100
        blo decenas

centenas: 
        cmpd #100
        blo impr_centenas
        subd #100
        inc temp3
        bra centenas

impr_centenas:
        pshu d
        ldb temp3
        addb #'0
        stb pantalla
        ldb #0
        stb temp3
        pulu d

decenas:  
        cmpd #10
        blo impr_decenas
        subd #10
        inc temp3
        bra decenas

impr_decenas:
        pshu d
        ldb temp3
        addb #'0
        stb pantalla
        ldb #0
        stb temp3
        pulu d
          
unidades: 
        addb #'0
        stb pantalla
        rts

presentacion_menu:	
	lda #'\n
        sta pantalla
	ldx #opcion_1

imprimir_opciones:	
        jsr imprimir_cadena
	lda #'\n
        sta pantalla
        cmpx #peticion_opcion
        beq fin_presentacion_menu
        bra imprimir_opciones
	
fin_presentacion_menu:	
	rts

eleccion_menu:
	lda teclado
        suba #'0
        ldb #1
        jsr decodificar_opcion_menu
        lda #'\n
        sta pantalla
	jsr[b,y]
        rts

decodificar_opcion_menu:
        cmpa #1
        beq fin_decodificar_opcion_menu
        addb #2
        suba #1
        bra decodificar_opcion_menu

fin_decodificar_opcion_menu:
        rts

suma_polinomios:

	ldx #0xD008
	ldy #0xD000
        clra

bucle_suma_polinomios:
	ldd ,x++
	addd ,y++
	pshu d
        cmpu #0xDFF8
        beq fin_bucle_suma_polinomios
        bra bucle_suma_polinomios
 
fin_bucle_suma_polinomios:       
	ldy #0xD000
reordenar_coeficientes_suma:
	pulu d
	std ,--y
        cmpu #0xE000
        beq imprimir_suma_polinomios
        bra reordenar_coeficientes_suma

imprimir_suma_polinomios:		    
	;ldb #3
	;jsr imprimir_polinomio
	rts

resta_polinomios:

	ldx #0xD008
	ldy #0xD000
        clra

bucle_resta_polinomios:
	ldd ,x++
	subd ,y++
	pshu d
        cmpu #0xDFF8
        beq fin_bucle_resta_polinomios
        bra bucle_resta_polinomios
 
fin_bucle_resta_polinomios:       
	ldy #0xD000
reordenar_coeficientes_resta:
	pulu d
	std ,--y
        cmpu #0xE000
        beq imprimir_resta_polinomios
        bra reordenar_coeficientes_resta

imprimir_resta_polinomios:		    
	;ldb #3
	;jsr imprimir_polinomio
	rts

mult_escalar:
        ldx #introduce_escalar
	jsr leer_coeficiente
	pulu b
	tfr b,a 
	sta escalar
	lda #'\n
	sta pantalla
	ldx #escoger_polinomio
        jsr imprimir_cadena
        ldb teclado
       	lda #'\n
	sta pantalla
	cmpb #'1
        beq pilaA
        cmpb #'2
        beq pilaB
	rts

pilaA:  
	jsr cargar_pila_polinomio1
        bra multiplicacion_escalar_polinomio1

pilaB:  
	jsr cargar_pila_polinomio2
        bra multiplicacion_escalar_polinomio1

multiplicacion_escalar_polinomio1:
        clra
        sta signos_negativos2
	lda escalar
        cmpa #127
        bhi negar_a	
sgt1:	pulu b
        cmpb #127
        bhi negar_b
sgt2:	mul 
	pshs d	
        lda signos_negativos2
        cmpa #1
        beq negar_resultado
sgt3:   cmpu #0xE000
        beq fin_multiplicacion_escalar
        bra multiplicacion_escalar_polinomio1

fin_multiplicacion_escalar:
	;colocamos los coeficientes
	ldy #0xD000
	bra bucle_colocar
imprimir_resultado:
	rts	

negar_b: negb
        inc signos_negativos2
        bra sgt2
negar_a: nega
        inc signos_negativos2
        bra sgt1

negar_resultado:
        puls d
        cmpd #0
        beq sgt4
        nega
        suba #1
        negb
sgt4:   pshs d
        bra sgt3

bucle_colocar:
	
	puls d
	std ,--y
	cmpy #0xCFF8
	bne bucle_colocar
	bra imprimir_resultado


mult_monomio:
        ldx #escoger_polinomio
        jsr imprimir_cadena
        ldb teclado
        cmpb #'1
        beq pila1
        cmpb #'2
        beq pila2
        bra mult_monomio

pila1:  jsr cargar_pila_polinomio1
        lda grado1
        bra multiplicacion_monomio_polinomio

pila2:  jsr cargar_pila_polinomio2
        lda grado2
        bra multiplicacion_monomio_polinomio

multiplicacion_monomio_polinomio:
        pshs a
        ldx #cadena_grado_monomio
        jsr leer_grado_polinomio
        stb grado_monomio
        ldx #cadena_monomio
        jsr leer_coeficiente
        ldy #0xD000
        puls a
        pulu b
        stb coeficiente_monomio
        adda grado_monomio
        cmpa #3
        bhi error_multiplicacion_monomio
        lda grado_monomio
        bra multiplicacion_incognitas

error_multiplicacion_monomio:
        ldx #error_desbordamiento
        jsr imprimir_cadena
        ldy #0XFA11
        jmp fin_multiplicacion_monomio
              	
multiplicacion_incognitas:
        cmpa #0
        beq multiplicacion_coeficientes
        pulu b
        suba #1
        bra multiplicacion_incognitas

multiplicacion_coeficientes:
        clra
        sta signos_negativos ;se utilizara la variable contador_signos_negativos
        pulu b
        cmpb #127
        bhi negarb
sig1:   lda coeficiente_monomio
        cmpa #127
        bhi negara
sig2:   mul
        pshs d 
        lda signos_negativos
        cmpa #1
        beq negar_numero
sig3:   cmpu #0xE000
        beq fin_multiplicacion
        bra multiplicacion_coeficientes

negarb: negb
        inc signos_negativos
        bra sig1
negara: nega
        inc signos_negativos
        bra sig2

negar_numero:
        puls d
        cmpd #0
        beq sig4
        nega
        suba #1
        negb
sig4:   pshs d
        bra sig3

fin_multiplicacion:
        clrb
        lda grado_monomio
        cmpa #0
        beq imprimir_multiplicacion_monomio
        dec grado_monomio
        ldd #0
        pshs d
        bra fin_multiplicacion

imprimir_multiplicacion_monomio:
        pshu b
        puls d
        std ,--y
        pulu b
        cmpb #3
        beq imprimir
        addb #1
        bra imprimir_multiplicacion_monomio
imprimir:
        ;jsr imprimir_polinomio

fin_multiplicacion_monomio:
        rts

mult_polinomio:
        lda grado1 
        adda grado2
        cmpa #3
        bhi error_multiplicacion_polinomio
        lda grado1
        cmpa #2
        blo caso2_multiplicacion_polinomio
        bra caso1_multiplicacion_polinomio

error_multiplicacion_polinomio:
        ldx #error_desbordamiento
        jsr imprimir_cadena
        ldy #0XFA11
        jmp fin_multiplicar_polinomio

caso1_multiplicacion_polinomio:
        ldx #0xD000
otra1:  ldd ,x++
        cmpd #0
        beq otra1


        stb coeficiente_monomio
        jsr cargar_pila_polinomio1
        ldy #0xD000
        lda grado2
        sta grado_monomio
        jsr multiplicacion_incognitas
        lda grado2
        cmpa #0
        beq fin_multiplicar_polinomio
        ldd ,x++
        stb coeficiente_monomio



        jsr cargar_pila_polinomio1
        ldy #0xCFF8
        lda grado_monomio
        jsr multiplicacion_incognitas
        ldy #0xCFF8
        ldx #0xCFF0

        jsr bucle_suma_polinomios
        bra fin_multiplicar_polinomio
        

caso2_multiplicacion_polinomio:
        ldx #0xD008
otra2:  ldd ,x++
        cmpd #0
        beq otra2


        stb coeficiente_monomio
        jsr cargar_pila_polinomio2
        ldy #0xD000
        lda grado1
        sta grado_monomio
        jsr multiplicacion_incognitas
        lda grado1
        cmpa #0
        beq fin_multiplicar_polinomio
        ldd ,x++
        stb coeficiente_monomio


        jsr cargar_pila_polinomio2
        ldy #0xCFF8
        lda grado_monomio
        jsr multiplicacion_incognitas
        ldy #0xCFF8
        ldx #0xCFF0

        jsr bucle_suma_polinomios


fin_multiplicar_polinomio:
        rts

div_polinomio:
        ldx #escoger_polinomio_divisor
        jsr imprimir_cadena
        ldb teclado
        lda #'\n
        sta pantalla
        cmpb #'1
        beq division_caso1
        cmpb #'2
        beq salto_division_caso2
        bra div_polinomio

salto_division_caso2:
        jmp division_caso2

division_caso1:
        ldy #0xCFF8
        ldx #0xD008
        
mover_coeficientes_polinomio_dividendo1:        
        ldd ,x++
        std ,y++
        cmpy #0xD000
        beq fin_mover_coeficientes_polinomio_dividendo1
        bra mover_coeficientes_polinomio_dividendo1
 
fin_mover_coeficientes_polinomio_dividendo1:          
        ldx #0xD008

comprobar_coeficiente_principal_divisor1:
        ldd ,y++
        cmpd #0
        bne fin_comprobar_coeficiente_principal_divisor1
        bra comprobar_coeficiente_principal_divisor1

fin_comprobar_coeficiente_principal_divisor1:
        cmpd #1
        bne error_coeficiente_principal_division_polinomio


        lda grado1
        suba grado2
        cmpa #128
        bhi error_grado_division_polinomio
        sta grado_monomio
        sta temp4

sacar_coeficiente_monomio1:   
        ldd ,x++
        cmpd #0
        bne algoritmo_division1
        bra sacar_coeficiente_monomio1

algoritmo_division1: 
        stb coeficiente_monomio
        pshs d
        lda grado_monomio
        jsr cargar_pila_polinomio2
        ldy #0xCFF8
        jsr multiplicacion_incognitas
        ldx #0xCFF8
        ldy #0xCFF0
        jsr bucle_resta_polinomios
        
        lda temp4
        cmpa #0
        beq fin_algoritmo_division1
        suba #1
        sta temp4
        sta grado_monomio
        ldx #0xCFF8
        bra sacar_coeficiente_monomio1      

fin_algoritmo_division1:
        lda grado1
        suba grado2
        sta temp4
        ldy #0xCFF0
        jmp sacar_coeficientes_division


error_grado_division_polinomio:
        ldx #error_grados_division
        jsr imprimir_cadena
        ldy #0XFA11
        jmp fin_division_polinomio

error_coeficiente_principal_division_polinomio:
        ldx #error_coeficiente_principal_divisor
        jsr imprimir_cadena
        ldy #0XFA11
        jmp fin_division_polinomio


division_caso2:
        ldy #0xCFF8
        ldx #0xD000

mover_coeficientes_polinomio_dividendo2:        
        ldd ,x++
        std ,y++
        cmpy #0xD000
        beq fin_mover_coeficientes_polinomio_dividendo2
        bra mover_coeficientes_polinomio_dividendo2
 
fin_mover_coeficientes_polinomio_dividendo2:       
        ldx #0xD000
        ldy #0xD008

comprobar_coeficiente_principal_divisor2:
        ldd ,y++
        cmpd #0
        bne fin_comprobar_coeficiente_principal_divisor2
        bra comprobar_coeficiente_principal_divisor2

fin_comprobar_coeficiente_principal_divisor2:
        cmpd #1
        bne error_coeficiente_principal_division_polinomio


        lda grado2
        suba grado1
        cmpa #128
        bhi error_grado_division_polinomio
        sta grado_monomio
        sta temp4

sacar_coeficiente_monomio2:   
        ldd ,x++
        cmpd #0
        bne algoritmo_division2
        bra sacar_coeficiente_monomio2

algoritmo_division2: 
        stb coeficiente_monomio
        pshs d
        lda grado_monomio
        jsr cargar_pila_polinomio1
        ldy #0xCFF8
        jsr multiplicacion_incognitas
        ldx #0xCFF8
        ldy #0xCFF0
        jsr bucle_resta_polinomios
        
        lda temp4
        cmpa #0
        beq fin_algoritmo_division2
        suba #1
        sta temp4
        sta grado_monomio
        ldx #0xCFF8
        bra sacar_coeficiente_monomio2     

fin_algoritmo_division2:
        lda grado2
        suba grado1
        sta temp4
        ldy #0xCFF0
        bra sacar_coeficientes_division









sacar_coeficientes_division:   
        puls d
        std ,--y
        lda temp4
        cmpa #0
        beq completar_polinomio_division
        dec temp4
        bra sacar_coeficientes_division


completar_polinomio_division:  
        cmpy #0xCFE8
        beq imprimir_division_polinomio 
        ldd #0
        std ,--y 
        bra completar_polinomio_division
              

imprimir_division_polinomio:
        ;ldb #3
        ;jsr imprimir_polinomio
fin_division_polinomio:
	rts

.org 0xFFFE ; vector de RESET
.word programa



























