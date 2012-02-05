//
//  SpeechBubble.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpeechBubble : CCNode {
    
}

+ (id) staticSpeechBubble:(NSString *)text;

+ (id) tapSpeechBubble:(NSString *)text;

- (id) initSpeechBubble:(NSString *)text isStatic:(BOOL)isStatic;

- (void) destroy;

@end
