//
//  GameLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "Keyboard.h"
#import "AudioManager.h"

@implementation GameLayer

+ (id) start
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        [AudioManager audioManager];
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.position = ccp(100, 100);
        [self addChild:keyboard_];
        
    }
    return self;
}

- (void) dealloc
{
    [keyboard_ release];
    
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesBegan:touches];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesMoved:touches];
}

- (void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touches cancelled");        
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesEnded:touches];
}

@end