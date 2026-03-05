#include <Arduino.h>
#include "config.h"
#include "protocol_encoding_table.h"

#ifndef PROTOCOL_H
#define PROTOCOL_H

#define MAX_PACKET_LEN 128

#define PACKET_ID_KEYBOARD_REPORT 0x61
#define PACKET_ID_KEYBOARD_MEDIA_KEYS_REPORT 0x62
#define PACKET_ID_TOUCHPAD_REPORT 0x63

void sendPacket(uint8_t type, const uint8_t* payload, uint8_t len);
void handleDecodedPacket(uint8_t type, uint8_t* data, uint8_t len);
void initProtocol();
void processIncomingPackets();

#endif
