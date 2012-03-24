//
//  Staff.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StaffDelegate.h"

@interface Staff : CCNode {
    
    NSMutableArray *notes_;
    
    id <StaffDelegate> delegate_;
    
}

@property (nonatomic, assign) id <StaffDelegate> delegate;

+ (id) staff;

- (id) initStaff;

- (void) addNote:(KeyType)keyType numID:(NSUInteger)numID;

- (void) addMovingNote:(KeyType)keyType numID:(NSUInteger)numID;

- (void) addStaticNote:(KeyType)keyType numID:(NSUInteger)numID;
 
- (BOOL) isOldestNoteActive;

- (void) removeOldestNote;

- (void) removeAllNotes;

- (CGFloat) calculateNoteY:(KeyType)key;

@end
