
_main:

;_7seg.c,4 :: 		void main()
;_7seg.c,7 :: 		unsigned char count = 0;
	CLRF       main_count_L0+0
	MOVLW      63
	MOVWF      main_segment_L0+0
	MOVLW      6
	MOVWF      main_segment_L0+1
	MOVLW      91
	MOVWF      main_segment_L0+2
	MOVLW      79
	MOVWF      main_segment_L0+3
	MOVLW      102
	MOVWF      main_segment_L0+4
	MOVLW      109
	MOVWF      main_segment_L0+5
	MOVLW      125
	MOVWF      main_segment_L0+6
	MOVLW      7
	MOVWF      main_segment_L0+7
	MOVLW      127
	MOVWF      main_segment_L0+8
	MOVLW      111
	MOVWF      main_segment_L0+9
;_7seg.c,9 :: 		TRISD = 1 ;
	MOVLW      1
	MOVWF      TRISD+0
;_7seg.c,10 :: 		TRISB = 0 ;
	CLRF       TRISB+0
;_7seg.c,11 :: 		Display = segment[0];
	MOVF       main_segment_L0+0, 0
	MOVWF      PORTB+0
;_7seg.c,12 :: 		while (start == 0 );
L_main0:
	BTFSC      PORTD+0, 0
	GOTO       L_main1
	GOTO       L_main0
L_main1:
;_7seg.c,14 :: 		loop: count++;
___main_loop:
	INCF       main_count_L0+0, 1
;_7seg.c,16 :: 		if (count == 10 ) count = 0;
	MOVF       main_count_L0+0, 0
	XORLW      10
	BTFSS      STATUS+0, 2
	GOTO       L_main2
	CLRF       main_count_L0+0
L_main2:
;_7seg.c,17 :: 		Display = segment [count];
	MOVF       main_count_L0+0, 0
	ADDLW      main_segment_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      PORTB+0
;_7seg.c,18 :: 		Delay_ms (1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main3:
	DECFSZ     R13+0, 1
	GOTO       L_main3
	DECFSZ     R12+0, 1
	GOTO       L_main3
	DECFSZ     R11+0, 1
	GOTO       L_main3
	NOP
	NOP
;_7seg.c,19 :: 		goto loop;
	GOTO       ___main_loop
;_7seg.c,20 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
