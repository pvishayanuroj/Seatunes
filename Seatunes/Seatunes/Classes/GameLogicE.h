//
//  GameLogicE.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLogic.h"
#import "KeyboardDelegate.h"
#import "SpeechReaderDelegate.h"
#import "StaffDelegate.h"

/* Hard mode game logic */
@interface GameLogicE : GameLogic <KeyboardDelegate, StaffDelegate, SpeechReaderDelegate, UIAlertViewDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queueByKey_;
    
    NSMutableArray *queueByID_;    
    
    NSMutableDictionary *notesHit_;   
    
    NSUInteger playerNoteIndex_;
    
    BOOL onBlankNote_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
    
}

+ (id) gameLogicE:(NSString *)songName;

- (id) initGameLogicE:(NSString *)songName;

- (void) start;

- (void) removeNote;

- (void) endSong;

@end
