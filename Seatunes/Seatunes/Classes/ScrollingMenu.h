//
//  ScrollingMenu.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingMenuDelegate.h"
#import "ScrollingMenuItemDelegate.h"

@class CocosOverlayViewController;
@class ScrollingMenuItem;

@interface ScrollingMenu : CCLayer <ScrollingMenuItemDelegate> {
 
    CocosOverlayViewController *viewController_;
 
    CGRect menuFrame_;
    
    NSMutableArray *menuItems_;
    
    CGFloat scrollSize_;
    
    CGFloat paddingSize_;
    
    ScrollingMenuItem *currentMenuItem_;
    
    id <ScrollingMenuDelegate> delegate_;
}

@property (nonatomic, assign) id <ScrollingMenuDelegate> delegate;

+ (id) scrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

- (id) initScrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

- (void) addMenuItem:(ScrollingMenuItem *)menuItem;

/* 
 * This method MUST be called prior to releasing Scrolling Menu,
 * because the view controller holds a reference to self
 */
- (void) removeSuperview;

@end
