//
//  Bubble.h
//  Little Ocean
//
//  Created by Jamorn Horathai on 1/24/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
 
@interface Bubble : CCNode <CCTargetedTouchDelegate> {
    
    CCSprite *sprite_;
    
    BOOL isClickable_;
    
}

@property (nonatomic, assign) BOOL isClickable;

+ (id) bubbleWithTouchPriority:(NSInteger)touchPriority;

- (id) initWithTouchPriority:(NSInteger)touchPriority;

- (void) initAnimations;

- (void) floatUp;

@end
