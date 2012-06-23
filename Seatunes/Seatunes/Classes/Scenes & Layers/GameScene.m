//
//  GameScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "Apsalar.h"
#import "Utility.h"

@implementation GameScene

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    return [[[self alloc] initWithDifficulty:difficulty songName:songName packIndex:packIndex] autorelease];
}

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    if ((self = [super init])) {
        
        GameLayer *gameLayer = [GameLayer startWithDifficulty:difficulty songName:songName packIndex:packIndex];
        [self addChild:gameLayer];    
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];    
        
#if ANALYTICS_ON
        NSString *difficultyName = [Utility difficultyFromEnum:difficulty];
        [Apsalar eventWithArgs:@"SongStart", @"Difficulty", difficultyName, @"Song", songName, nil];
#endif        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
