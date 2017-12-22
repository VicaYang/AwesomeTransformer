#ifndef CONTROLLER_H
#define CONTROLLER_H

enum {
  AM_CONTROLLER = 88,
  THRESHOLD = 1600,
  XMIN = THRESHOLD,
  XMAX = 4095 - THRESHOLD,
  YMIN = THRESHOLD,
  YMAX = 4095 - THRESHOLD,
  INTERVAL = 100
};

typedef nx_struct ControllerMsg {
  nx_uint8_t type;
  nx_uint16_t value;
} controller_msg_t;

#endif
