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
#import "SpeechBubbleDelegate.h"

@class SpeechBubble;

@interface SpeechReader : CCNode <SpeechBubbleDelegate> {
    
    NSMutableArray *speeches_;
    
    NSUInteger currentSpeechIndex_;
    
    NSString *remainingText_;
    
    BOOL tapRequired_;
    
    SpeechType lastSpeechType_;
    
    SpeechBubble *currentBubble_;
    
    id <SpeechReaderDelegate> delegate_;
    
}

@property (nonatomic, assign) id <SpeechReaderDelegate> delegate;

+ (id) speechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired;

- (id) initSpeechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired;

- (void) createBubble;

@end
