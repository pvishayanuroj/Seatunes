//
//  Processor.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/16/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Processor : CCNode  {
 
    NSMutableArray *notes_;
    
    NSMutableArray *inputNotes_;
    
    NSUInteger noteIndex_;
    
    KeyType expectedNote_;
    
    BOOL waitingForNote_;
    
    BOOL timerActive_;
    
}

+ (id) processor;

- (id) initProcessor;

- (void) notePlayed:(KeyType)keyType;

- (void) forward;

- (void) delayedForward:(CGFloat)delayTime;

- (void) delayedReplay;

@end
