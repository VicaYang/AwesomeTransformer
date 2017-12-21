#include <Timer.h>
#include "../Controller/Controller.h"

module GamepadC {
  uses  {
    interface Boot;
    interface Leds;
    interface Timer<TMilli> as Timer0;
    interface Packet;
    interface AMPacket;
    interface AMSend;
    interface SplitControl as AMControl;
    interface Button;
    interface Read<uint16_t> as readX;
    interface Read<uint16_t> as readY;
  }        
} implementation {
  bool busy;
  void sendPkt(uint8_t type, uint16_t value) {
    if (!busy) {
      ControllerMsg* btrpkt = (ControllerMsg*)(call Packet.getPayload(&pkt, sizeof(ControllerMsg)));
      if (btrpkt == NULL) {
      	return;
      }
      btrpkt->type = type;
      btrpkt->value = value;
      if (call AMSend.send(CAR_NODE, &pkt, sizeof(ControllerMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }
  event void Boot.booted() {
    busy = FALSE;
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) {}
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  event void Button.startDone(error_t error) {
    if (error != SUCCESS) {
      call Button.start();
    }
  }
  event void Button.stopDone(error_t error) {

  }
  event void Button.pinvalueADone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x01, 0xff);
      }
    }
  }
  event void Button.pinvalueBDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x01, 0x0f);
      }
    }
  }
  event void Button.pinvalueCDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x07, 0xff);
      }
    }
  }
  event void Button.pinvalueDDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x07, 0x0f);
      }
    }
  }
  event void Button.pinvalueEDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x08, 0xff);
      }
    }
  }
  event void Button.pinvalueFDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        sendPkt(0x08, 0x0f);
      }
    }
  }

  event void readX.readDone(error_t error, uint16_t value) {
    if (error != SUCCESS) {
      call readX.read();
    } else {
      sendPkt(0x02, value);
    }
  }
  event void readY.readDone(error_t error, uint16_t value) {
    if (error != SUCCESS) {
      call readY.read();
    } else {
      sendPkt(0x04, value);
    }
  }
}