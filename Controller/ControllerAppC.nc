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
  Controller.Car -> CarC;

  ControllerC.Packet -> AM;
  ControllerC.AMPacket -> AM.Packet;
  ControllerC.AMControl -> AM;
  ControllerC.AMSend -> AM.AMSend[AM_CONTROLLER];
  ControllerC.Receive -> AM.Receive[AM_CONTROLLER];
}