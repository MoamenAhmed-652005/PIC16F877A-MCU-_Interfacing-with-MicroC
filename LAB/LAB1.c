#define count_switch portd.f0
#define open_tens   portd.f1
#define open_units  portd.f2

void main() {
    char i, units, tens;
    trisd = 1;  trisb = 0;
    portb = 0;  portd = 0;

    while (count_switch == 0);

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
        open_units = 1;    delay_ms(10);    open_units = 0;  // 10 ms units
        portb = tens;
        open_tens = 1;     delay_ms(10);    open_tens = 0;   // 10 ms tens
    }
    // the for loop repeat it 50 times where (10ms+10ms)*50 = 1000ms = 1 second

    goto loop;
}