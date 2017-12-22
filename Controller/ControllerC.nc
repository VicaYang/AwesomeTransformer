#include "Controller.h"

module ControllerC {
  uses interface Boot;
  uses interface Leds;
  uses interface Car;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  uses interface Timer<TMilli> as Timer0;
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  event void Boot.booted() {
    call AMControl.start();
    call Car.start();
    call Timer0.startPeriodic(1000);
  }

  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
  }
  event void Timer0.fired() {
    counter++;
    if (counter % 5 == 0) {
      call Car.Forward(300);
    }
    if (counter % 5 == 1) {
      call Car.Backward(300);
    }
    if (counter % 5 == 2) {
      call Car.Left(300);
    }
    if (counter % 5 == 3) {
      call Car.Right(300);
    }
    if (counter % 5 == 4) {
      call Car.Pause(0);
    }
  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(controller_msg_t)) {
      controller_msg_t* btrpkt = (controller_msg_t*)payload;
      switch (btrpkt->type) {
        case 0x01:
          call Car.Angle(btrpkt->value);
          break;
        case 0x02:
          call Car.Forward(btrpkt->value);
          break;
        case 0x03:
          call Car.Backward(btrpkt->value);
          break;
        case 0x04:
          call Car.Left(btrpkt->value);
          break;
        case 0x05:
          call Car.Right(btrpkt->value);
          break;
        case 0x06:
          call Car.Pause();
          break;
        case 0x07:
          call Car.Angle_Senc(btrpkt->value);
          break;
        case 0x08:
          call Car.Angle_Third(btrpkt->value);
          break;
      }
    }
    return msg;
  }
  event void Car.readDone(error_t error, uint8_t data) {
    if (error == SUCCESS) {
      call Leds.set(data);
    }
  }
}