#include <avr/io.h>
#include <util/delay.h> 

#ifndef LED_BUILTIN
#define LED_BUILTIN _BV(PORTB5)
#endif

int main(void) 
{
    DDRB |= LED_BUILTIN;

    while (1)
    {
        PORTB |= LED_BUILTIN;   // turn on led
        _delay_ms(1000);        // delay 1s

        PORTB &= ~LED_BUILTIN;  // turn off led
        _delay_ms(1000);        // delay 1s
    }                                                
}
