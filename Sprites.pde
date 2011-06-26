#include <SPI.h>
#include <GD.h>
#include "alien_sprite.h"


void setup() {
    // allow for setup
    delay(250);
    
    GD.begin();
    
    // load character set
    GD.ascii();
    
    // display title
    GD.putstr(0, 1, "Sprite Test 01");
    
    // set background to black
    unsigned int bg_colour = RGB(0, 0, 0);
    GD.wr16(BG_COLOR, bg_colour);
    
    // set up PALETTE4A
    GD.wr16(PALETTE4A, RGB(255, 0, 0));
    GD.wr16(PALETTE4A + (1<<1), RGB(0, 255, 0));
    GD.wr16(PALETTE4A + (2<<1), RGB(0, 0, 255));
    
    // pixel with value of 3 will be transparent
    GD.wr16(PALETTE4A + (3<<1), TRANSPARENT);
    
    // copy the sprite image into RAM
    GD.copy(RAM_SPRIMG, alien_sprite_img, sizeof(alien_sprite_img));
    
    // set the sprite control word
    GD.sprite(0, 100, 100, 0, 8);
}


void loop() {
    
}

