//
//  StaffNote.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    kStaffNoteStart,
    kStaffNoteActive,
    kStaffNoteFade
} StaffNoteState;

@interface StaffNote : CCNode {
    
    CCSprite *sprite_;
    
    CCSprite *line_;
    
    KeyType keyType_;
    
    StaffNoteState state_;
    
    NSUInteger numID_;
    
}

@property (nonatomic, readonly) StaffNoteState state;
@property (nonatomic, readonly) NSUInteger numID;

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID;

+ (id) staticStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID;

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID isStatic:(BOOL)isStatic;

- (void) fadeIn;

- (void) curvedMove;

- (void) fadeDestroy;

- (void) jumpDestroy;

- (CGFloat) calculateNoteY:(KeyType)key;

@end
