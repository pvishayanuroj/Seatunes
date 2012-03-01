//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"


@implementation SongMenuItem

static const CGFloat SMI_CELL_HEIGHT = SONG_MENU_CELL_HEIGHT;

static const CGFloat SMI_SONG_NAME_X = 200.0f;
static const CGFloat SMI_LOCKED_ICON_X = 100.0f;
static const CGFloat SMI_STAR_X = 80.0f;
static const CGFloat SMI_STAR_PADDING = 35.0f;
static const CGFloat SMI_STAR_SCALE = 0.25f;
static const CGFloat SMI_LOCK_SCALE = 0.25f;

+ (id) songMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex locked:(BOOL)locked
{
    return [[[self alloc] initSongMenuItem:songName songScore:songScore songIndex:songIndex locked:locked] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex locked:(BOOL)locked
{
    if ((self = [super initScrollingMenuItem:songIndex height:SMI_CELL_HEIGHT])) {
        
        label_ = [[CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"] retain];
        label_.anchorPoint = ccp(0, 0.5f);
        label_.position = ccp(SMI_SONG_NAME_X, 0);
        [self addChild:label_];
        
        if (locked) {
            CCSprite *sprite = [CCSprite spriteWithFile:@"Lock Icon.png"];
            sprite.position = ccp(SMI_LOCKED_ICON_X, 0);
            sprite.scale = SMI_LOCK_SCALE;
            [self addChild:sprite];
        }
        else {
            NSInteger numStars = songScore;
            
            for (NSInteger i = 0; i < 3; ++i) {
                CCSprite *sprite;
                if (i < numStars) {
                    sprite = [CCSprite spriteWithFile:@"Full Star.png"];
                }
                else {
                    sprite = [CCSprite spriteWithFile:@"Empty Star.png"];                
                }
                
                sprite.scale = SMI_STAR_SCALE;
                sprite.position = ccp(SMI_STAR_PADDING * i + SMI_STAR_X, 0);
                [self addChild:sprite];
            }
        }
    }
    return self;
}

- (void) dealloc
{
    [label_ release];
    
    [super dealloc];
}

@end
