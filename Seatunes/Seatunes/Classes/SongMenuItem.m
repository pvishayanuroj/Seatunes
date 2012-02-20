//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"


@implementation SongMenuItem

+ (id) songMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex
{
    return [[[self alloc] initSongMenuItem:songName songScore:songScore songIndex:songIndex] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex
{
    if ((self = [super initScrollingMenuItem:songIndex height:55])) {
        
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"];
        label.anchorPoint = ccp(0, 0.5f);
        label.position = ccp(200.0f, 0);
        [self addChild:label];
        
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
    [super dealloc];
}

@end
