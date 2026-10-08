
_snd_click:

;Secure.c,27 :: 		void snd_click() { BUZZER = 1; Delay_ms(40); BUZZER = 0; }
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_snd_click0:
	DECFSZ     R13+0, 1
	GOTO       L_snd_click0
	DECFSZ     R12+0, 1
	GOTO       L_snd_click0
	NOP
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
L_end_snd_click:
	RETURN
; end of _snd_click

_snd_ok:

;Secure.c,28 :: 		void snd_ok()    { int i; for(i=0;i<3;i++){BUZZER=1; Delay_ms(80); BUZZER=0; Delay_ms(40);} }
	CLRF       R1+0
	CLRF       R1+1
L_snd_ok1:
	MOVLW      128
	XORWF      R1+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__snd_ok44
	MOVLW      3
	SUBWF      R1+0, 0
L__snd_ok44:
	BTFSC      STATUS+0, 0
	GOTO       L_snd_ok2
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
	MOVLW      208
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_snd_ok4:
	DECFSZ     R13+0, 1
	GOTO       L_snd_ok4
	DECFSZ     R12+0, 1
	GOTO       L_snd_ok4
	NOP
	NOP
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
	MOVLW      104
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_snd_ok5:
	DECFSZ     R13+0, 1
	GOTO       L_snd_ok5
	DECFSZ     R12+0, 1
	GOTO       L_snd_ok5
	NOP
	INCF       R1+0, 1
	BTFSC      STATUS+0, 2
	INCF       R1+1, 1
	GOTO       L_snd_ok1
L_snd_ok2:
L_end_snd_ok:
	RETURN
; end of _snd_ok

_snd_err:

;Secure.c,29 :: 		void snd_err()   { BUZZER = 1; Delay_ms(800); BUZZER = 0; }
	BSF        RD1_bit+0, BitPos(RD1_bit+0)
	MOVLW      9
	MOVWF      R11+0
	MOVLW      30
	MOVWF      R12+0
	MOVLW      228
	MOVWF      R13+0
L_snd_err6:
	DECFSZ     R13+0, 1
	GOTO       L_snd_err6
	DECFSZ     R12+0, 1
	GOTO       L_snd_err6
	DECFSZ     R11+0, 1
	GOTO       L_snd_err6
	NOP
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
L_end_snd_err:
	RETURN
; end of _snd_err

_save_pass:

;Secure.c,32 :: 		void save_pass() {
;Secure.c,33 :: 		EEPROM_Write(0x00, pass[0]);
	CLRF       FARG_EEPROM_Write_Address+0
	MOVF       _pass+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Secure.c,34 :: 		EEPROM_Write(0x01, pass[1]);
	MOVLW      1
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _pass+1, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Secure.c,35 :: 		EEPROM_Write(0x02, pass[2]);
	MOVLW      2
	MOVWF      FARG_EEPROM_Write_Address+0
	MOVF       _pass+2, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;Secure.c,36 :: 		}
L_end_save_pass:
	RETURN
; end of _save_pass

_load_pass:

;Secure.c,38 :: 		void load_pass() {
;Secure.c,39 :: 		pass[0] = EEPROM_Read(0x00);
	CLRF       FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _pass+0
;Secure.c,40 :: 		pass[1] = EEPROM_Read(0x01);
	MOVLW      1
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _pass+1
;Secure.c,41 :: 		pass[2] = EEPROM_Read(0x02);
	MOVLW      2
	MOVWF      FARG_EEPROM_Read_Address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _pass+2
;Secure.c,43 :: 		if(pass[0] > 9) { pass[0]=0; pass[1]=0; pass[2]=0; save_pass(); }
	MOVF       _pass+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_load_pass7
	CLRF       _pass+0
	CLRF       _pass+1
	CLRF       _pass+2
	CALL       _save_pass+0
L_load_pass7:
;Secure.c,44 :: 		}
L_end_load_pass:
	RETURN
; end of _load_pass

_show_digits:

;Secure.c,46 :: 		void show_digits() {
;Secure.c,47 :: 		txt_val[0] = input[0] + '0';
	MOVLW      48
	ADDWF      _input+0, 0
	MOVWF      _txt_val+0
;Secure.c,48 :: 		txt_val[1] = input[1] + '0';
	MOVLW      48
	ADDWF      _input+1, 0
	MOVWF      _txt_val+1
;Secure.c,49 :: 		txt_val[2] = input[2] + '0';
	MOVLW      48
	ADDWF      _input+2, 0
	MOVWF      _txt_val+2
;Secure.c,50 :: 		Lcd_Out(2, 7, txt_val);
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      7
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      _txt_val+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,52 :: 		Lcd_Chr(2, 7 + cursor, '_');
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVF       _cursor+0, 0
	ADDLW      7
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      95
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;Secure.c,53 :: 		}
L_end_show_digits:
	RETURN
; end of _show_digits

_main:

;Secure.c,55 :: 		void main() {
;Secure.c,56 :: 		TRISD = 0x30; // 0011 0000 (RD4, RD5 œŒ·)
	MOVLW      48
	MOVWF      TRISD+0
;Secure.c,57 :: 		LOCK_OUT = 0; BUZZER = 0;
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
	BCF        RD1_bit+0, BitPos(RD1_bit+0)
;Secure.c,59 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;Secure.c,60 :: 		load_pass(); //  Õ„Ì· «·»«”Ê—œ „‰ «·–«ﬂ—…
	CALL       _load_pass+0
;Secure.c,61 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,62 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,63 :: 		Lcd_Out(1, 4, "SYSTEM READY");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,64 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main8:
	DECFSZ     R13+0, 1
	GOTO       L_main8
	DECFSZ     R12+0, 1
	GOTO       L_main8
	DECFSZ     R11+0, 1
	GOTO       L_main8
	NOP
	NOP
;Secure.c,66 :: 		while(1) {
L_main9:
;Secure.c,67 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,68 :: 		Lcd_Out(1, 1, "Enter Code:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,69 :: 		cursor = 0; input[0]=0; input[1]=0; input[2]=0;
	CLRF       _cursor+0
	CLRF       _input+0
	CLRF       _input+1
	CLRF       _input+2
;Secure.c,72 :: 		while(cursor < 3) {
L_main11:
	MOVLW      3
	SUBWF      _cursor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main12
;Secure.c,73 :: 		show_digits();
	CALL       _show_digits+0
;Secure.c,74 :: 		if(BTN_COUNT == 1) {
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_main13
;Secure.c,75 :: 		input[cursor]++;
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      FSR
	INCF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;Secure.c,76 :: 		if(input[cursor] > 9) input[cursor] = 0;
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_main14
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      FSR
	CLRF       INDF+0
L_main14:
;Secure.c,77 :: 		snd_click();
	CALL       _snd_click+0
;Secure.c,78 :: 		while(BTN_COUNT == 1);
L_main15:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_main16
	GOTO       L_main15
L_main16:
;Secure.c,79 :: 		}
L_main13:
;Secure.c,80 :: 		if(BTN_ENTER == 1) {
	BTFSS      RD4_bit+0, BitPos(RD4_bit+0)
	GOTO       L_main17
;Secure.c,81 :: 		cursor++;
	INCF       _cursor+0, 1
;Secure.c,82 :: 		snd_click();
	CALL       _snd_click+0
;Secure.c,83 :: 		while(BTN_ENTER == 1);
L_main18:
	BTFSS      RD4_bit+0, BitPos(RD4_bit+0)
	GOTO       L_main19
	GOTO       L_main18
L_main19:
;Secure.c,84 :: 		}
L_main17:
;Secure.c,85 :: 		}
	GOTO       L_main11
L_main12:
;Secure.c,88 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,89 :: 		if(input[0]==pass[0] && input[1]==pass[1] && input[2]==pass[2]) {
	MOVF       _input+0, 0
	XORWF      _pass+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVF       _input+1, 0
	XORWF      _pass+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main22
	MOVF       _input+2, 0
	XORWF      _pass+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L_main22
L__main41:
;Secure.c,90 :: 		Lcd_Out(1, 4, "CORRECT!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,91 :: 		Lcd_Out(2, 3, "LOCK OPENED");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,92 :: 		LOCK_OUT = 1;
	BSF        RD0_bit+0, BitPos(RD0_bit+0)
;Secure.c,93 :: 		snd_ok();
	CALL       _snd_ok+0
;Secure.c,96 :: 		Delay_ms(1500);
	MOVLW      16
	MOVWF      R11+0
	MOVLW      57
	MOVWF      R12+0
	MOVLW      13
	MOVWF      R13+0
L_main23:
	DECFSZ     R13+0, 1
	GOTO       L_main23
	DECFSZ     R12+0, 1
	GOTO       L_main23
	DECFSZ     R11+0, 1
	GOTO       L_main23
	NOP
	NOP
;Secure.c,97 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,98 :: 		Lcd_Out(1, 1, "Press ENTER to");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,99 :: 		Lcd_Out(2, 1, "Change Password");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,102 :: 		for(cursor=0; cursor<30; cursor++) {
	CLRF       _cursor+0
L_main24:
	MOVLW      30
	SUBWF      _cursor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main25
;Secure.c,103 :: 		if(BTN_ENTER == 1) {
	BTFSS      RD4_bit+0, BitPos(RD4_bit+0)
	GOTO       L_main27
;Secure.c,104 :: 		snd_click();
	CALL       _snd_click+0
;Secure.c,105 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,106 :: 		Lcd_Out(1, 1, "Set New Code:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,108 :: 		cursor = 0; input[0]=0; input[1]=0; input[2]=0;
	CLRF       _cursor+0
	CLRF       _input+0
	CLRF       _input+1
	CLRF       _input+2
;Secure.c,109 :: 		while(cursor < 3) {
L_main28:
	MOVLW      3
	SUBWF      _cursor+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main29
;Secure.c,110 :: 		show_digits();
	CALL       _show_digits+0
;Secure.c,111 :: 		if(BTN_COUNT==1){ input[cursor]++; if(input[cursor]>9)input[cursor]=0; snd_click(); while(BTN_COUNT==1); }
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_main30
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      R1+0
	MOVF       R1+0, 0
	MOVWF      FSR
	INCF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	SUBLW      9
	BTFSC      STATUS+0, 0
	GOTO       L_main31
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      FSR
	CLRF       INDF+0
L_main31:
	CALL       _snd_click+0
L_main32:
	BTFSS      RD5_bit+0, BitPos(RD5_bit+0)
	GOTO       L_main33
	GOTO       L_main32
L_main33:
L_main30:
;Secure.c,112 :: 		if(BTN_ENTER==1){ pass[cursor]=input[cursor]; cursor++; snd_click(); while(BTN_ENTER==1); }
	BTFSS      RD4_bit+0, BitPos(RD4_bit+0)
	GOTO       L_main34
	MOVF       _cursor+0, 0
	ADDLW      _pass+0
	MOVWF      R1+0
	MOVF       _cursor+0, 0
	ADDLW      _input+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
	INCF       _cursor+0, 1
	CALL       _snd_click+0
L_main35:
	BTFSS      RD4_bit+0, BitPos(RD4_bit+0)
	GOTO       L_main36
	GOTO       L_main35
L_main36:
L_main34:
;Secure.c,113 :: 		}
	GOTO       L_main28
L_main29:
;Secure.c,114 :: 		save_pass(); // Õ›Ÿ ›Ì «·–«ﬂ—… ··√»œ
	CALL       _save_pass+0
;Secure.c,115 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;Secure.c,116 :: 		Lcd_Out(1, 3, "CODE UPDATED!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr8_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,117 :: 		snd_ok();
	CALL       _snd_ok+0
;Secure.c,118 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main37:
	DECFSZ     R13+0, 1
	GOTO       L_main37
	DECFSZ     R12+0, 1
	GOTO       L_main37
	DECFSZ     R11+0, 1
	GOTO       L_main37
	NOP
	NOP
;Secure.c,119 :: 		break;
	GOTO       L_main25
;Secure.c,120 :: 		}
L_main27:
;Secure.c,121 :: 		Delay_ms(100);
	MOVLW      2
	MOVWF      R11+0
	MOVLW      4
	MOVWF      R12+0
	MOVLW      186
	MOVWF      R13+0
L_main38:
	DECFSZ     R13+0, 1
	GOTO       L_main38
	DECFSZ     R12+0, 1
	GOTO       L_main38
	DECFSZ     R11+0, 1
	GOTO       L_main38
	NOP
;Secure.c,102 :: 		for(cursor=0; cursor<30; cursor++) {
	INCF       _cursor+0, 1
;Secure.c,122 :: 		}
	GOTO       L_main24
L_main25:
;Secure.c,123 :: 		LOCK_OUT = 0;
	BCF        RD0_bit+0, BitPos(RD0_bit+0)
;Secure.c,124 :: 		} else {
	GOTO       L_main39
L_main22:
;Secure.c,125 :: 		Lcd_Out(1, 4, "WRONG!");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr9_Secure+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;Secure.c,126 :: 		snd_err();
	CALL       _snd_err+0
;Secure.c,127 :: 		Delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main40:
	DECFSZ     R13+0, 1
	GOTO       L_main40
	DECFSZ     R12+0, 1
	GOTO       L_main40
	DECFSZ     R11+0, 1
	GOTO       L_main40
	NOP
	NOP
;Secure.c,128 :: 		}
L_main39:
;Secure.c,129 :: 		}
	GOTO       L_main9
;Secure.c,130 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
