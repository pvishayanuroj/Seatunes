//
//  KeyboardLetter.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/14/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface KeyboardLetter : CCNode {
    
    CCSprite *sprite_;
    
    CCLabelBMFont *label_;
    
}

+ (id) keyboardLetter:(NSString *)letter;

- (id) initKeyboardLetter:(NSString *)letter;

@end
