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
        
        [AudioManager audioManager];
        
        Keyboard *keyboard = [Keyboard keyboard:kEightKey];
        keyboard.position = ccp(100, 100);
        [self addChild:keyboard];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
