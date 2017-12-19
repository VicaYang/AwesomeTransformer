#ifndef CONTROLLER_H
#define CONTROLLER_H

enum {
  AM_CONTROLLER = 88
};

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

#endif