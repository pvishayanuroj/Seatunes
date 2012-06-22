//
//  Slider.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SliderDelegate.h"

@interface Slider : CCNode {
    
    UISlider *slider_;
    
    id <SliderDelegate> delegate_;
}

@property (nonatomic, assign) id <SliderDelegate> delegate;

+ (id) slider:(CGPoint)position width:(CGFloat)width;

- (id) initSlider:(CGPoint)position width:(CGFloat)width;

- (void) setSlider:(CGFloat)value;

- (void) setSliderNoAnimation:(CGFloat)value;

- (void) remove;

@end
