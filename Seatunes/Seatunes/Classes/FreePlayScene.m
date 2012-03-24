//
//  FreePlayScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "FreePlayScene.h"
#import "FreePlayLayer.h"
#import "AudioManager.h"

@implementation FreePlayScene

- (id) init
{
    if ((self = [super init])) {
        
        FreePlayLayer *freePlayLayer = [FreePlayLayer node];
        [self addChild:freePlayLayer];    
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:0.2f];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(delayedSound)];
        [self runAction:[CCSequence actions:delay, done, nil]];        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) delayedSound
{
    [[AudioManager audioManager] playSoundEffect:kPageFlip];
}

@end
