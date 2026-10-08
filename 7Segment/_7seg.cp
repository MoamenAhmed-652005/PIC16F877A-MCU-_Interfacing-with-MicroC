#line 1 "D:/LEVEL 2/MCUs/7Segment/_7seg.c"



void main()
{

unsigned char count = 0;
unsigned char segment[]= {0X3F, 0X06,0X5B,0X4F, 0X66, 0X6D,0X7D, 0X07,0X7F,0X6F};
TRISD = 1 ;
TRISB = 0 ;
 PORTB  = segment[0];
while ( PORTD.F0  == 0 );

loop: count++;

if (count == 10 ) count = 0;
 PORTB  = segment [count];
Delay_ms (1000);
goto loop;
}
