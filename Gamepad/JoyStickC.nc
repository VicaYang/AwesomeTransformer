#include <Msp430Adc12.h>
generic configuration JoyStickC() {
  provides {
    interface Read<uint16_t> as readX;
    interface Read<uint16_t> as readY;
  }
} implementation {
  components AdcReadClientC as Xadc;
  components AdcReadClientC as Yadc;
  components JoyStickP;
  readX = Xadc.Read;
  readY = Yadc.Read;
  Xadc.AdcConfigure -> JoyStickP.Xconf;
  Yadc.AdcConfigure -> JoyStickP.Yconf;
}