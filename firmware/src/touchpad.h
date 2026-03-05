#ifndef TOUCHPAD_H
#define TOUCHPAD_H

#include <Arduino.h>
#include <PS2Mouse.h>

#include "config.h"
#include "protocol.h"

void handleTouchpadInterrupt();
void initTouchpad();
void processTouchpad();

#endif
