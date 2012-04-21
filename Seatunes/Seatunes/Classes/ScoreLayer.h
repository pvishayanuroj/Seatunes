//
//  ScoreLayer.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/19/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "SpeechReaderDelegate.h"
#import "IncrementingTextDelegate.h"

@class Instructor;
@class SpeechReader;
@class Text;

@interface ScoreLayer : CCLayer <ButtonDelegate, SpeechReaderDelegate, IncrementingTextDelegate> {
    
    Instructor *instructor_;
    
    SpeechReader *reader_;    
    
    DifficultyType difficulty_;    
    
    CCParticleSystem *particles_;
    
    ScoreInfo scoreInfo_;
    
    Text *statsLabel_;
    
    NSString *songName_;
    
    NSString *nextSong_;
}

+ (id) scoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

- (id) initScoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

- (void) placeIncrementingPercentage;

- (void) placeFirstStats;

- (void) placeSecondStats;

- (CCParticleSystem *) createPS;

@end
