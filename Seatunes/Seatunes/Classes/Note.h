//
//  Note.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "NoteDelegate.h"

@interface Note : CCNode <CCTargetedTouchDelegate> {
    
    CCSprite *sprite_;
    
    KeyType keyType_;
    
    ccBezierConfig bezier_;    
    
    BOOL poppable_;
    
    BOOL isClickable_;
    
    BOOL boundaryCrossFlag_;
    
    NSUInteger numID_;        
    
    id <NoteDelegate> delegate_; 
}

@property (nonatomic, readonly) KeyType keyType;
@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, assign) id <NoteDelegate> delegate;

+ (id) note:(KeyType)keyType curve:(ccBezierConfig)curve numID:(NSUInteger)numID;

+ (id) note:(KeyType)keyType curve:(ccBezierConfig)curve poppable:(BOOL)poppable numID:(NSUInteger)numID;

- (id) initNote:(KeyType)keyType curve:(ccBezierConfig)curve poppable:(BOOL)poppable numID:(NSUInteger)numID;

- (void) destroy;

- (void) blowAction;

- (void) wobbleAction;

- (void) curveAction;

- (void) scaleAction;

@end
