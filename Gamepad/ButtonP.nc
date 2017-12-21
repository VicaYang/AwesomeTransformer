#include "../Controller/Controller.h"

module ButtonP @safe() {
	provides {
    interface Button;
	}
  uses {
    interface HplMsp430GeneralIO as PortA;
    interface HplMsp430GeneralIO as PortB;
    interface HplMsp430GeneralIO as PortC;
    interface HplMsp430GeneralIO as PortD;
    interface HplMsp430GeneralIO as PortE;
    interface HplMsp430GeneralIO as PortF;
  }
} implementation {
  command void pinvalueA() {
    error_t error = SUCCESS;
    bool isPressed = call PortA.get()
    signal pinvalueADone(error, isPressed);
  }
  command void pinvalueB() {
    error_t error = SUCCESS;
    bool isPressed = call PortB.get()
    signal pinvalueBDone(error, isPressed);
  }
  command void pinvalueC() {
    error_t error = SUCCESS;
    bool isPressed = call PortC.get()
    signal pinvalueCDone(error, isPressed);
  }
  command void pinvalueD() {
    error_t error = SUCCESS;
    bool isPressed = call PortD.get()
    signal pinvalueDDone(error, isPressed);
  }
  command void pinvalueE() {
    error_t error = SUCCESS;
    bool isPressed = call PortE.get()
    signal pinvalueEDone(error, isPressed);
  }
  command void pinvalueF() {
    error_t error = SUCCESS;
    bool isPressed = call PortF.get()
    signal pinvalueFDone(error, isPressed);
  }

  command void Button.start() {
    call PortA.clr()
    call PortA.makeInput();
    call PortB.clr()
    call PortB.makeInput();
    call PortC.clr()
    call PortC.makeInput();
    call PortD.clr()
    call PortD.makeInput();
    call PortE.clr()
    call PortE.makeInput();
    call PortF.clr()
    call PortF.makeInput();
    error_t error = SUCCESS;
    signal Button.startDone(error);
  }
  command void Button.stop() {
    error_t error = SUCCESS;
    signal Button.startDone(error);
  }
}