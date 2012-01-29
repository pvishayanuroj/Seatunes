//
//  ScrollingMenuDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class ScrollingMenuItem;

@protocol ScrollingMenuDelegate <NSObject>

@optional

- (void) scrollingMenuItemClicked:(ScrollingMenuItem *)menuItem;

@end