//
//  SliderBoxDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class Button;

@protocol SlideBoxMenuDelegate <NSObject>

- (void) menuItemSelected:(Button *)button;

@end