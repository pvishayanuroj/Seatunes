//
//  Light.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Note;

@interface Light : CCNode {
    
    CCSprite *fish_;
    
    CCSprite *spotlight_;    
    
    CGFloat lowerBoundSlope_;
    
    CGFloat upperBoundSlope_;    
    
}

+ (id) light;

- (id) initLight;

- (BOOL) isLightOn;

- (void) turnOn:(KeyType)key;

- (void) turnOff;

- (BOOL) noteIntersectLight:(Note *)note;

- (BOOL) noteWithinLight:(Note *)note;

- (CGFloat) yLowerBoundaryForPos:(CGPoint)pos;

- (CGFloat) yUpperBoundaryForPos:(CGPoint)pos;

@end
