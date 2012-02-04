//
//  GameLogicB.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KeyboardDelegate.h"

@class Keyboard;
@class Instructor;

@interface GameLogicB : CCNode <KeyboardDelegate> {
 
    NSUInteger noteIndex_;
    
    NSArray *notes_;
    
    Keyboard *keyboard_;
    
    Instructor *instructor_;
    
    NSMutableArray *queue_;
    
}

+ (id) gameLogicB:(NSString *)songName;

- (id) initGameLogicB:(NSString *)songName;

- (void) setKeyboard:(Keyboard *)keyboard;

- (void) setInstructor:(Instructor *)instructor;

- (void) start;

- (void) lossEvent;

@end
