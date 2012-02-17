//
//  GameLogicC.h
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
#import "SpeechReaderDelegate.h"

@interface GameLogicC : GameLogic <KeyboardDelegate, SpeechReaderDelegate> {
    
    NSArray *sections_;
    
    NSUInteger sectionIndex_;
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSUInteger replayNoteIndex_;
    
    NSMutableArray *replayNotes_;
    
    NSMutableArray *queue_;
    
    NSUInteger numWrongNotes_;    
    
    BOOL ignoreInput_;
    
    BOOL isFirstPlay_;    
    
}

+ (id) gameLogicC:(NSString *)songName;

- (id) initGameLogicC:(NSString *)songName;

- (void) startSection;

- (void) endSong;

@end
