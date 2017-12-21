#include <msp430usart.h>
configuration CarC {
	provides {
    interface Car;
	}
} implementation {
  components CarP;
  Car = CarP;

  components HplMsp430Usart0C;
  components new Msp430Uart0C();
  components HplMsp430GeneralIOC;
  CarP.HplMsp430Usart -> HplMsp430Usart0C;
  CarP.HplMsp430UsartInterrupts -> HplMsp430Usart0C;
  CarP.Resource -> Msp430Uart0C;
  CarP.HplMsp430GeneralIO -> HplMsp430GeneralIOC.Port20;
}
