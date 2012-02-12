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

@class Keyboard;
@class Instructor;

@interface GameLogic : CCNode <KeyboardDelegate, InstructorDelegate> {
    
    Keyboard *keyboard_;
    
    Instructor *instructor_;    
    
}

+ (id) gameLogic;

- (id) initGameLogic;

- (void) setKeyboard:(Keyboard *)keyboard;

- (void) setInstructor:(Instructor *)instructor;

@end
