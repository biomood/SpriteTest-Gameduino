#include <SPI.h>
#include <GD.h>

byte sprite_page = 0;

struct sprite {
  int x;
  int y;
};

void setup() {
  // allow for setup
  delay(250);
  
  // load character set
  GD.ascii();
  GD.putstr(0, 0, "Sprite Test 01");
  
  // set background to white
  unsigned int bg_colour = RGB(255, 255, 255);
  GD.wr16(BG_COLOR, bg_colour);
  
  // use lower sprite page
  GD.wr(SPR_PAGE, sprite_page);
}

void loop() {
}
