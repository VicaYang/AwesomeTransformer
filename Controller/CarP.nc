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
  uint16_t min_angel;
  uint16_t max_angel;
  uint16_t angel1;
  uint16_t angel2;
  uint16_t angel3;

  msp430_uart_union_config_t config1 = {
    {
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
    }
  };

  async event void HplMsp430UsartInterrupts.rxDone(uint8_t data) {
  }
  async event void HplMsp430UsartInterrupts.txDone() {
  }
  async command void Car.read() {
    error_t error = SUCCESS;
    signal Car.readDone(error, type);
  }
  command void Car.start() {
    angel1 = 3400;
    angel2 = 3400;
    angel3 = 3400;
    min_angel = 1800;
    max_angel = 5200;
    call Car.InitMaxSpeed(800);
    call Car.InitMinSpeed(0);
    call Car.InitLeftServo(angel1);
    call Car.InitMidServo(angel2);
    call Car.InitRightServo(angel3);
  }
  command error_t Car.Angle(uint16_t value) {
    atomic {
      type = 0x01;
      if (value == 1) {
        angel1 -= 100;
        if (angel1 < min_angel) {
          angel1 = min_angel;
        }
      } else {
        angel1 += 100;
        if (angel1 > max_angel) {
          angel1 = max_angel;
        }
      }
    }
    m_value = angel1;
    return call Resource.request();
  }
  command error_t Car.Angle_Senc(uint16_t value) {
    atomic {
      type = 0x07;
      if (value == 1) {
        angel2 -= 100;
        if (angel2 < min_angel) {
          angel2 = min_angel;
        }
      } else {
        angel2 += 100;
        if (angel2 > max_angel) {
          angel2 = max_angel;
        }
      }
      m_value = angel2;
    }
    return call Resource.request();
  }
  command error_t Car.Angle_Third(uint16_t value) {
    atomic {
      type = 0x08;
      if (value == 1) {
        angel3 -= 100;
        if (angel3 < min_angel) {
          angel3 = min_angel;
        }
      } else {
        angel3 += 100;
        if (angel3 > max_angel) {
          angel3 = max_angel;
        }
      }
      m_value = angel3;
    }
    return call Resource.request();
  }
  command error_t Car.Forward(uint16_t value) {
    atomic {
      type = 0x02;
      if (value < min_speed)
        value = min_speed;
      if (value > max_speed)
        value = max_speed;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.Backward(uint16_t value) {
    atomic {
      type = 0x03;
      if (value < min_speed)
        value = min_speed;
      if (value > max_speed)
        value = max_speed;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.Left(uint16_t value) {
    atomic {
      type = 0x04;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.Right(uint16_t value) {
    atomic {
      type = 0x05;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.Pause() {
    atomic {
      type = 0x06;
      m_value = 0x0000;
    }
    return call Resource.request();
  }

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
    atomic {
      type = 0x01;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.InitRightServo(uint16_t value) {
    atomic {
      type = 0x07;
      m_value = value;
    }
    return call Resource.request();
  }
  command	error_t Car.InitMidServo(uint16_t value) {
    atomic {
      type = 0x08;
      m_value = value;
    }
    return call Resource.request();
  }
  event void Resource.granted() {
    call HplMsp430Usart.setModeUart(&config1);
    call HplMsp430Usart.enableUart();
    atomic {
      U0CTL &= ~SYNC;
    }
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
