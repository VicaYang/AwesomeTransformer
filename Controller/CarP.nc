#include <msp430usart.h>
#include "Controller.h"

module CarP @safe() {
	provides {
    interface Car;
	}
  uses {
    interface HplMsp430Usart;
    interface HplMsp430UsartInterrupts;
    interface Resource;
    interface HplMsp430GeneralIO;
  }
} implementation {
  uint8_t type;
  uint16_t m_value;
  uint16_t max_speed;
  uint16_t min_speed;

  const msp430_uart_union_config_t config1 = {
    utxe: 1,
    urxe: 1,
    ubr: UBR_1MHZ_115200,
    umctl: UMCTL_1MHZ_115200,
    ssel: 0x02,
    pena: 0,
    pev: 0,
    clen: 1,
    listen: 0,
    mm: 0,
    ckpl: 0,
    urxse: 0,
    urxeie: 0,
    urxwie: 0,
    utxe: 1,
    urxe: 1
  };

  async event void HplMsp430UsartInterrupts.rxDone(uint8_t data) {
  }
  async event void HplMsp430UsartInterrupts.txDone() {
  }
  async command void read() {
    error_t error = SUCCESS;
    signal readDone(error, type);
  }
// Anyone tell me what the hell are these three angle?
  command error_t Car.Angle(uint16_t value) {
    type = 0x01;
    m_value = value;
    return call Resource.request();
  }
  command error_t Car.Angle_Senc(uint16_t value) {
    type = 0x07;
    m_value = value;
    return call Resource.request();
  }
  command error_t Car.Angle_Third(uint16_t value) {
    type = 0x08;
    m_value = value;
    return call Resource.request();
  }
  command error_t Car.Forward(uint16_t value) {
    type = 0x02;
    if (value < min_speed)
      value = min_speed;
    if (value > max_speed)
      value = max_speed;
    m_value = value;
    return call Resource.request();
  }
  command	error_t Car.Backward(uint16_t value) {
    type = 0x03;
    if (value < min_speed)
      value = min_speed;
    if (value > max_speed)
      value = max_speed;
    m_value = value;
    return call Resource.request();
  }
  command	error_t Car.Left(uint16_t value) {
    type = 0x04;
    m_value = value;
    return call Resource.request();
  }
  command	error_t Car.Right(uint16_t value) {
    type = 0x05;
    m_value = value;
    return call Resource.request();
  }
// What should I do. 
  command	error_t Car.QueryReader(uint16_t value) {
    type = 0x00;
    return SUCCESS;
  }
  command	error_t Car.Pause() {
    type = 0x06;
    m_value = 0x0000;
    return call Resource.request();
  }
//  event void readDone(error_t state, uint16_t data);

  command	error_t Car.InitMaxSpeed(uint16_t value) {
    max_speed = value;
    return SUCCESS;
  }
  command	error_t Car.InitMinSpeed(uint16_t value) {
    min_speed = value;
    return SUCCESS;
  }
// Anyone tell me what should I do with these three function?
  command	error_t Car.InitLeftServo(uint16_t value) {
    type = 0x01;
    m_value = value;
    return call Resource.request();
  }
  command	error_t Car.InitRightServo(uint16_t value) {
    type = 0x07;
    m_value = value;
    return call Resource.request();
  }
  command	error_t Car.InitMidServo(uint16_t value) {
    type = 0x08;
    m_value = value;
    return call Resource.request();
  }
  event void Resource.granted() {
    call HplMsp430Usart.setModeUart(&config1);
    call HplMsp430Usart.enableUart();
    U0CTL &= ~SYNC; // how?
    call HplMsp430Usart.tx(0x01);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(0x02);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(type);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(m_value / 256);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(m_value % 256);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(0xFF);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(0xFF);
    while (!call HplMsp430Usart.isTxEmpty());
    call HplMsp430Usart.tx(0x00);
    while (!call HplMsp430Usart.isTxEmpty());
    call Resource.release();
  }
}
