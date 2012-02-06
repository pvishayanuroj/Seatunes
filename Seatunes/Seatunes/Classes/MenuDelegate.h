//
//  MenuDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/5/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol MenuDelegate <NSObject>

- (void) menuItemSelected:(Button *)button;

@end