//
//  GameScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "ScrollingMenu.h"
#import "ScrollingMenuItem.h"
#import "AudioManager.h"

@implementation GameScene

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName
{
    return [[[self alloc] initWithDifficulty:difficulty songName:songName] autorelease];
}

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName
{
    if ((self = [super init])) {
        
        GameLayer *gameLayer = [GameLayer startWithDifficulty:difficulty songName:songName];
        [self addChild:gameLayer];    
        
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
