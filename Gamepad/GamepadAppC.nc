#include <Timer.h>
#include "../Controller/Controller.h"

configuration GamepadAppC {
} implementation {
  components MainC;
  components LedsC;
  components GamepadC;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC as AM;

  GamepadC.Boot -> MainC;
  GamepadC.Leds -> LedsC;
  GamepadC.Timer0 -> Timer0;

  GamepadC.Packet -> AM;
  GamepadC.AMPacket -> AM.Packet;
  GamepadC.AMControl -> AM;
  GamepadC.AMSend -> AM.AMSend[AM_CONTROLLER];
  GamepadC.Receive -> AM.Receive[AM_CONTROLLER];
}