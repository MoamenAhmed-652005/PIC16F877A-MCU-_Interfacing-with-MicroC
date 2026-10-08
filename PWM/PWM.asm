
_displayStatus:

;PWM.c,32 :: 		void displayStatus() {
;PWM.c,33 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PWM.c,35 :: 		Lcd_Out(1,1,"M1:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_PWM+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PWM.c,36 :: 		Lcd_Chr(1,4,dir1);
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _dir1+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PWM.c,37 :: 		ByteToStr(speed1, txt);
	MOVF       _speed1+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;PWM.c,38 :: 		Lcd_Out(1,6,txt);
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PWM.c,40 :: 		Lcd_Out(2,1,"M2:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_PWM+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PWM.c,41 :: 		Lcd_Chr(2,4,dir2);
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Chr_column+0
	MOVF       _dir2+0, 0
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;PWM.c,42 :: 		ByteToStr(speed2, txt);
	MOVF       _speed2+0, 0
	MOVWF      FARG_ByteToStr_input+0
	MOVLW      _txt+0
	MOVWF      FARG_ByteToStr_output+0
	CALL       _ByteToStr+0
;PWM.c,43 :: 		Lcd_Out(2,6,txt);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;PWM.c,44 :: 		}
L_end_displayStatus:
	RETURN
; end of _displayStatus

_main:

;PWM.c,48 :: 		void main() {
;PWM.c,51 :: 		TRISD = 0;
	CLRF       TRISD+0
;PWM.c,52 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;PWM.c,53 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;PWM.c,56 :: 		TRISB = 0b00110000;   // Buttons B4 ,B5
	MOVLW      48
	MOVWF      TRISB+0
;PWM.c,59 :: 		ADC_Init();
	CALL       _ADC_Init+0
;PWM.c,62 :: 		PWM1_Init(1000);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      124
	MOVWF      PR2+0
	CALL       _PWM1_Init+0
;PWM.c,63 :: 		PWM2_Init(1000);
	BSF        T2CON+0, 0
	BSF        T2CON+0, 1
	MOVLW      124
	MOVWF      PR2+0
	CALL       _PWM2_Init+0
;PWM.c,64 :: 		PWM1_Start();
	CALL       _PWM1_Start+0
;PWM.c,65 :: 		PWM2_Start();
	CALL       _PWM2_Start+0
;PWM.c,67 :: 		OPTION_REG.F7 = 0;   // Enable PORTB pull-ups
	BCF        OPTION_REG+0, 7
;PWM.c,69 :: 		while(1) {
L_main0:
;PWM.c,72 :: 		pot1 = ADC_Read(0);   // RA0
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot1+0
	MOVF       R0+1, 0
	MOVWF      _pot1+1
;PWM.c,73 :: 		pot2 = ADC_Read(1);   // RA1
	MOVLW      1
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _pot2+0
	MOVF       R0+1, 0
	MOVWF      _pot2+1
;PWM.c,75 :: 		speed1 = pot1 / 4;    // 0–255
	MOVF       _pot1+0, 0
	MOVWF      R5+0
	MOVF       _pot1+1, 0
	MOVWF      R5+1
	RRF        R5+1, 1
	RRF        R5+0, 1
	BCF        R5+1, 7
	RRF        R5+1, 1
	RRF        R5+0, 1
	BCF        R5+1, 7
	MOVF       R5+0, 0
	MOVWF      _speed1+0
;PWM.c,76 :: 		speed2 = pot2 / 4;
	MOVF       R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	MOVF       R2+0, 0
	MOVWF      _speed2+0
;PWM.c,78 :: 		PWM1_Set_Duty(speed1);
	MOVF       R5+0, 0
	MOVWF      FARG_PWM1_Set_Duty_new_duty+0
	CALL       _PWM1_Set_Duty+0
;PWM.c,79 :: 		PWM2_Set_Duty(speed2);
	MOVF       _speed2+0, 0
	MOVWF      FARG_PWM2_Set_Duty_new_duty+0
	CALL       _PWM2_Set_Duty+0
;PWM.c,82 :: 		if(BTN_M1 == 0 && lastBtn1 == 1) {
	BTFSC      PORTB+0, 4
	GOTO       L_main4
	MOVF       _lastBtn1+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
L__main18:
;PWM.c,83 :: 		dir1 = (dir1 == 'F') ? 'R' : 'F';
	MOVF       _dir1+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_main5
	MOVLW      82
	MOVWF      ?FLOC___mainT15+0
	GOTO       L_main6
L_main5:
	MOVLW      70
	MOVWF      ?FLOC___mainT15+0
L_main6:
	MOVF       ?FLOC___mainT15+0, 0
	MOVWF      _dir1+0
;PWM.c,84 :: 		}
L_main4:
;PWM.c,85 :: 		lastBtn1 = BTN_M1;
	MOVLW      0
	BTFSC      PORTB+0, 4
	MOVLW      1
	MOVWF      _lastBtn1+0
;PWM.c,87 :: 		if(BTN_M2 == 0 && lastBtn2 == 1) {
	BTFSC      PORTB+0, 5
	GOTO       L_main9
	MOVF       _lastBtn2+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main9
L__main17:
;PWM.c,88 :: 		dir2 = (dir2 == 'F') ? 'R' : 'F';
	MOVF       _dir2+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_main10
	MOVLW      82
	MOVWF      ?FLOC___mainT22+0
	GOTO       L_main11
L_main10:
	MOVLW      70
	MOVWF      ?FLOC___mainT22+0
L_main11:
	MOVF       ?FLOC___mainT22+0, 0
	MOVWF      _dir2+0
;PWM.c,89 :: 		}
L_main9:
;PWM.c,90 :: 		lastBtn2 = BTN_M2;
	MOVLW      0
	BTFSC      PORTB+0, 5
	MOVLW      1
	MOVWF      _lastBtn2+0
;PWM.c,94 :: 		if(dir1 == 'F') { M1_IN1 = 1; M1_IN2 = 0; }
	MOVF       _dir1+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_main12
	BSF        RB0_bit+0, BitPos(RB0_bit+0)
	BCF        RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main13
L_main12:
;PWM.c,95 :: 		else           { M1_IN1 = 0; M1_IN2 = 1; }
	BCF        RB0_bit+0, BitPos(RB0_bit+0)
	BSF        RB1_bit+0, BitPos(RB1_bit+0)
L_main13:
;PWM.c,98 :: 		if(dir2 == 'F') { M2_IN1 = 1; M2_IN2 = 0; }
	MOVF       _dir2+0, 0
	XORLW      70
	BTFSS      STATUS+0, 2
	GOTO       L_main14
	BSF        RB2_bit+0, BitPos(RB2_bit+0)
	BCF        RB3_bit+0, BitPos(RB3_bit+0)
	GOTO       L_main15
L_main14:
;PWM.c,99 :: 		else           { M2_IN1 = 0; M2_IN2 = 1; }
	BCF        RB2_bit+0, BitPos(RB2_bit+0)
	BSF        RB3_bit+0, BitPos(RB3_bit+0)
L_main15:
;PWM.c,101 :: 		displayStatus();
	CALL       _displayStatus+0
;PWM.c,102 :: 		Delay_ms(200);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      8
	MOVWF      R12+0
	MOVLW      119
	MOVWF      R13+0
L_main16:
	DECFSZ     R13+0, 1
	GOTO       L_main16
	DECFSZ     R12+0, 1
	GOTO       L_main16
	DECFSZ     R11+0, 1
	GOTO       L_main16
;PWM.c,103 :: 		}
	GOTO       L_main0
;PWM.c,104 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
