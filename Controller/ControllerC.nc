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
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  event void Boot.booted() {
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err != SUCCESS) {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    // useless?
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
  event void Car.readDone(error_t state, uint16_t data) {
    if (state == SUCCESS) {
      call Leds.set(data);
    }
  }
}