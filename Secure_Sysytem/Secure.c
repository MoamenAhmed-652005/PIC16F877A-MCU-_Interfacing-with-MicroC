// ≈⁄œ«œ«  LCD (Õ”» »—Ê ”)
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

#define BTN_ENTER  RD4_bit
#define BTN_COUNT  RD5_bit
#define LOCK_OUT   RD0_bit
#define BUZZER     RD1_bit

unsigned char pass[3];
unsigned char input[3] = {0, 0, 0};
unsigned char cursor = 0;
char txt_val[] = "000";

// --- ÊŸ«∆› «·’Ê  ---
void snd_click() { BUZZER = 1; Delay_ms(40); BUZZER = 0; }
void snd_ok()    { int i; for(i=0;i<3;i++){BUZZER=1; Delay_ms(80); BUZZER=0; Delay_ms(40);} }
void snd_err()   { BUZZER = 1; Delay_ms(800); BUZZER = 0; }

// --- ÊŸ«∆› «·–«ﬂ—… EEPROM ---
void save_pass() {
    EEPROM_Write(0x00, pass[0]);
    EEPROM_Write(0x01, pass[1]);
    EEPROM_Write(0x02, pass[2]);
}

void load_pass() {
    pass[0] = EEPROM_Read(0x00);
    pass[1] = EEPROM_Read(0x01);
    pass[2] = EEPROM_Read(0x02);
    // ·Ê «·–«ﬂ—… ›«—€… (√Ê· „—…  ‘€Ì·) «Ã⁄· «·»«”Ê—œ 000
    if(pass[0] > 9) { pass[0]=0; pass[1]=0; pass[2]=0; save_pass(); }
}

void show_digits() {
    txt_val[0] = input[0] + '0';
    txt_val[1] = input[1] + '0';
    txt_val[2] = input[2] + '0';
    Lcd_Out(2, 7, txt_val);
    // Ê÷⁄ „ƒ‘—  Õ  «·—ﬁ„ «·‰‘ÿ
    Lcd_Chr(2, 7 + cursor, '_');
}

void main() {
    TRISD = 0x30; // 0011 0000 (RD4, RD5 œŒ·)
    LOCK_OUT = 0; BUZZER = 0;

    Lcd_Init();
    load_pass(); //  Õ„Ì· «·»«”Ê—œ „‰ «·–«ﬂ—…
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_Cmd(_LCD_CURSOR_OFF);
    Lcd_Out(1, 4, "SYSTEM READY");
    Delay_ms(1000);

    while(1) {
        Lcd_Cmd(_LCD_CLEAR);
        Lcd_Out(1, 1, "Enter Code:");
        cursor = 0; input[0]=0; input[1]=0; input[2]=0;

        // Õ·ﬁ… ≈œŒ«· 3 √—ﬁ«„
        while(cursor < 3) {
            show_digits();
            if(BTN_COUNT == 1) {
                input[cursor]++;
                if(input[cursor] > 9) input[cursor] = 0;
                snd_click();
                while(BTN_COUNT == 1);
            }
            if(BTN_ENTER == 1) {
                cursor++;
                snd_click();
                while(BTN_ENTER == 1);
            }
        }

        // ›Õ’ «·ﬂÊœ »⁄œ ≈ „«„ «·‹ 3 Œ«‰« 
        Lcd_Cmd(_LCD_CLEAR);
        if(input[0]==pass[0] && input[1]==pass[1] && input[2]==pass[2]) {
            Lcd_Out(1, 4, "CORRECT!");
            Lcd_Out(2, 3, "LOCK OPENED");
            LOCK_OUT = 1;
            snd_ok();

            // «‰ Ÿ— ﬁ·Ì·« À„ «”√· ⁄‰ «· €ÌÌ—
            Delay_ms(1500);
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_Out(1, 1, "Press ENTER to");
            Lcd_Out(2, 1, "Change Password");

            // „Â·… 3 ÀÊ«‰Ì ··÷€ÿ ⁄·Ï ENTER ·Ê ⁄«Ì“  €Ì—
            for(cursor=0; cursor<30; cursor++) {
                if(BTN_ENTER == 1) {
                    snd_click();
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1, 1, "Set New Code:");
                    // ⁄„·Ì… ≈œŒ«· ﬂÊœ ÃœÌœ
                    cursor = 0; input[0]=0; input[1]=0; input[2]=0;
                    while(cursor < 3) {
                        show_digits();
                        if(BTN_COUNT==1){ input[cursor]++; if(input[cursor]>9)input[cursor]=0; snd_click(); while(BTN_COUNT==1); }
                        if(BTN_ENTER==1){ pass[cursor]=input[cursor]; cursor++; snd_click(); while(BTN_ENTER==1); }
                    }
                    save_pass(); // Õ›Ÿ ›Ì «·–«ﬂ—… ··√»œ
                    Lcd_Cmd(_LCD_CLEAR);
                    Lcd_Out(1, 3, "CODE UPDATED!");
                    snd_ok();
                    Delay_ms(1000);
                    break;
                }
                Delay_ms(100);
            }
            LOCK_OUT = 0;
        } else {
            Lcd_Out(1, 4, "WRONG!");
            snd_err();
            Delay_ms(1000);
        }
    }
}