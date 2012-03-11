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
#import "SpeechReaderDelegate.h"
#import "NoteGeneratorDelegate.h"

@interface GameLogicD : GameLogic <NoteGeneratorDelegate, SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queue_;
    
    NSMutableDictionary *notesHit_;
    
    NSUInteger playerNoteIndex_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
}

+ (id) gameLogicD:(NSString *)songName;

- (id) initGameLogicD:(NSString *)songName;

- (void) start;

- (void) endSong;
@end
