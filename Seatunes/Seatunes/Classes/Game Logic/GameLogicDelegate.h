//
//  GameLogicDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/13/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol GameLogicDelegate <NSObject>

- (void) exerciseComplete;

- (void) lastNotePlayed; 

- (void) songComplete:(ScoreInfo)scoreInfo;

- (void) showKeyboardLettersComplete;

- (void) hideKeyboardLettersComplete;

@end