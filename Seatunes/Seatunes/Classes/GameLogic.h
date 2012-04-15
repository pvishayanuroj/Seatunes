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
#import "GameLogicDelegate.h"
#import "SpeechReaderDelegate.h"

@class Keyboard;
@class Instructor;
@class NoteGenerator;
@class SpeechReader;

@interface GameLogic : CCNode <SpeechReaderDelegate> {
    
    Keyboard *keyboard_;
    
    Instructor *instructor_;    
    
    NoteGenerator *noteGenerator_;
    
    SpeechReader *reader_;
    
    ScoreInfo scoreInfo_;
    
    BOOL isFirstPlay_;
    
    BOOL isDifficultyFirstPlay_;
    
    id <GameLogicDelegate> delegate_;
}

@property (nonatomic, assign) id <GameLogicDelegate> delegate;

+ (id) gameLogic;

- (id) initGameLogic:(DifficultyType)difficulty;

- (void) touchesBegan:(NSSet *)touches;

- (void) touchesMoved:(NSSet *)touches;

- (void) touchesEnded:(NSSet *)touches;

@end
