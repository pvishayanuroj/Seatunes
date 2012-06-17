//
//  AudioManagerDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/13/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol AudioManagerDelegate <NSObject>

- (void) narrationComplete:(SpeechType)speechType;

@end