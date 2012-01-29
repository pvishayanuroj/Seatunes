//
//  ScrollingMenu.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CocosOverlayViewController;
@class ScrollingMenuItem;

@interface ScrollingMenu : CCLayer {
 
    CocosOverlayViewController *viewController_;
 
    CGRect menuFrame_;
    
    NSMutableArray *menuItems_;
    
    CGFloat scrollSize_;
    
    CGFloat paddingSize_;
}

+ (id) scrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

- (id) initScrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

- (void) addMenuItem:(ScrollingMenuItem *)menuItem;

@end
