#include "protocol.h"

HardwareSerial Serial1(UART_PINS);

uint8_t rxBuffer[MAX_PACKET_LEN];
uint8_t rxIndex = 0;
bool receiving = false;
uint32_t lastByteTime = 0;

int8_t decodeNibble(uint8_t nonce, uint8_t encodedByte) {
  for (uint8_t i = 0; i < 16; i++) {
    if (LOOKUP_TABLE[nonce][i] == encodedByte) return i;
  }
  return -1;
}

uint8_t encodeByte(uint8_t nonce, uint8_t nibble) {
  return LOOKUP_TABLE[nonce][nibble & 0x0F];
}

void sendRawBytes(uint8_t* data, uint8_t len) {
  for(int i = 0; i < 8; i++) Serial1.write(0x55);
  Serial1.write(0x21);
  Serial1.write(data, len);
  Serial1.write(0x2C);
  for(int i = 0; i < 4; i++) Serial1.write(0x55);
  Serial1.flush();
}

void sendPacket(uint8_t type, const uint8_t* payload, uint8_t len) {
  uint8_t txBuffer[128];
  uint8_t txIdx = 0;
  uint8_t nonce = random(0, 8);

  txBuffer[txIdx++] = type;

  txBuffer[txIdx++] = encodeByte(nonce, len >> 4);
  txBuffer[txIdx++] = encodeByte(nonce, len & 0x0F);

  for(int i = 0; i < len; i++) {
    txBuffer[txIdx++] = encodeByte(nonce, payload[i] >> 4);
    txBuffer[txIdx++] = encodeByte(nonce, payload[i] & 0x0F);
  }

  uint8_t checksum = 0;
  for(int i = 0; i < txIdx; i++) checksum += txBuffer[i];

  txBuffer[txIdx++] = encodeByte(nonce, checksum >> 4);
  txBuffer[txIdx++] = encodeByte(nonce, checksum & 0x0F);

  sendRawBytes(txBuffer, txIdx);
}

void processRxBuffer(uint8_t* buffer, uint8_t len) {
  if (len < 3) return;
  uint8_t type = buffer[0];

  int8_t nonce = -1;
  for (uint8_t i = 0; i < 8; i++) {
    // the first byte is message length.
    // let's assume the high nibble of the byte is 0 (e.g. 0x05)
    if (LOOKUP_TABLE[i][0] == buffer[1]) {
      nonce = i;
      break;
    }
  }
  if (nonce == -1) {
    return;
  }

  uint8_t decoded[32];
  uint8_t decLen = 0;

  for (uint8_t i = 1; i < len - 1; i += 2) {
     if (i + 1 >= len) break;
     int8_t hi = decodeNibble(nonce, buffer[i]);
     int8_t lo = decodeNibble(nonce, buffer[i+1]);
     if (hi != -1 && lo != -1) {
       decoded[decLen++] = (hi << 4) | lo;
     }
  }
  handleDecodedPacket(type, decoded, decLen);
}

void initProtocol() {
  Serial1.setHalfDuplex();
  Serial1.begin(921600);

  delay(200);

  uint8_t hello[] = {0x00, 0x00, 0x00, 0x00};
  sendPacket(0x7B, hello, 4);
}

void processIncomingPackets() {
  while (Serial1.available()) {
    uint8_t b = Serial1.read();

    if (micros() - lastByteTime > 2000) {
      rxIndex = 0;
      receiving = false;
    }
    lastByteTime = micros();

    if (b == 0x55) continue;

    if (b == 0x21) {
      rxIndex = 0;
      receiving = true;
      continue;
    }

    if (receiving) {
      if (b == 0x2C) {
        processRxBuffer(rxBuffer, rxIndex);
        receiving = false;
        rxIndex = 0;
      } else {
        if (rxIndex < MAX_PACKET_LEN) rxBuffer[rxIndex++] = b;
      }
    }
  }
}
