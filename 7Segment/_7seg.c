#define Display PORTB
#define start PORTD.F0

void main()
{

unsigned char count = 0;
unsigned char segment[]= {0X3F, 0X06,0X5B,0X4F, 0X66, 0X6D,0X7D, 0X07,0X7F,0X6F};
TRISD = 1 ;
TRISB = 0 ;
Display = segment[0];
while (start == 0 );

loop: count++;

if (count == 10 ) count = 0;
Display = segment [count];
Delay_ms (1000);
goto loop;
}