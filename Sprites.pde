#include <SPI.h>
#include <GD.h>

#include "alien_sprite.h"
#include "eyes_sprite.h"
#include "leaf.h"

#define NUMALIENIMGS 2
#define NUMEYESIMGS  1
#define NUMLEAFIMGS  1

struct sprite {
    byte no;
    int16_t x;
    int16_t y;
    byte rot;
    byte anim;
    byte *img_arr; // used so we know that images belong to the sprite
    byte palette;
};

struct sprite alien_spr;
struct sprite eyes_spr;
struct sprite leaf_spr;
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
    alien_spr.palette = 8;
    
    eyes_spr.no = 1;
    eyes_spr.x = 140;
    eyes_spr.y = 100;
    eyes_spr.rot = 0;
    eyes_spr.anim = 0;
    eyes_spr.img_arr = (byte*)malloc(NUMEYESIMGS*sizeof(byte));
    eyes_spr.img_arr[0] = 2;
    eyes_spr.palette = 8;
    
    leaf_spr.no = 2;
    leaf_spr.x = 180;
    leaf_spr.y = 100;
    leaf_spr.rot = 0;
    leaf_spr.anim = 0;
    leaf_spr.img_arr = (byte*)malloc(NUMLEAFIMGS*sizeof(byte));
    leaf_spr.img_arr[0] = 3;
    leaf_spr.palette = 8;
    
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
    
    // set up PALETTE4B
    GD.wr16(PALETTE4B, RGB(255, 255, 0));
    GD.wr16(PALETTE4B + (1<<1), RGB(0, 255, 255));
    GD.wr16(PALETTE4B + (2<<1), RGB(255, 0, 255));
    GD.wr16(PALETTE4B + (3<<1), TRANSPARENT);
    
    // copy alien images into RAM 
    GD.copy(RAM_SPRIMG, alien_sprite_img, sizeof(alien_sprite_img));
    GD.copy(RAM_SPRIMG+256, alien_sprite_img2, sizeof(alien_sprite_img2));
    
    // copy eyes image into RAM
    GD.copy(RAM_SPRIMG+(256*2), eyes_img, sizeof(eyes_img));
    
    // copy leaf image into RAM
    GD.copy(RAM_SPRIMG+(256*3), leaf_img, sizeof(leaf_img));
}


void loop() {
    // wait for vertical blanking
    GD.waitvblank();
    anim_timer++;
    
    // change image after approx 0.5 seconds 
    if (anim_timer==50) {
        anim_timer = 0;
        
        alien_spr.anim = alien_spr.anim ^ 1;
        
        // flip the rotation for the eyes sprite
        if (eyes_spr.rot==0) {
            eyes_spr.rot = 2;
        }
        else{
            eyes_spr.rot = 0;
        }
        
        // flip the palette for the leaf sprite
        if (leaf_spr.palette==8) {
            leaf_spr.palette = 9;
        } else {
            leaf_spr.palette = 8;
        }
    }
    
    
    // set the sprite control words
    GD.sprite(alien_spr.no, alien_spr.x, alien_spr.y, alien_spr.img_arr[alien_spr.anim], alien_spr.palette);
    GD.sprite(eyes_spr.no, eyes_spr.x, eyes_spr.y, eyes_spr.img_arr[eyes_spr.anim], alien_spr.palette, eyes_spr.rot);
    GD.sprite(leaf_spr.no, leaf_spr.x, leaf_spr.y, leaf_spr.img_arr[leaf_spr.anim], leaf_spr.palette);
}

