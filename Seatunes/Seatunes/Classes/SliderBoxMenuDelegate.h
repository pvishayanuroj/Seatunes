//
//  SliderBoxDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol SlideBoxMenuDelegate <NSObject>

@optional

- (void) slideBoxMenuItemSelected:(Button *)button;

@end