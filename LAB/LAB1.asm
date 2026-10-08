
_main:

;LAB1.c,5 :: 		void main() {
;LAB1.c,7 :: 		trisd = 1;  trisb = 0;
	MOVLW      1
	MOVWF      TRISD+0
	CLRF       TRISB+0
;LAB1.c,8 :: 		portb = 0;  portd = 0;
	CLRF       PORTB+0
	CLRF       PORTD+0
;LAB1.c,10 :: 		while (count_switch == 0);
L_main0:
	BTFSC      PORTD+0, 0
	GOTO       L_main1
	GOTO       L_main0
L_main1:
;LAB1.c,12 :: 		loop:
___main_loop:
;LAB1.c,13 :: 		units++;
	INCF       R2+0, 1
;LAB1.c,14 :: 		if (units == 10)
	MOVF       R2+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main2
;LAB1.c,16 :: 		units = 0;
	CLRF       R2+0
;LAB1.c,17 :: 		tens++;
	INCF       R3+0, 1
;LAB1.c,18 :: 		if (tens == 10) tens = 0;
	MOVF       R3+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main3
	CLRF       R3+0
L_main3:
;LAB1.c,19 :: 		}
L_main2:
;LAB1.c,21 :: 		for (i = 0; i < 50; i++) {
	CLRF       R1+0
L_main4:
	MOVLW      50
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main5
;LAB1.c,22 :: 		portb = units;
	MOVF       R2+0, 0
	MOVWF      PORTB+0
;LAB1.c,23 :: 		open_units = 1;    delay_ms(10);    open_units = 0;  // 10 ms units
	BSF        PORTD+0, 2
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	NOP
	BCF        PORTD+0, 2
;LAB1.c,24 :: 		portb = tens;
	MOVF       R3+0, 0
	MOVWF      PORTB+0
;LAB1.c,25 :: 		open_tens = 1;     delay_ms(10);    open_tens = 0;   // 10 ms tens
	BSF        PORTD+0, 1
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	NOP
	BCF        PORTD+0, 1
;LAB1.c,21 :: 		for (i = 0; i < 50; i++) {
	INCF       R1+0, 1
;LAB1.c,26 :: 		}
	GOTO       L_main4
L_main5:
;LAB1.c,29 :: 		goto loop;
	GOTO       ___main_loop
;LAB1.c,30 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
