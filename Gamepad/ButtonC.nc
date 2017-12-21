#include "../Controller/Controller.h"
#include "Msp430Adc12.h"
configuration ButtonC {
	provides {
    interface Button;
	}
} implementation {
  components ButtonP;
  Button = ButtonP;

  components HplMsp430GeneralIOC
  Button.PortA = HplMsp430GeneralIOC.Port60;
  Button.PortB = HplMsp430GeneralIOC.Port21;
  Button.PortC = HplMsp430GeneralIOC.Port61;
  Button.PortD = HplMsp430GeneralIOC.Port23;
  Button.PortE = HplMsp430GeneralIOC.Port62;
  Button.PortF = HplMsp430GeneralIOC.Port26;
}