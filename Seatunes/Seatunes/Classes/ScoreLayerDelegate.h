//
//  ScoreLayerDelegate.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

@class Button;

@protocol ScoreLayerDelegate <NSObject>

- (void) scoreLayerMenuItemSelected:(Button *)button;

@end