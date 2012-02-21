//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"


@implementation SongMenuItem

static const CGFloat SMI_CELL_HEIGHT = 55.0f;

+ (id) songMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex
{
    return [[[self alloc] initSongMenuItem:songName songScore:songScore songIndex:songIndex] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex
{
    if ((self = [super initScrollingMenuItem:songIndex height:SMI_CELL_HEIGHT])) {
        
        label_ = [[CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"] retain];
        label_.anchorPoint = ccp(0, 0.5f);
        label_.position = ccp(200.0f, 0);
        [self addChild:label_];
        
        NSInteger numStars = songScore;
        
        for (NSInteger i = 0; i < 3; ++i) {
            CCSprite *sprite;
            if (i < numStars) {
                sprite = [CCSprite spriteWithFile:@"Full Star.png"];
            }
            else {
                sprite = [CCSprite spriteWithFile:@"Empty Star.png"];                
            }
            
            sprite.scale = 0.25f;
            sprite.position = ccp(35 * i + 80, 0);
            [self addChild:sprite];
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
