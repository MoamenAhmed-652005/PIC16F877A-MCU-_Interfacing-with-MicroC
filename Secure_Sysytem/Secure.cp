#line 1 "D:/LEVEL 2/MCUs/Secure_Sysytem/Secure.c"

sbit LCD_RS at RB2_bit;
sbit LCD_EN at RB3_bit;
sbit LCD_D4 at RB4_bit;
sbit LCD_D5 at RB5_bit;
sbit LCD_D6 at RB6_bit;
sbit LCD_D7 at RB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;






unsigned char pass[3];
unsigned char input[3] = {0, 0, 0};
unsigned char cursor = 0;
char txt_val[] = "000";


void snd_click() {  RD1_bit  = 1; Delay_ms(40);  RD1_bit  = 0; }
void snd_ok() { int i; for(i=0;i<3;i++){ RD1_bit =1; Delay_ms(80);  RD1_bit =0; Delay_ms(40);} }
void snd_err() {  RD1_bit  = 1; Delay_ms(800);  RD1_bit  = 0; }


void save_pass() {
 EEPROM_Write(0x00, pass[0]);
 EEPROM_Write(0x01, pass[1]);
 EEPROM_Write(0x02, pass[2]);
}

void load_pass() {
 pass[0] = EEPROM_Read(0x00);
 pass[1] = EEPROM_Read(0x01);
 pass[2] = EEPROM_Read(0x02);

 if(pass[0] > 9) { pass[0]=0; pass[1]=0; pass[2]=0; save_pass(); }
}

void show_digits() {
 txt_val[0] = input[0] + '0';
 txt_val[1] = input[1] + '0';
 txt_val[2] = input[2] + '0';
 Lcd_Out(2, 7, txt_val);

 Lcd_Chr(2, 7 + cursor, '_');
}

void main() {
 TRISD = 0x30;
  RD0_bit  = 0;  RD1_bit  = 0;

 Lcd_Init();
 load_pass();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1, 4, "SYSTEM READY");
 Delay_ms(1000);

 while(1) {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Enter Code:");
 cursor = 0; input[0]=0; input[1]=0; input[2]=0;


 while(cursor < 3) {
 show_digits();
 if( RD5_bit  == 1) {
 input[cursor]++;
 if(input[cursor] > 9) input[cursor] = 0;
 snd_click();
 while( RD5_bit  == 1);
 }
 if( RD4_bit  == 1) {
 cursor++;
 snd_click();
 while( RD4_bit  == 1);
 }
 }


 Lcd_Cmd(_LCD_CLEAR);
 if(input[0]==pass[0] && input[1]==pass[1] && input[2]==pass[2]) {
 Lcd_Out(1, 4, "CORRECT!");
 Lcd_Out(2, 3, "LOCK OPENED");
  RD0_bit  = 1;
 snd_ok();


 Delay_ms(1500);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Press ENTER to");
 Lcd_Out(2, 1, "Change Password");


 for(cursor=0; cursor<30; cursor++) {
 if( RD4_bit  == 1) {
 snd_click();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 1, "Set New Code:");

 cursor = 0; input[0]=0; input[1]=0; input[2]=0;
 while(cursor < 3) {
 show_digits();
 if( RD5_bit ==1){ input[cursor]++; if(input[cursor]>9)input[cursor]=0; snd_click(); while( RD5_bit ==1); }
 if( RD4_bit ==1){ pass[cursor]=input[cursor]; cursor++; snd_click(); while( RD4_bit ==1); }
 }
 save_pass();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1, 3, "CODE UPDATED!");
 snd_ok();
 Delay_ms(1000);
 break;
 }
 Delay_ms(100);
 }
  RD0_bit  = 0;
 } else {
 Lcd_Out(1, 4, "WRONG!");
 snd_err();
 Delay_ms(1000);
 }
 }
}
