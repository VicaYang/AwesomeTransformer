#include "msp430usart.h"
configuration CarC {
	provides {
    interface Car;
	}
} implementation {
  components CarP;
  Car = CarP;

  components HplMsp430Usart0C;
  components Msp430Uart0C;
  components HplMsp430GeneralIOC
  CarP.HplMsp430Usart -> HplMsp430Usart0C;
  CarP.HplMsp430UsartInterrupts -> HplMsp430Usart0C;
  CarP.Resource -> Msp430UartOC;
  CarP.HplMsp430GeneralIOC -> HplMsp430GeneralIOC.Port20;
}
