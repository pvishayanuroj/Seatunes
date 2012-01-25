//
//  MenuItem.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuItem : CCNode <CCTargetedTouchDelegate> {
    
    CCSprite *sprite_;
    
    NSUInteger unitID_;
    
}

+ (id) menuItem;

- (id) initMenuItem;

@end
