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
#import "NoteGeneratorDelegate.h"

@class Staff;

@interface GameLogicE : GameLogic <KeyboardDelegate, NoteGeneratorDelegate, SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queue_;
    
    NSMutableArray *notesHit_;    
    
    NSUInteger playerNoteIndex_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
    
    Staff *staff_;
}

+ (id) gameLogicE:(NSString *)songName;

- (id) initGameLogicE:(NSString *)songName;

- (void) start;

- (void) endSong;

@end
