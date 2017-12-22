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
  bool stop;
  bool btn[6];
  bool rd[8];
  uint16_t x;
  uint16_t y;
  uint8_t type;
  uint16_t value;
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
  void check() {
    if ( ! (rd[0] && rd[1] && rd[2] && rd[3] && rd[4] && rd[5] && rd[6] && rd[7]) ) return;
    rd[0] = rd[1] = rd[2] = rd[3] = rd[4] = rd[5] = rd[6] = rd[7] = FALSE;
    if (x < XMIN) { // Forward
      sendPkt(0x02, (XMIN - x) / 2);
      return;
    } 
    if (x > XMAX) { // Backword
      sendPkt(0x03, (x - XMAX) / 2);
      return;
    }
    if (y < YMIN) { // Left
      sendPkt(0x04, (YMIN - y) / 2);
      return;
    }
    if (y > YMAX) { // Right
      sendPkt(0x05, (Y - YMAX) / 2);
      return;
    }
    if (stop == FALSE) { // not stop so need to stop now
      stop = TRUE;
      sendPkt(0x06, 0);
      return;
    }
    if (btn[0] == TRUE) {
      sendPkt(0x01, 0);
      return;
    }
    if (btn[1] == TRUE) {
      sendPkt(0x01, 1);
      return;
    }
    if (btn[2] == TRUE) {
      sendPkt(0x01, 0);
      return;
    }
    if (btn[3] == TRUE) {
      sendPkt(0x01, 1);
      return;
    }
    if (btn[4] == TRUE) {
      sendPkt(0x01, 0);
      return;
    }
    if (btn[5] == TRUE) {
      sendPkt(0x01, 1);
      return;
    }
    
  }
  event void Boot.booted() {
    busy = FALSE;
    stop = FALSE;
    readTimes = 8;
    call AMControl.start();
    call Timer0.startPeriodic(INTERVAL);
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
        btn[0] = isPressed;
        rd[0] = true;
        check();
      }
    }
  }
  event void Button.pinvalueBDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        btn[1] = isPressed;
        rd[1] = true;
        check();
      }
    }
  }
  event void Button.pinvalueCDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        btn[2] = isPressed;
        rd[2] = true;
        check();
      }
    }
  }
  event void Button.pinvalueDDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        btn[3] = isPressed;
        rd[3] = true;
        check();
      }
    }
  }
  event void Button.pinvalueEDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        btn[4] = isPressed;
        rd[4] = true;
        check();
      }
    }
  }
  event void Button.pinvalueFDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueA();
    } else {
      if (isPressed == TRUE) {
        btn[5] = isPressed;
        rd[5] = true;
        check();
      }
    }
  }

  event void readX.readDone(error_t error, uint16_t value) {
    if (error != SUCCESS) {
      call readX.read();
    } else {
      x = value;
      rd[6] = true;
      check();
    }
  }
  event void readY.readDone(error_t error, uint16_t value) {
    if (error != SUCCESS) {
      call readY.read();
    } else {
      y = value;
      rd[7] = true;
      check();
    }
  }
}