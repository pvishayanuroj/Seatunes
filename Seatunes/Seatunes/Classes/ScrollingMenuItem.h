//
//  ScrollingMenuItem.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScrollingMenuItem : CCNode <CCTargetedTouchDelegate> {
    
    CCSprite *sprite_;
    
    NSUInteger unitID_;
    
}

+ (id) scrollingMenuItem;

- (id) initScrollingMenuItem;

@end
