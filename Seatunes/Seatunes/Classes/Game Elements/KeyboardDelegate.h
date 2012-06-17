//
//  KeyboardDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@protocol KeyboardDelegate <NSObject>

@optional

- (void) keyboardKeyPressed:(KeyType)keyType;

- (void) keyboardKeyDepressed:(KeyType)keyType time:(CGFloat)time;

- (void) showLettersComplete;

- (void) hideLettersComplete;

- (void) applauseComplete;

@end
