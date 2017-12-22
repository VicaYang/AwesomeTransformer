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
  message_t pkt;
  void sendPkt() {
    if (!busy) {
      controller_msg_t* btrpkt = (controller_msg_t*)(call Packet.getPayload(&pkt, sizeof(controller_msg_t)));
      if (btrpkt == NULL) {
      	return;
      }
      btrpkt->type = type;
      btrpkt->value = value;
      if (call AMSend.send(CAR_NODE, &pkt, sizeof(controller_msg_t)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }
  void check() {
    if ( ! (rd[0] && rd[1] && rd[2] && rd[3] && rd[4] && rd[5] && rd[6] && rd[7]) ) return;
    rd[0] = rd[1] = rd[2] = rd[3] = rd[4] = rd[5] = rd[6] = rd[7] = FALSE;
    if (x < XMIN) { // Forward
      type = 0x02;
      value = (XMIN - x) / 2;
      sendPkt();
      return;
    } 
    if (x > XMAX) { // Backword
      type = 0x03;
      value = (x - XMAX) / 2;
      sendPkt();
      return;
    }
    if (y < YMIN) { // Left
      type = 0x04;
      value = (YMIN - y) / 2;
      sendPkt();
      return;
    }
    if (y > YMAX) { // Right
      type = 0x05;
      value = (y - YMAX) / 2;
      sendPkt();
      return;
    }
    if (stop == FALSE) { // not stop so need to stop now
      stop = TRUE;
      type = 0x06;
      value = 0;
      sendPkt();
      return;
    }
    if (btn[0] == TRUE) {
      type = 0x01;
      value = 0;
      sendPkt();
      return;
    }
    if (btn[1] == TRUE) {
      type = 0x01;
      value = 1;
      sendPkt();
      return;
    }
    if (btn[2] == TRUE) {
      type = 0x07;
      value = 0;
      sendPkt();
      return;
    }
    if (btn[3] == TRUE) {
      type = 0x07;
      value = 1;
      sendPkt();
      return;
    }
    if (btn[4] == TRUE) {
      type = 0x08;
      value = 0;
      sendPkt();
      return;
    }
    if (btn[5] == TRUE) {
      type = 0x08;
      value = 1;
      sendPkt();
      return;
    }
    
  }
  event void Boot.booted() {
    busy = FALSE;
    stop = TRUE;
    rd[0] = rd[1] = rd[2] = rd[3] = rd[4] = rd[5] = rd[6] = rd[7] = FALSE;
    call AMControl.start();
    call Timer0.startPeriodic(INTERVAL);
  }

  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    call Button.pinvalueA();
    call Button.pinvalueB();
    call Button.pinvalueC();
    call Button.pinvalueD();
    call Button.pinvalueE();
    call Button.pinvalueF();
    call readX.read();
    call readY.read();
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
        rd[0] = TRUE;
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
        rd[1] = TRUE;
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
        rd[2] = TRUE;
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
        rd[3] = TRUE;
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
        rd[4] = TRUE;
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
        rd[5] = TRUE;
        check();
      }
    }
  }

  event void readX.readDone(error_t error, uint16_t data) {
    if (error != SUCCESS) {
      call readX.read();
    } else {
      x = data;
      rd[6] = TRUE;
      check();
    }
  }
  event void readY.readDone(error_t error, uint16_t data) {
    if (error != SUCCESS) {
      call readY.read();
    } else {
      y = data;
      rd[7] = TRUE;
      check();
    }
  }
}