//
//  GameLayer.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Keyboard;

@interface GameLayer : CCLayer {
 
    Keyboard *keyboard_;
    
}

+ (id) start;

- (id) init;

@end
