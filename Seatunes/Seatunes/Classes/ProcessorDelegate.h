//
//  ProcessorDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/18/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol ProcessorDelegate <NSObject>

- (void) instructorPlayNote:(KeyType)keyType;

- (void) incorrectNotePlayed;

- (void) sectionComplete;

- (void) songComplete;

@end