#include <Timer.h>
#include "Controller.h"

configuration ControllerAppC {
}
implementation {
  components MainC;
  components LedsC;
  components ControllerC;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC as AM;
  components new CarC();

  ControllerC.Boot -> MainC;
  ControllerC.Leds -> LedsC;
  ControllerC.Timer0 -> Timer0;
  Controller.Car -> CarC;

  ControllerC.Packet -> AM;
  ControllerC.AMPacket -> AM.Packet;
  ControllerC.AMControl -> AM;
  ControllerC.AMSend -> AM.AMSend[AM_CONTROLLER];
  ControllerC.Receive -> AM.Receive[AM_CONTROLLER];
}