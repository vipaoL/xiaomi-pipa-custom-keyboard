#include <Arduino.h>

#include "keyboard.h"
#include "touchpad.h"
#include "display.h"
#include "protocol.h"
#include "config.h"

void setup() {
  pinMode(CAPS_LED_PIN, OUTPUT);
  digitalWrite(CAPS_LED_PIN, LOW);

  initDisplay();
  initKeyboard();
  initProtocol();
  initTouchpad();

  digitalWrite(CAPS_LED_PIN, HIGH);
}

void loop() {
  processIncomingPackets();
  scanMatrix();
  processTouchpad();
}

void handleDecodedPacket(uint8_t type, uint8_t* data, uint8_t len) {
  switch (type) {
    case 0x6A:
    case 0x6B:
    case 0x6C:
      if (len >= 2) {
        uint8_t cmd = data[1];
        switch (cmd) {
          case 0x30: {
            delay(5);
            uint8_t resp[] = {0x30, 0x02, 0x00, 0x00};
            sendPacket(0x6D, resp, 4);
            break;
          }
          case 0x26: {
            if (len >= 4) {
              if (data[3] == 0) digitalWrite(CAPS_LED_PIN, HIGH);
              else if (data[3] == 1) digitalWrite(CAPS_LED_PIN, LOW);
            }
            break;
          }
        }
      }
      break;
  }
}
