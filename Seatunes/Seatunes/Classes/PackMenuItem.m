//
//  PackMenuItem.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PackMenuItem.h"


@implementation PackMenuItem

static const CGFloat PMI_CELL_HEIGHT = 160.0f;
static const CGFloat PMI_SPRITE_X = 100.0f;

+ (id) packenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked
{
    return [[[self alloc] initPackMenuItem:packName packIndex:packIndex isLocked:isLocked] autorelease];
}

- (id) initPackMenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked;
{
    if ((self = [super initScrollingMenuItem:packIndex height:PMI_CELL_HEIGHT])) {
        
        NSString *filename = [NSString stringWithFormat:@"%@.png", packName];
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        sprite_.position = ccp(PMI_SPRITE_X, 0);
        [self addChild:sprite_];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

@end
