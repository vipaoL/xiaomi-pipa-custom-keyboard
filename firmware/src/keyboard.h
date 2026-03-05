#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <Arduino.h>

#include "config.h"
#include "layout.h"
#include "protocol.h"

#define MAX_KEYS 6
#define DEBOUNCE_DELAY 5
#define REPEAT_INTERVAL 90

void initKeyboard();
void scanMatrix();

#endif
