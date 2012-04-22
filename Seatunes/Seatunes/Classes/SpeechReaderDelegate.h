//
//  SpeechReaderDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/7/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol SpeechReaderDelegate <NSObject>

@optional

- (void) narrationStarting:(SpeechType)speechType;

- (void) narrationStopped:(SpeechType)speechType;

- (void) speechComplete:(SpeechType)speechType;

- (void) bubbleComplete:(SpeechType)speechType;

- (void) bubbleClicked:(SpeechType)speechType;

@end