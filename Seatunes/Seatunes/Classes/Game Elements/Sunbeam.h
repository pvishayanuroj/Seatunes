//
//  Sunbeam.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 5/12/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Sunbeam : CCNode {
    
    CCSprite *sprite_;
    
}

+ (id) sunbeam:(NSString *)spriteName period:(CGFloat)period;

- (id) initSunbeam:(NSString *)spriteName period:(CGFloat)period;

@end
