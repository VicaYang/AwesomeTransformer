configuration CarAppC {
} implementation {
  components HplMsp430UsartOC;
  components Msp430UartOC;
  components HplMsp430GeneralIOC;
  components CarC;

  CarC.HplMsp430Usart -> HplMsp430UsartOC;
  CarC.HplMsp430UsartInterrupts -> HplMsp430UsartOC;
  CarC.Resource -> Msp430UartOC;
  CarC.HplMsp430GeneralIOC -> HplMsp430GeneralIOC.Port20;
}