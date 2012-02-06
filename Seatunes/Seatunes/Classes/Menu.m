//
//  Menu.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/5/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Menu.h"
#import "Button.h"

@implementation Menu

@synthesize delegate = delegate_;

+  (id) menu:(CGFloat)paddingSize isVertical:(BOOL)isVertical
{
    return [[[self alloc] initMenu:paddingSize isVertical:isVertical] autorelease];
}

- (id) initMenu:(CGFloat)paddingSize isVertical:(BOOL)isVertical
{
    if ((self = [super init])) {
        
        isVertical_ = isVertical;
        delegate_ = nil;
        paddingSize_ = paddingSize;
        numItems_ = 0;
        
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) addMenuBackground:(NSString *)filename pos:(CGPoint)pos
{
    CCSprite *sprite = [CCSprite spriteWithFile:filename];
    sprite.position = pos;
    [self addChild:sprite];
}

- (void) addMenuItem:(Button *)menuItem
{
    menuItem.delegate = self;
    menuItem.position = isVertical_ ? ccp(0, -(numItems_ * paddingSize_)) : ccp(numItems_ * paddingSize_, 0);
    [self addChild:menuItem];
    numItems_++;
}

- (void) buttonClicked:(Button *)button
{
    [delegate_ menuItemSelected:button];
}

@end
