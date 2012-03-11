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
    
    id <StaffNoteDelegate> delegate_;
    
}

@property (nonatomic, assign) id <StaffNoteDelegate> delegate;

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos;

+ (id) staticStaffNote:(KeyType)keyType pos:(CGPoint)pos;

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos isStatic:(BOOL)isStatic;

- (void) move;

- (void) appear;

- (void) staffNoteReturn;

- (void) staffNoteDestroy;

@end
