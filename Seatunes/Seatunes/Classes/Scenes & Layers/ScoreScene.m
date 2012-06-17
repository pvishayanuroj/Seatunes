//
//  ScoreScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 4/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScoreScene.h"
#import "ScoreLayer.h"
#import "AudioManager.h"

@implementation ScoreScene

+ (id) scoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    return [[[self alloc] initScoreScene:scoreInfo songName:songName packIndex:packIndex] autorelease];
}

- (id) initScoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    if ((self = [super init])) {
        
        ScoreLayer *scoreLayer = [ScoreLayer scoreLayer:scoreInfo songName:songName packIndex:packIndex];
        [self addChild:scoreLayer];            
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
