#include "Controller.h"

configuration ControllerAppC {
}
implementation {
  components MainC;
  components LedsC;
  components ControllerC;
  components ActiveMessageC as AM;
  components CarC;

  ControllerC.Boot -> MainC;
  ControllerC.Leds -> LedsC;
  ControllerC.Car -> CarC;

  ControllerC.Packet -> AM;
  ControllerC.AMPacket -> AM.AMPacket;
  ControllerC.AMControl -> AM;
  ControllerC.AMSend -> AM.AMSend[AM_CONTROLLER];
  ControllerC.Receive -> AM.Receive[AM_CONTROLLER];
}