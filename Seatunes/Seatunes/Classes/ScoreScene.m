//
//  ScoreScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 4/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScoreScene.h"
#import "ScoreLayer.h"

@implementation ScoreScene

+ (id) scoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    return [[[self alloc] initScoreScene:scoreInfo songName:songName nextSong:nextSong] autorelease];
}

- (id) initScoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    if ((self = [super init])) {
        
        ScoreLayer *scoreLayer = [ScoreLayer scoreLayer:scoreInfo songName:songName nextSong:nextSong];
        [self addChild:scoreLayer];            
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
