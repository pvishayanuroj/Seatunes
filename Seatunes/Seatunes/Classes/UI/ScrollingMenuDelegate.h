//
//  ScrollingMenuDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class ScrollingMenu;
@class ScrollingMenuItem;

@protocol ScrollingMenuDelegate <NSObject>

@optional

- (void) scrollingMenuItemClicked:(ScrollingMenu *)scrollingMenu menuItem:(ScrollingMenuItem *)menuItem;

- (void) scrollingMenuTopReached:(ScrollingMenu *)scrollingMenu;

- (void) scrollingMenuBottomReached:(ScrollingMenu *)scrollingMenu;

- (void) scrollingMenuTopLeft:(ScrollingMenu *)scrollingMenu;

- (void) scrollingMenuBottomLeft:(ScrollingMenu *)scrollingMenu;

@end