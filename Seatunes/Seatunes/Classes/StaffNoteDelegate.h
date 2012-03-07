//
//  StaffNoteDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class StaffNote;

@protocol StaffNoteDelegate <NSObject>

@optional

- (void) staffNoteReturned:(StaffNote *)note;

@end
