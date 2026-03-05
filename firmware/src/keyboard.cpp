#include <Adafruit_SSD1306.h>
#include "keyboard.h"

bool matrixState[8][16] = {false};
bool lastMatrixState[8][16] = {false};
uint32_t lastDebounceTime[8][16] = {0};
uint32_t lastReportTime = 0;

uint8_t lastModifiers = 0;
uint8_t lastKeys[MAX_KEYS] = {0};

extern Adafruit_SSD1306 display;

void initKeyboard() {
  for (int r = 0; r < 8; r++) pinMode(ROW_PINS[r], INPUT_PULLUP);
  for (int c = 0; c < 16; c++) pinMode(COL_PINS[c], INPUT);
}

void drawKeyboardDebug() {
  display.clearDisplay();
  display.setCursor(0, 0);

  bool anyShorted = false;

  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 16; c++) {
      if (matrixState[r][c]) {
        anyShorted = true;

        display.print("R");
        display.print(r);
        display.print("-C");
        display.print(c);
        display.print(" (0x");
        if (KEYMAP[r][c] < 0x10) display.print("0");
        display.print(KEYMAP[r][c], HEX);
        display.println(")");
      }
    }
  }

  if (!anyShorted) {
    display.println("-");
  }

  display.display();
}

void scanMatrix() {
  bool keysChanged = false;

  for (int c = 0; c < 16; c++) {
    pinMode(COL_PINS[c], OUTPUT);
    digitalWrite(COL_PINS[c], LOW);
    delayMicroseconds(10);

    for (int r = 0; r < 8; r++) {
      bool pressed = (digitalRead(ROW_PINS[r]) == LOW);

      if (pressed != lastMatrixState[r][c]) {
        lastDebounceTime[r][c] = millis();
      }

      if ((millis() - lastDebounceTime[r][c]) > DEBOUNCE_DELAY) {
        if (pressed != matrixState[r][c]) {
          matrixState[r][c] = pressed;
          keysChanged = true;
        }
      }
      lastMatrixState[r][c] = pressed;
    }
    pinMode(COL_PINS[c], INPUT);
  }

  if (keysChanged) {
    drawKeyboardDebug();
  }

  bool fnPressed = false;
  bool anyKeyPressed = false;
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 16; c++) {
      if (matrixState[r][c] && KEYMAP[r][c] != 0) {
        anyKeyPressed = true;
        if (KEYMAP[r][c] == K_FN) {
          fnPressed = true;
        }
      }
    }
  }

  uint8_t currentModifiers = 0;
  uint8_t currentKeys[MAX_KEYS] = {0};
  uint8_t keysPressedNum = 0;

  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 16; c++) {
      if (matrixState[r][c]) {
        uint8_t code = KEYMAP[r][c];

        if (fnPressed && FN_KEYMAP[r][c] != 0) {
          code = FN_KEYMAP[r][c];
        }

        if (code == MCU_RST) {
          display.clearDisplay();
          display.setCursor(0, 0);
          display.println("REBOOTING...");
          display.display();

          BOARD_RESET();
        }

        if (code == K_TEST) {
          // you can bind some debug code to this shortcut
        }

        if (code != 0 && code != K_FN) {
          if (code >= K_LCTRL && code <= K_RMETA) {
            currentModifiers |= (1 << (code - K_LCTRL));
          } else {
            if (keysPressedNum < MAX_KEYS) currentKeys[keysPressedNum++] = code;
          }
        }
      }
    }
  }

  bool stateChanged = false;
  if (currentModifiers != lastModifiers) {
    stateChanged = true;
  } else {
    for (int i = 0; i < MAX_KEYS; i++) {
      if (currentKeys[i] != lastKeys[i]) {
        stateChanged = true;
        break;
      }
    }
  }

  bool shouldSend = false;
  if (stateChanged) {
    shouldSend = true;
  } else if (anyKeyPressed && (millis() - lastReportTime >= REPEAT_INTERVAL)) {
    shouldSend = true;
  }

  if (shouldSend) {
    uint8_t payload[8] = {0};
    payload[0] = currentModifiers;
    payload[1] = 0x00;
    for (int i = 0; i < MAX_KEYS; i++) {
      payload[2 + i] = currentKeys[i];
    }

    sendPacket(PACKET_ID_KEYBOARD_REPORT, payload, 8);

    lastModifiers = currentModifiers;
    for (int i = 0; i < MAX_KEYS; i++) {
      lastKeys[i] = currentKeys[i];
    }
    lastReportTime = millis();
  }
}
