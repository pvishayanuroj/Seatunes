//
//  SpeechReader.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/7/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SpeechReaderDelegate.h"
#import "AudioManagerDelegate.h"

@class SpeechBubble;
@class Text;

@interface SpeechReader : CCNode <CCTargetedTouchDelegate, AudioManagerDelegate> {
    
    CCSprite *sprite_;
    
    Text *text_;
    
    NSDictionary *data_;
    
    NSArray *speechTypes_;
    
    NSUInteger currentSpeechIndex_;
    
    NSString *remainingText_;
    
    BOOL prompt_;
    
    BOOL isClickable_;
    
    SpeechType lastSpeechType_;
    
    id <SpeechReaderDelegate> delegate_;
}

@property (nonatomic, assign) id <SpeechReaderDelegate> delegate;

+ (id) speechReader;

+ (id) speechReader:(NSArray *)speeches prompt:(BOOL)prompt;

- (id) initSpeechReader:(NSArray *)speeches prompt:(BOOL)prompt;

- (void) loadSingleDialogue:(SpeechType)speechType;

- (void) loadDialogue:(NSArray *)speeches;

- (void) playSecondaryDialogue:(SpeechType)speechType;

- (void) nextDialogue;

- (SpeechType) currentSpeech;

@end
