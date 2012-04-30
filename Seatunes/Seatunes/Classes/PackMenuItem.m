//
//  PackMenuItem.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PackMenuItem.h"


@implementation PackMenuItem

static const CGFloat PMI_CELL_HEIGHT = PACK_MENU_CELL_HEIGHT;
static const CGFloat PMI_SPRITE_X = 100.0f;

+ (id) packenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked
{
    return [[[self alloc] initPackMenuItem:packName packIndex:packIndex isLocked:isLocked] autorelease];
}

- (id) initPackMenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked;
{
    if ((self = [super initScrollingMenuItem:packIndex height:PMI_CELL_HEIGHT])) {

        isLocked_ = isLocked;
        packName_ = [packName retain];
        
        NSString *filename;
        if (isLocked) {
            filename = [NSString stringWithFormat:@"%@ Locked", packName];
        }
        else {
            filename = [NSString stringWithFormat:@"%@", packName];
        }
        
        /*
        if (packIndex == 0) {
            filename = [filename stringByAppendingFormat:@" Selected.png"];
        }
        else {
            filename = [filename stringByAppendingFormat:@" Unselected.png"];
        }
         */
        filename = [filename stringByAppendingFormat:@" Unselected.png"];        
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        sprite_.position = ccp(PMI_SPRITE_X, 0);
        [self addChild:sprite_];
    }
    return self;
}

- (void) dealloc
{
    [packName_ release];
    [sprite_ release];
    
    [super dealloc];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if ([self containsTouchLocation:touch]) {
        
        return YES;
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch]) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuItemClicked:)]) {
            [delegate_ scrollingMenuItemClicked:self];
        }
    }
}

- (void) toggleSelected:(BOOL)selected
{
    NSString *filename;
    if (isLocked_) {
        filename = [NSString stringWithFormat:@"%@ Locked", packName_];
    }
    else {
        filename = [NSString stringWithFormat:@"%@", packName_];
    }
    
    if (selected) {
        filename = [filename stringByAppendingFormat:@" Selected.png"];
    }
    else {
        filename = [filename stringByAppendingFormat:@" Unselected.png"];
    }
    
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    
    sprite_ = [[CCSprite spriteWithFile:filename] retain];
    sprite_.position = ccp(PMI_SPRITE_X, 0);
    [self addChild:sprite_];    
}

@end
