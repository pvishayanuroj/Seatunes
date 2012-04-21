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

@class Instructor;
@class SpeechReader;

@interface ScoreLayer : CCLayer <ButtonDelegate> {
    
    Instructor *instructor_;
    
    SpeechReader *reader_;    
    
    DifficultyType difficulty_;    
    
    NSString *songName_;
    
    NSString *nextSong_;
}

+ (id) scoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

- (id) initScoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

@end
