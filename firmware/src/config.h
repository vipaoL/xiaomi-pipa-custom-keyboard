#ifndef CONFIG_H
#define CONFIG_H

#define UART_PINS PA9

#define TP_SCL PA14
#define TP_SDA PA13

#define CAPS_LED_PIN PC13

#define OLED_SCL PB6
#define OLED_SDA PB7

#define SCREEN_WIDTH 128
#define SCREEN_HEIGHT 64
#define OLED_RESET -1
#define SCREEN_ADDRESS 0x3C

#define BOARD_RESET NVIC_SystemReset

const uint8_t ROW_PINS[8]  = {PB1, PB10, PB12, PB13, PB15, PA11, PB5, PA15};
const uint8_t COL_PINS[16] = {PB0, PA7, PA6, PA5, PB8, PA3, PB4, PA2, PA0, PB11, PB14, PA12, PB9, PB3, PA8, PA1};

#endif
