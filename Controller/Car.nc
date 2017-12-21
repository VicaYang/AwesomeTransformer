#include "Controller.h"
#include <msp430usart.h>

interface Car {
//  command void Start();
  command	error_t Angle(uint16_t value);
  command	error_t Angle_Senc(uint16_t value);
  command	error_t Angle_Third(uint16_t value);
  command	error_t Forward(uint16_t value);
  command	error_t Backward(uint16_t value); // modified
  command	error_t Left(uint16_t value);
  command error_t Right(uint16_t value);
//  command	error_t QueryReader(uint16_t value); // modified
  command	error_t Pause();
  async command read();
  event void readDone(error_t state, uint8_t data);
  command	error_t InitMaxSpeed(uint16_t value);
  command	error_t InitMinSpeed(uint16_t value);
  command	error_t InitLeftServo(uint16_t value);
  command	error_t InitRightServo(uint16_t value);
  command	error_t InitMidServo(uint16_t value);
}
