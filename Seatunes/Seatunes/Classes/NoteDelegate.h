//
//  NoteDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Note;

@protocol NoteDelegate <NSObject>

- (void) noteDestroyed:(Note *)note;

- (void) noteCrossedBoundary:(Note *)note;

@end