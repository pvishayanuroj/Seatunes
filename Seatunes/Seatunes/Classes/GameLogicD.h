//
//  GameLogicD.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLogic.h"
#import "KeyboardDelegate.h"
#import "SpeechReaderDelegate.h"

@interface GameLogicD : GameLogic <KeyboardDelegate, NoteGeneratorDelegate, SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queue_;
    
    NSMutableArray *notesHit_;    
    
    NSUInteger playerNoteIndex_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
}

+ (id) gameLogicD:(NSString *)songName;

- (id) initGameLogicD:(NSString *)songName;

- (void) start;

- (void) endSong;
@end
