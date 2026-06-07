// Eyemote Standalone Demo v2
// XIAO ESP32S3 Sense OV2640 camera → Seeed round display
// RGB565 direct — clean, fast, works
//
// Compile: arduino-cli compile --fqbn esp32:esp32:XIAO_ESP32S3:PSRAM=opi ~/eyemote-xiao-test/standalone_demo
// Upload:  arduino-cli upload -p /dev/ttyACM0 --fqbn esp32:esp32:XIAO_ESP32S3:PSRAM=opi ~/eyemote-xiao-test/standalone_demo

#include "esp_camera.h"
#include <TFT_eSPI.h>

#define PWDN_GPIO_NUM     -1
#define RESET_GPIO_NUM    -1
#define XCLK_GPIO_NUM     10
#define SIOD_GPIO_NUM     40
#define SIOC_GPIO_NUM     39

#define Y9_GPIO_NUM       48
#define Y8_GPIO_NUM       11
#define Y7_GPIO_NUM       12
#define Y6_GPIO_NUM       14
#define Y5_GPIO_NUM       16
#define Y4_GPIO_NUM       18
#define Y3_GPIO_NUM       17
#define Y2_GPIO_NUM       15
#define VSYNC_GPIO_NUM    38
#define HREF_GPIO_NUM     47
#define PCLK_GPIO_NUM     13

TFT_eSPI tft = TFT_eSPI();

#define CAM_W     320
#define CAM_H     240
#define DISP_W    240
#define DISP_H    240

static uint16_t *disp_buf = NULL;

bool initCamera() {
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;
  config.ledc_timer   = LEDC_TIMER_0;

  config.pin_d0       = Y2_GPIO_NUM;
  config.pin_d1       = Y3_GPIO_NUM;
  config.pin_d2       = Y4_GPIO_NUM;
  config.pin_d3       = Y5_GPIO_NUM;
  config.pin_d4       = Y6_GPIO_NUM;
  config.pin_d5       = Y7_GPIO_NUM;
  config.pin_d6       = Y8_GPIO_NUM;
  config.pin_d7       = Y9_GPIO_NUM;
  config.pin_xclk     = XCLK_GPIO_NUM;
  config.pin_pclk     = PCLK_GPIO_NUM;
  config.pin_vsync    = VSYNC_GPIO_NUM;
  config.pin_href     = HREF_GPIO_NUM;
  config.pin_sccb_sda = SIOD_GPIO_NUM;
  config.pin_sccb_scl = SIOC_GPIO_NUM;
  config.pin_pwdn     = PWDN_GPIO_NUM;
  config.pin_reset    = RESET_GPIO_NUM;

  config.xclk_freq_hz = 20000000;
  config.pixel_format = PIXFORMAT_RGB565;
  config.frame_size   = FRAMESIZE_QVGA;
  config.fb_count     = 2;
  config.grab_mode    = CAMERA_GRAB_LATEST;
  config.fb_location  = CAMERA_FB_IN_PSRAM;

  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {
    Serial.printf("CAMERA INIT FAILED: 0x%x\n", err);
    return false;
  }

  sensor_t *s = esp_camera_sensor_get();
  if (s) {
    s->set_brightness(s, 0);
    s->set_contrast(s, 1);
    s->set_saturation(s, 0);
    s->set_sharpness(s, 1);
    s->set_gain_ctrl(s, 1);
    s->set_exposure_ctrl(s, 1);
    s->set_whitebal(s, 1);
    s->set_hmirror(s, 0);
    s->set_vflip(s, 0);
  }

  return true;
}

void setup() {
  Serial.begin(115200);
  delay(2000);

  Serial.println("\n=== Eyemote Standalone Demo ===\n");

  if (!psramFound()) {
    Serial.println("PSRAM: NOT FOUND");
    return;
  }
  Serial.println("PSRAM: OK (8MB)");

  tft.begin();
  tft.setRotation(3);
  tft.fillScreen(TFT_BLACK);
  tft.setTextColor(TFT_WHITE, TFT_BLACK);
  tft.setTextSize(1);

  pinMode(TFT_BL, OUTPUT);
  digitalWrite(TFT_BL, HIGH);

  tft.setCursor(10, 80);
  tft.println("Eyemote");
  tft.setCursor(10, 100);
  tft.println("Standalone");
  tft.setCursor(10, 120);
  tft.println("v2");

  disp_buf = (uint16_t *)ps_malloc(DISP_W * DISP_H * sizeof(uint16_t));
  if (!disp_buf) {
    Serial.println("PSRAM allocation failed!");
    tft.setCursor(10, 140);
    tft.println("PSRAM FAILED");
    return;
  }
  Serial.println("Display buffer allocated");

  if (!initCamera()) {
    Serial.println("Camera init failed");
    tft.setCursor(10, 140);
    tft.println("Camera FAILED");
    return;
  }
  Serial.println("Camera OK");

  tft.fillScreen(TFT_BLACK);
  tft.setCursor(30, 100);
  tft.println("Eyemote");
  tft.setCursor(20, 120);
  tft.println("Ready");
  delay(1000);

  Serial.println("=== READY ===\n");
}

void loop() {
  camera_fb_t *fb = esp_camera_fb_get();
  if (!fb) {
    delay(10);
    return;
  }

  // RGB565 direct: crop 320x240 to center 240x240
  const int x_offset = (CAM_W - DISP_W) / 2;
  uint16_t *src = (uint16_t *)fb->buf;
  for (int y = 0; y < DISP_H; y++) {
    memcpy(disp_buf + y * DISP_W, src + y * CAM_W + x_offset, DISP_W * 2);
  }

  tft.pushImage(0, 0, DISP_W, DISP_H, disp_buf);

  // Subtle crosshair
  tft.drawLine(120-30, 120, 120+30, 120, 0xAD55);
  tft.drawLine(120, 120-30, 120, 120+30, 0xAD55);

  esp_camera_fb_return(fb);
}
