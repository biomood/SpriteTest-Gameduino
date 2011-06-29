#include <SPI.h>
#include <GD.h>

#include "alien_sprite.h"
#include "eyes_sprite.h"

#define NUMALIENIMGS 2
#define NUMEYESIMGS  2

struct sprite {
    byte no;
    int16_t x;
    int16_t y;
    byte rot;
    byte anim;
    byte *img_arr; // used so we know that images belong to the sprite
};

struct sprite alien_spr;
struct sprite eyes_spr;
byte sprite_page = 0;
int16_t anim_timer = 0;

void setup() {
    delay(250);
    
    // init the sprites
    alien_spr.no = 0;
    alien_spr.x = 100;
    alien_spr.y = 100;
    alien_spr.rot = 0;
    alien_spr.anim = 0;
    alien_spr.img_arr = (byte*)malloc(NUMALIENIMGS*sizeof(byte));
    alien_spr.img_arr[0] = 0;
    alien_spr.img_arr[1] = 1;
    
    eyes_spr.no = 1;
    eyes_spr.x = 140;
    eyes_spr.y = 100;
    eyes_spr.rot = 0;
    eyes_spr.anim = 0;
    eyes_spr.img_arr = (byte*)malloc(NUMEYESIMGS*sizeof(byte));
    eyes_spr.img_arr[0] = 2;
    eyes_spr.img_arr[1] = 3;
    
    GD.begin();
    
    GD.ascii();
    GD.putstr(0, 1, "Sprite Test 01");
    
    // set background to black
    unsigned int bg_colour = RGB(0, 0, 0);
    GD.wr16(BG_COLOR, bg_colour);
    
    // set the sprite page
    GD.wr(SPR_PAGE, sprite_page);
    
    // set up PALETTE4A
    GD.wr16(PALETTE4A, RGB(255, 0, 0));
    GD.wr16(PALETTE4A + (1<<1), RGB(0, 255, 0));
    GD.wr16(PALETTE4A + (2<<1), RGB(0, 0, 255));
    GD.wr16(PALETTE4A + (3<<1), TRANSPARENT);
    
    // copy the sprite images into RAM 
    GD.copy(RAM_SPRIMG, alien_sprite_img, sizeof(alien_sprite_img));
    GD.copy(RAM_SPRIMG+256, alien_sprite_img2, sizeof(alien_sprite_img2));
    
    GD.copy(RAM_SPRIMG+(256*2), eyes_img, sizeof(eyes_img));
    GD.copy(RAM_SPRIMG+(256*3), eyes_img2, sizeof(eyes_img2));
    
}


void loop() {
    // wait for vertical blanking
    GD.waitvblank();
    anim_timer++;
    
    // change image after approx 0.5 seconds 
    if (anim_timer==50) {
        anim_timer = 0;
                
        alien_spr.anim = alien_spr.anim ^ 1;
        eyes_spr.anim = eyes_spr.anim ^ 1;
    }
    
    // set the sprite control words
    GD.sprite(alien_spr.no, alien_spr.x, alien_spr.y, alien_spr.img_arr[alien_spr.anim], 8);
    GD.sprite(eyes_spr.no, eyes_spr.x, eyes_spr.y, eyes_spr.img_arr[eyes_spr.anim], 8);
}

