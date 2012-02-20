//
//  GameLogic.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/11/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KeyboardDelegate.h"
#import "InstructorDelegate.h"
#import "GameLogicDelegate.h"
#import "SpeechReaderDelegate.h"

@class Keyboard;
@class Instructor;

@interface GameLogic : CCNode <KeyboardDelegate, InstructorDelegate, SpeechReaderDelegate> {
    
    Keyboard *keyboard_;
    
    Instructor *instructor_;    
    
    ScoreInfo scoreInfo_;
    
    BOOL isFirstPlay_;
    
    id <GameLogicDelegate> delegate_;
}

@property (nonatomic, assign) id <GameLogicDelegate> delegate;

+ (id) gameLogic;

- (id) initGameLogic:(DifficultyType)difficulty;

- (void) setKeyboard:(Keyboard *)keyboard;

- (void) setInstructor:(Instructor *)instructor;

- (void) runSingleSpeech:(SpeechType)speechType tapRequired:(BOOL)tapRequired;

- (void) runSpeech:(NSArray *)speeches tapRequired:(BOOL)tapRequired;

@end
