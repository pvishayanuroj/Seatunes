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
static const CGFloat PMI_LOCK_X = 170.0f;
static const CGFloat PMI_LOCK_Y = -60.0f;

+ (id) packenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked
{
    return [[[self alloc] initPackMenuItem:packName packIndex:packIndex isLocked:isLocked] autorelease];
}

- (id) initPackMenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked;
{
    if ((self = [super initScrollingMenuItem:packIndex height:ADJUST_IPAD_HEIGHT(PMI_CELL_HEIGHT)])) {

        isLocked_ = isLocked;
        packName_ = [packName retain];
        
        NSString *filename = [NSString stringWithFormat:@"%@ Unselected.png", packName];      
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        sprite_.position = ADJUST_IPAD_CCP(ccp(PMI_SPRITE_X, 0));
        [self addChild:sprite_ z:1];

        if (isLocked) {
            CCSprite *lock = [CCSprite spriteWithFile:@"Lock Icon.png"];
            lock.scale = 0.7f;
            lock.position = ADJUST_IPAD_CCP(ccp(PMI_LOCK_X, PMI_LOCK_Y));
            [self addChild:lock z:2];
        }        
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
    NSString *filename = [NSString stringWithFormat:@"%@", packName_];
    
    if (selected) {
        filename = [filename stringByAppendingFormat:@" Selected.png"];
    }
    else {
        filename = [filename stringByAppendingFormat:@" Unselected.png"];
    }
    
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    
    sprite_ = [[CCSprite spriteWithFile:filename] retain];
    sprite_.position = ADJUST_IPAD_CCP(ccp(PMI_SPRITE_X, 0));
    [self addChild:sprite_];    
}

@end
