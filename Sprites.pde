#include <SPI.h>
#include <GD.h>
#include "alien_sprite.h"

struct sprite {
    int no;
    int x;
    int y;
    int anim;
    byte image[2];
    byte rot;
};
struct sprite spr;

void setup() {
    // allow for setup
    delay(250);
    
    // init struct
    spr.no = 0;
    spr.x = 100;
    spr.y = 100;
    spr.anim = 0;
    spr.image[0] = 0;
    spr.image[1] = 1;
    spr.rot = 0;
    
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
    
    // copy the sprite images into RAM
    GD.copy(RAM_SPRIMG, alien_sprite_img, sizeof(alien_sprite_img));
    GD.copy(RAM_SPRIMG+256, alien_sprite_img2, sizeof(alien_sprite_img2));
}


void loop() {
    // set the sprite control word
    GD.sprite(spr.no, spr.x, spr.y, spr.image[spr.anim], 8);
}

