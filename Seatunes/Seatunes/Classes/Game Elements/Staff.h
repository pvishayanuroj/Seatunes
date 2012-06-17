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
    
    CCSprite *staffBackground_;
    
    CCSprite *staffForeground_;
    
    NSMutableArray *notes_;
    
    NSMutableArray *labels_;
    
    CCAction *action_;
    
    BOOL showName_;
    
    id <StaffDelegate> delegate_;
    
}

@property (nonatomic, assign) BOOL showName;
@property (nonatomic, assign) id <StaffDelegate> delegate;

+ (id) staff;

- (id) initStaff;

- (void) blinkStaff:(BOOL)blink;

- (void) disableLoop;

- (void) staffNoteReturned:(StaffNote *)note;

- (void) showAlternateNoteNames;

- (void) addNotes:(NSArray *)notes;

- (void) addNotesInSequence:(NSArray *)notes;

- (void) destroyNotesInSequence;

- (void) addMovingNote:(KeyType)keyType numID:(NSUInteger)numID;
 
- (BOOL) isOldestNoteActive;

- (void) removeOldestNote;

- (void) removeAllNotes;

- (CGFloat) calculateNoteY:(KeyType)key;

@end
