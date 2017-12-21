#include "msp430usart.h"

module CarP @safe() {
	provides {
    interface Car;
	}
  uses {
    interface HplMsp430Usart;
    interface HplMsp430UsartInterrupts;
    interface Resource;
    interface HplMsp430GeneralIOC;
  }
} implementation {
  uint8_t type;
  uint16_t m_value;
  uint16_t max_speed;
  uint16_t min_speed;

// Anyone tell me what the hell are these three angle?
  command error_t Angle(uint16_t value) {
    type = 0x01;
    m_value = value;
    call Resource.request();
  }
  command error_t Angle_Senc(uint16_t value) {
    type = 0x07;
    m_value = value;
    call Resource.request();
  }
  command error_t Angle_Third(uint16_t value) {
    type = 0x08;
    m_value = value;
    call Resource.request();
  }
  command error_t Forward(uint16_t value) {
    type = 0x02;
    if (value < min_speed)
      value = min_speed;
    if (value > max_speed)
      value = max_speed;
    m_value = value;
    call Resource.request();
  }
  command	error_t Backward(uint16_t value) {
    type = 0x03;
    if (value < min_speed)
      value = min_speed;
    if (value > max_speed)
      value = max_speed;
    m_value = value;
    call Resource.request();
  }
  command	error_t Left(uint16_t value) {
    type = 0x04;
    m_value = value;
    call Resource.request();
  }
  command	error_t Right(uint16_t value) {
    type = 0x05;
    m_value = value;
    call Resource.request();
  }
// What should I do. 
  command	error_t QueryReader(uint16_t value) {
    type = 0x00;
  }
  command	error_t Pause() {
    type = 0x06;
    m_value = 0x0000;
    call Resource.request();
  }
  // event void readDone(error_t state, uint16_t data);

  command	error_t InitMaxSpeed(uint16_t value) {
    max_speed = value;
  }
  command	error_t InitMinSpeed(uint16_t value) {
    min_speed = value;
  }
// Anyone tell me what should I do with these three function?
  command	error_t InitLeftServo(uint16_t value) {
    type = 0x01;
    m_value = value;
    call Resource.request();
  }
  command	error_t InitRightServo(uint16_t value) {
    type = 0x07;
    m_value = value;
    call Resource.request();
  }
  command	error_t InitMidServo(uint16_t value) {
    type = 0x08;
    m_value = value;
    call Resource.request();
  }
  event void Resource.granted() {
    call HplMsp430Usart.setModeUart(config1);
    call HplMsp430Usart.enableUart();
    U0CTL &= ~SYNC; // how?
    call HplMsp430Usart.tx(0x01);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(0x02);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(type);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(m_value / 256);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(m_value % 256);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(0xFF);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(0xFF);
    while (!call HplUart.isTxEmpty());
    call HplMsp430Usart.tx(0x00);
    while (!call HplUart.isTxEmpty());
    call Resource.release();
  }
}
