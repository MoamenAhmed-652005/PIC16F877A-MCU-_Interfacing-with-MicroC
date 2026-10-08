// ================= LCD =================
sbit LCD_RS at RD2_bit;
sbit LCD_EN at RD3_bit;
sbit LCD_D4 at RD4_bit;
sbit LCD_D5 at RD5_bit;
sbit LCD_D6 at RD6_bit;
sbit LCD_D7 at RD7_bit;
sbit LCD_RS_Direction at TRISD2_bit;
sbit LCD_EN_Direction at TRISD3_bit;
sbit LCD_D4_Direction at TRISD4_bit;
sbit LCD_D5_Direction at TRISD5_bit;
sbit LCD_D6_Direction at TRISD6_bit;
sbit LCD_D7_Direction at TRISD7_bit;
// ================= Motors =================
sbit M1_IN1 at RB0_bit;
sbit M1_IN2 at RB1_bit;
sbit M2_IN1 at RB2_bit;
sbit M2_IN2 at RB3_bit;
// ================= Buttons =================
#define BTN_M1 PORTB.F4
#define BTN_M2 PORTB.F5
// ================= Variables =================
unsigned int pot1, pot2;
unsigned char speed1, speed2;
char dir1 = 'F';
char dir2 = 'F';
char txt[6];
unsigned char lastBtn1 = 1;
unsigned char lastBtn2 = 1;


void displayStatus() {
    Lcd_Cmd(_LCD_CLEAR);

    Lcd_Out(1,1,"M1:");
    Lcd_Chr(1,4,dir1);
    ByteToStr(speed1, txt);
    Lcd_Out(1,6,txt);

    Lcd_Out(2,1,"M2:");
    Lcd_Chr(2,4,dir2);
    ByteToStr(speed2, txt);
    Lcd_Out(2,6,txt);
}


// ================= Main =================
void main() {

    // LCD
    TRISD = 0;
    Lcd_Init();
    Lcd_Cmd(_LCD_CURSOR_OFF);

    // Motors
    TRISB = 0b00110000;   // Buttons B4 ,B5

    // ADC
    ADC_Init();

    // PWM
    PWM1_Init(1000);
    PWM2_Init(1000);
    PWM1_Start();
    PWM2_Start();

    OPTION_REG.F7 = 0;   // Enable PORTB pull-ups

    while(1) {

        // ===== Read Potentiometers =====
        pot1 = ADC_Read(0);   // RA0
        pot2 = ADC_Read(1);   // RA1

        speed1 = pot1 / 4;    // 0–255
        speed2 = pot2 / 4;

        PWM1_Set_Duty(speed1);
        PWM2_Set_Duty(speed2);

        // ===== Direction Control =====
       if(BTN_M1 == 0 && lastBtn1 == 1) {
         dir1 = (dir1 == 'F') ? 'R' : 'F';
      }
       lastBtn1 = BTN_M1;

      if(BTN_M2 == 0 && lastBtn2 == 1) {
        dir2 = (dir2 == 'F') ? 'R' : 'F';
        }
      lastBtn2 = BTN_M2;


        // Motor 1 direction
        if(dir1 == 'F') { M1_IN1 = 1; M1_IN2 = 0; }
        else           { M1_IN1 = 0; M1_IN2 = 1; }

        // Motor 2 direction
        if(dir2 == 'F') { M2_IN1 = 1; M2_IN2 = 0; }
        else           { M2_IN1 = 0; M2_IN2 = 1; }

        displayStatus();
        Delay_ms(200);
    }
}