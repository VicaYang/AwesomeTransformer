#ifndef CONTROLLER_H
#define CONTROLLER_H

enum {
  AM_CONTROLLER = 88,
  CAR_NODE = 0
};

typedef nx_struct ControllerMsg {
  nx_uint8_t type;
  nx_uint16_t value;
} controller_msg_t;

#endif