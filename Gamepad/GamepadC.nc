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
      btn[0] = btn[1] = btn[2] = btn[3] = btn[4] = btn[5] = FALSE;
      if (btrpkt == NULL) {
      	return;
      }
      call Leds.led0Toggle();
      btrpkt->type = type;
      btrpkt->value = value;
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(controller_msg_t)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }
  void check() {
    if ( ! (rd[0] && rd[1] && rd[2] && rd[3] && rd[4] && rd[5] && rd[6] && rd[7]) ) return;
    rd[0] = rd[1] = rd[2] = rd[3] = rd[4] = rd[5] = rd[6] = rd[7] = FALSE;
    // crazy direction with led......
    if (x < XMIN) { // Forward
      type = 0x02;
      value = (XMIN - x);
      stop = FALSE;
      sendPkt();
      return;
    } 
    if (x > XMAX) { // Backword
      type = 0x03;
      value = (x - XMAX);
      stop = FALSE;
      sendPkt();
      return;
    }
    if (y < YMIN) { // Left
      type = 0x04;
      value = (YMIN - y);
      stop = FALSE;
      sendPkt();
      return;
    }
    if (y > YMAX) { // Right
      type = 0x05;
      value = (y - YMAX);
      stop = FALSE;
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
    if (btn[0] == TRUE && btn[2] == TRUE && btn[4] == TRUE) {
      type = 0x10;
      value = 0;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[0] == TRUE) {
      type = 0x01;
      value = 0;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[1] == TRUE) {
      type = 0x01;
      value = 1;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[2] == TRUE) {
      type = 0x07;
      value = 0;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[3] == TRUE) {
      type = 0x07;
      value = 1;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[4] == TRUE) {
      type = 0x08;
      value = 0;
      stop = FALSE;
      sendPkt();
      return;
    }
    if (btn[5] == TRUE) {
      type = 0x08;
      value = 1;
      stop = FALSE;
      sendPkt();
      return;
    }
    
  }
  event void Boot.booted() {
    busy = FALSE;
    stop = TRUE;
    call Leds.set(7);
    rd[0] = rd[1] = rd[2] = rd[3] = rd[4] = rd[5] = rd[6] = rd[7] = FALSE;
    btn[0] = btn[1] = btn[2] = btn[3] = btn[4] = btn[5] = FALSE;
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
      rd[0] = TRUE;
      btn[0] = isPressed;
      check();
    }
  }
  event void Button.pinvalueBDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueB();
    } else {
      rd[1] = TRUE;
      btn[1] = isPressed;
      check();
    }
  }
  event void Button.pinvalueCDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueC();
    } else {
      rd[2] = TRUE;
      btn[2] = isPressed;
      check();
    }
  }
  event void Button.pinvalueDDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueD();
    } else {
      rd[3] = TRUE;
      btn[3] = isPressed;
      check();
    }
  }
  event void Button.pinvalueEDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueE();
    } else {
      rd[4] = TRUE;
      btn[4] = isPressed;
      check();
    }
  }
  event void Button.pinvalueFDone(error_t error, bool isPressed) {
    if (error != SUCCESS) {
      call Button.pinvalueF();
    } else {
      rd[5] = TRUE;
      btn[5] = isPressed;
      check();
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

