//
//  NoteGeneratorDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/5/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Note;

@protocol NoteGeneratorDelegate <NSObject>

@optional

- (void) noteCrossedBoundary:(Note *)note;

- (void) noteTouched:(Note *)note;

@end
