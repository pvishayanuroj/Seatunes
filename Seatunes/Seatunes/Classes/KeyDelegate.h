//
//  KeyDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class Key;

@protocol KeyDelegate <NSObject>

- (void) keyPressed:(Key *)key;

- (void) keyDepressed:(Key *)key;

@end
