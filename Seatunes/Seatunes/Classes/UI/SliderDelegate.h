//
//  SliderDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/21/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@protocol SliderDelegate <NSObject>

@optional

- (void) sliderUpdated:(CGFloat)value;

- (void) doneSliding:(CGFloat)value;

@end