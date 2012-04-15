//
//  StaffDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class StaffNote;

@protocol StaffDelegate <NSObject>

@optional

- (void) staffNoteReturned:(StaffNote *)note;

- (void) notesInSequenceAdded;

- (void) notesInSequenceDestroyed;

- (void) notesAdded;

@end
