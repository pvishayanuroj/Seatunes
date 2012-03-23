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
#import "StaffNoteDelegate.h"

@interface StaffNote : CCNode {
    
    CCSprite *sprite_;
    
    CCSprite *line_;
    
    KeyType keyType_;
    
    NSUInteger numID_;
    
    id <StaffNoteDelegate> delegate_;
    
}

@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, assign) id <StaffNoteDelegate> delegate;

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID;

+ (id) staticStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID;

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID isStatic:(BOOL)isStatic;

- (void) curvedMove;

- (void) move;

- (void) staffNoteReturn;

- (void) fadeDestroy;

- (void) jumpDestroy;

- (CGFloat) calculateNoteY:(KeyType)key;

@end
