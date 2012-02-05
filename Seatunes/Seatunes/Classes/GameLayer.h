//
//  GameLayer.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KeyboardDelegate.h"

@class Keyboard;
@class Instructor;
@class Processor;

@interface GameLayer : CCLayer <KeyboardDelegate> {
 
    Instructor *instructor_;
    
    Keyboard *keyboard_;
    
    Processor *processor_;
    
}

+ (id) start;

- (id) init;

@end
