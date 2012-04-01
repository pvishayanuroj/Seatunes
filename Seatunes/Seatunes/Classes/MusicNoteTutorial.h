//
//  MusicNoteTutorial.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/31/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLogic.h"
#import "KeyboardDelegate.h"
#import "SpeechReaderDelegate.h"

@interface MusicNoteTutorial : GameLogic <KeyboardDelegate,SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    NSMutableArray *queueByKey_;
    
    NSMutableArray *queueByID_;
    
    NSMutableDictionary *notesHit_;     
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
}

+ (id) gameLogicF:(NSString *)songName;

- (id) initGameLogicF:(NSString *)songName;

- (void) start;

- (void) endSong;

@end
