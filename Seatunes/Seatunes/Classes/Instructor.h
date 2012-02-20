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
#import "NoteDelegate.h"
#import "InstructorDelegate.h"

@interface Instructor : CCNode <NoteDelegate, InstructorDelegate, CCTargetedTouchDelegate> {
 
    CCSprite *sprite_;    
 
    NSString *name_;
    
    InstrumentType instrumentType_;
    
    CCAction *idleAnimation_;
    
    CCAction *wrongAnimation_;
    
    CCAction *singingAnimation_;
    
    NSMutableArray *notes_;
    
    NSUInteger curveCounter_;
    
    BOOL clickable_;
    
    id <InstructorDelegate> delegate_;
}

@property (nonatomic, assign) id <InstructorDelegate> delegate;

+ (id) instructor:(InstructorType)instructorType;

- (id) initInstructor:(InstructorType)instructorType;

- (void) initAnimations;

- (void) showIdle;

- (void) showWrongNote;

- (void) showSing;

- (void) playNote:(KeyType)keyType;

- (void) addNote:(KeyType)keyType;

- (void) popOldestNote;

- (void) popNewestNote;

@end
