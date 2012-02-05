//
//  InstructorDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Note;

@protocol InstructorDelegate <NSObject>

@optional

- (void) noteCrossedBoundary:(Note *)note;

@end