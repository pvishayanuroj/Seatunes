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
#import "StaffDelegate.h"

@class Staff;

@interface MusicNoteTutorial : GameLogic <KeyboardDelegate, StaffDelegate, SpeechReaderDelegate> {
    
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    BOOL ignoreInput_;
    
    BOOL onLastNote_;
    
    BOOL bubbleClickable_;
    
    NSArray *dialogue_;
    
    Staff *staff_;   
}

+ (id) musicNoteTutorial;

- (id) initMusicNoteTutorial;

- (NSArray *) addDialogue;

- (void) blinkStaff;

- (void) eventComplete:(SpeechType)speechType;

@end
