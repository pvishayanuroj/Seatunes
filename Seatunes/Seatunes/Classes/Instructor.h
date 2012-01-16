//
//  Instructor.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Instructor : CCNode <CCTargetedTouchDelegate> {
 
    CCSprite *sprite_;    
 
    NSString *name_;
    
    CCAction *idleAnimation_;
    
    CCAction *wrongAnimation_;
    
    CCAction *singingAnimation_;
    
    BOOL clickable_;
}

+ (id) instructor:(InstructorType)instructorType;

- (id) initInstructor:(InstructorType)instructorType;

- (void) initAnimations;

- (void) playNote:(KeyType)keyType;

@end
