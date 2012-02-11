//
//  SpeechBubbleDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/8/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class SpeechBubble;

@protocol SpeechBubbleDelegate <NSObject>

@optional

- (void) bubbleComplete:(SpeechBubble *)speechBubble;

@end