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
    
    ScrollingMenuItem *currentMenuItem_;
    
    NSUInteger numID_;    
    
    id <ScrollingMenuDelegate> delegate_;
}

@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, readonly) NSMutableArray *menuItems;
@property (nonatomic, assign) id <ScrollingMenuDelegate> delegate;

+ (id) scrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize numID:(NSUInteger)numID;

- (id) initScrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize numID:(NSUInteger)numID;

- (void) addMenuItem:(ScrollingMenuItem *)menuItem;

/* 
 * This method MUST be called prior to releasing Scrolling Menu,
 * because the view controller holds a reference to self
 */
- (void) removeSuperview;

@end
