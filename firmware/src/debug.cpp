#include "debug.h"

void sendTest(uint8_t id) {
  uint8_t payload[20] = {0};

  payload[0] = id;
  payload[1] = 0xAA;
  payload[2] = 0xBB;
  payload[3] = 0xCC;
  payload[4] = 0xDD;

  sendPacket(id, payload, 20);
}
