//
//  SliderBoxMenu.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SliderBoxMenu.h"
#import "Button.h"

@implementation SliderBoxMenu

@synthesize delegate = delegate_;

+ (id) sliderBoxMenu:(CGFloat)paddingSize
{
    return [[[self alloc] initSliderBoxMenu:paddingSize] autorelease];
}

- (id) initSliderBoxMenu:(CGFloat)paddingSize
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        isMoving_ = NO;
        currentMenuItem_ = nil;
        paddingSize_ = paddingSize;
        items_ = [[NSMutableArray array] retain];
        itemMap_ = [[NSMutableDictionary dictionary] retain];
        sprite_ = [[CCSprite spriteWithFile:@"Slider Box.png"] retain];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [itemMap_ release];
    [items_ release];
    [currentMenuItem_ release];
    
    [super dealloc];
}

- (void) addMenuItem:(Button *)menuItem
{
    NSUInteger count = [itemMap_ count];
    menuItem.delegate = self;
    menuItem.position = CGPointMake(0, -(count * paddingSize_));
    [items_ addObject:menuItem];
    [self addChild:menuItem];    
    
    if (count == 0) {
        currentItem_ = 0;
        [self addChild:sprite_];
    }
    
    NSNumber *buttonID = [NSNumber numberWithUnsignedInteger:menuItem.numID];
    NSNumber *buttonIndex = [NSNumber numberWithUnsignedInteger:count];
    
    [itemMap_ setObject:buttonIndex forKey:buttonID];
}

- (void) buttonClicked:(Button *)button
{
    currentMenuItem_ = [button retain];
    
    for (Button *item in items_) {
        item.isClickable = NO;
    }
    
    [self moveBoxTo:button.numID];
}

- (void) moveBoxTo:(NSUInteger)index
{
    if (!isMoving_) {
        isMoving_ = YES;
        CGPoint pos = CGPointMake(0, -(index * paddingSize_));
        CCActionInterval *move = [CCMoveTo actionWithDuration:0.2f position:pos];
        //CCActionInterval *ease = [CCEaseIn actionWithAction:move rate:1.0f];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(boxDoneMoving)];    
        [sprite_ runAction:[CCSequence actions:move, done, nil]]; 
    }
}

- (void) boxDoneMoving
{
    for (Button *button in items_) {
        button.isClickable = YES;
    }
    
    isMoving_ = NO;
    if (delegate_ && [delegate_ respondsToSelector:@selector(slideBoxMenuItemSelected:)]) {
        if (currentMenuItem_) {
            [delegate_ slideBoxMenuItemSelected:currentMenuItem_];
        }
        
    }
    [currentMenuItem_ release];
    currentMenuItem_ = nil;
}

@end
