#line 1 "D:/LEVEL 2/MCUs/LAB/LAB1.c"




void main() {
 char i, units, tens;
 trisd = 1; trisb = 0;
 portb = 0; portd = 0;

 while ( portd.f0  == 0);

loop:
 units++;
 if (units == 10)
 {
 units = 0;
 tens++;
 if (tens == 10) tens = 0;
 }

 for (i = 0; i < 50; i++) {
 portb = units;
  portd.f2  = 1; delay_ms(10);  portd.f2  = 0;
 portb = tens;
  portd.f1  = 1; delay_ms(10);  portd.f1  = 0;
 }


 goto loop;
}
