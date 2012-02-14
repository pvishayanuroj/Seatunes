//
//  GameLogicA.h
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

@interface GameLogicA : GameLogic <KeyboardDelegate, InstructorDelegate, SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;  
    
    NSMutableArray *queue_;  
    
    NSUInteger numWrongNotes_;
    
    BOOL isFirstPlay_;
    
    BOOL ignoreInput_;
    
}

+ (id) gameLogicA:(NSString *)songName;

- (id) initGameLogicA:(NSString *)songName;

- (void) start;

- (void) playExampleNote:(KeyType)keyType;

- (void) startTestPlay;

- (void) delayedReplay;

@end
