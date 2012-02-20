//
//  GameLogicB.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLogic.h"
#import "KeyboardDelegate.h"
#import "InstructorDelegate.h"
#import "SpeechReaderDelegate.h"

@class Keyboard;
@class Instructor;

@interface GameLogicB : GameLogic <KeyboardDelegate, InstructorDelegate, SpeechReaderDelegate> {
 
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queue_;
    
    NSMutableArray *notesHit_;    
    
    NSUInteger playerNoteIndex_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
}

+ (id) gameLogicB:(NSString *)songName;

- (id) initGameLogicB:(NSString *)songName;

- (void) start;

- (void) endSong;

@end
