#include "touchpad.h"

PS2Mouse mouse(TP_SCL, TP_SDA);

volatile uint8_t tp_raw[6];
volatile bool tp_data_ready = false;

volatile uint8_t tp_bit_count = 0;
volatile uint8_t tp_current_byte = 0;
volatile uint8_t tp_byte_count = 0;
volatile uint32_t tp_last_edge_time = 0;

uint16_t last_tp_x = 0;
uint16_t last_tp_y = 0;
int last_tp_z = 0;
uint8_t last_tp_btn = 0;

void initTouchpad() {
  mouse.begin();
  attachInterrupt(digitalPinToInterrupt(TP_SCL), handleTouchpadInterrupt, FALLING);
}

void handleTouchpadInterrupt() {
  uint32_t now = micros();

  if (now - tp_last_edge_time > 2000) {
    tp_bit_count = 0;
    tp_current_byte = 0;
    tp_byte_count = 0;
  }
  tp_last_edge_time = now;

  uint8_t val = digitalRead(TP_SDA);

  if (tp_bit_count == 0) {
    if (val == 0) tp_bit_count++;
  } else if (tp_bit_count >= 1 && tp_bit_count <= 8) {
    tp_current_byte |= (val << (tp_bit_count - 1));
    tp_bit_count++;
  } else if (tp_bit_count == 9) {
    tp_bit_count++;
  } else if (tp_bit_count == 10) {
    if (val == 1) {
      if (!tp_data_ready) {
        tp_raw[tp_byte_count++] = tp_current_byte;
        if (tp_byte_count == 6) {
          tp_data_ready = true;
          tp_byte_count = 0;
        }
      }
    } else {
      tp_byte_count = 0;
    }
    tp_bit_count = 0;
    tp_current_byte = 0;
  }
}

void processTouchpad() {
  if (!tp_data_ready) return;

  byte raw[6];

  noInterrupts();
  memcpy(raw, (const void*)tp_raw, 6);
  tp_data_ready = false;
  interrupts();

  if ((raw[0] & 0x80) != 0) {
    uint16_t x, y;
    mouse.getAbsoluteAxis(raw, x, y);
    int z = raw[2];
    uint8_t btn = raw[0] & 0x03;

    // from dts:
    // touchpad-resolution-x = <2879>;
    // touchpad-resolution-y = <1799>;

    x = constrain(x, 1300, 5700);
    y = constrain(y, 1000, 4800);

    x = map(x, 1300, 5700, 0, 2879);
    y = map(y, 1000, 4800, 1799, 0);

#ifdef TP_DEBUG
    display.clearDisplay();
    display.setCursor(0, 0);

    display.print("x=");
    display.println(x);

    display.print("y=");
    display.println(y);

    display.print("z=");
    display.println(z);

    display.print("btns: ");
    display.println(btn, HEX);

    display.println("raw: ");
    display.print(raw[0], HEX);
    display.print(" ");
    display.print(raw[1]);
    display.print(" ");
    display.print(raw[2]);
    display.print(" ");
    display.print(raw[3]);
    display.print(" ");
    display.print(raw[4]);
    display.print(" ");
    display.print(raw[5]);
    display.println();

    display.display();
#endif

    bool stateChanged = false;
    if (abs((int)x - (int)last_tp_x) > 2 || abs((int)y - (int)last_tp_y) > 2 ||
        (z > 10 && last_tp_z <= 10) || (z <= 10 && last_tp_z > 10) ||
        btn != last_tp_btn) {
      stateChanged = true;
    }

    if (stateChanged) {
      uint8_t payload[20] = {0};

      payload[0] = btn;

      if (z > 10) {
        payload[1] = 0x01;

        payload[2] = x & 0xFF;
        payload[3] = (x >> 8) & 0xFF;

        payload[4] = y & 0xFF;
        payload[5] = (y >> 8) & 0xFF;
      } else {
        payload[1] = 0x00;

        payload[2] = 0;
        payload[3] = 0;
        payload[4] = 0;
        payload[5] = 0;
      }

      sendPacket(PACKET_ID_TOUCHPAD_REPORT, payload, 20);
      //sendTest(PACKET_ID_TOUCHPAD_REPORT);
      digitalWrite(PC13, millis() % 2);

      last_tp_x = x;
      last_tp_y = y;
      last_tp_z = z;
      last_tp_btn = btn;
    }
  } else {
    noInterrupts();
    tp_byte_count = 0;
    interrupts();
  }
}
