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
#import "StaffNoteDelegate.h"

@interface Staff : CCNode <StaffNoteDelegate> {
    
    NSMutableArray *notes_;
    
    id <StaffDelegate> delegate_;
    
}

@property (nonatomic, assign) id <StaffDelegate> delegate;

+ (id) staff;

- (id) initStaff;

- (void) addNote:(KeyType)keyType;
 
- (void) removeOldestNote;

- (void) removeAllNotes;

@end
