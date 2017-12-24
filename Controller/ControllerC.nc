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
    call Leds.set(7);
    call AMControl.start();
    call Car.start();
    call Timer0.startOneShot(1500);//display mode
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
    switch(counter) {
      case 0:
        call Car.Forward(800);
        break;
      case 1:
        call Car.Backward(800);
        break;
      case 2:
        call Car.Left(800);
        break;
      case 3:
        call Car.Right(800);
        break;
      case 4:
        call Car.Pause();
        break;
      case 5:
        call Car.Angle(2400);
        break;
      case 6:
        call Car.Angle(4400);
        break;
      case 7:
        call Car.Angle_Senc(2400);
        break;
      case 8:
        call Car.Angle_Senc(4400);
        break;
      case 9:
        call Car.Angle_Third(2400);
        break;
      case 10:
        call Car.Angle_Third(4400);
        break;
      case 11:
        call Car.Home();
        break;
    }
    call Car.read();
    counter++;
    if (counter < 12) {
      call Timer0.startOneShot(2000);
    }
  }
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
    if (len == sizeof(controller_msg_t)) {
      controller_msg_t* btrpkt = (controller_msg_t*)payload;
      switch (btrpkt->type) {
        case 0x01:
          call Car.Angle(btrpkt->value);
          call Car.read();
          break;
        case 0x02:
          call Car.Forward(btrpkt->value);
          call Car.read();
          break;
        case 0x03:
          call Car.Backward(btrpkt->value);
          call Car.read();
          break;
        case 0x04:
          call Car.Left(btrpkt->value);
          call Car.read();
          break;
        case 0x05:
          call Car.Right(btrpkt->value);
          call Car.read();
          break;
        case 0x06:
          call Car.Pause();
          call Car.read();
          break;
        case 0x07:
          call Car.Angle_Senc(btrpkt->value);
          call Car.read();
          break;
        case 0x08:
          call Car.Angle_Third(btrpkt->value);
          call Car.read();
          break;
        case 0x10:
          call Car.Home();
          call Car.read();
          break;
      }
    }
    return msg;
  }
  event void Car.readDone(error_t error, uint8_t data) {
    if (error == SUCCESS) {
      switch(data) {
        case 0x02:
          call Leds.set(2);
          break;
        case 0x03:
          call Leds.set(6);
          break;
        case 0x04:
          call Leds.set(4);
          break;
        case 0x05:
          call Leds.set(1);
          break;
        case 0x06:
          call Leds.set(0);
          break;
        case 0x01:
          call Leds.set(3);
          break;
        case 0x07:
          call Leds.set(5);
          break;
        case 0x08:
          call Leds.set(7);
          break;
        default:
          call Leds.set(0);
          break;
      }
    }
  }
}
