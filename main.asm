INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]
	;empieza el codigo.
	
EntryPoint: 
	di ;apagar interruptores
	jp Start ;se inicia el juego.
	
REPT $150 - $104
	db 0
ENDR
;-----------------------------------------

SECTION "Game code", ROM0
	; se apaga el LCD
.waitVBlank
	ld a, [rLY]
	cp 144 ;revisa si el LCD ya paso el VBlank
	jr c, .waitVBlank
	
	xor a ; a = 0
	
	ld [rLCDC], a
	
	ld hl, $9000
	ld de, FontTiles
	ld bc, FontTilesEnd - FontTiles
.copyFont

	ld a, [de] ;toma un byte de la fuente 
	ld [hli], a; ponlo en el destino, incrementalo en 1
	inc de; Muevete al siguiente byte
	dec bc; decremento
	ld a, b; chequea si la cuenta es 0
	or c
	jr nz, .copyFont
	
	ld hl, $9800; esto muestra en pantalla el string en la parte superior derecha
	ld de, HelloWordStr
.copyString
	ld a, [de]
	ld [hli], a
	inc de
	and a; valida si el byte que copie es igual a 0
	jr nz, .copyString ;continua si no es igual a 0
	
	;inicia los registros del display
	ld a, %11100100
	ld [rBGP], a
	
	xor a;
	ld [rSCY], a
	ld [rSCX], a
	
	;apagar sonido
	ld [rNR52], a
	
	;encender pantalla y mostrar el fondo
	ld a, %10000001
	ld [rLCDC], a
	
	;;bucle infinito
.lockup
	jr .lockup
	
	;;definiento la fuente
	
SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:
	
SECTION "Hello World", ROM0

HelloWordStr: 
	db " Varillas y camines!              \nEL VIDEOJUEGO", 1
	
	
		
	