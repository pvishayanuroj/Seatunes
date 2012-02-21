//
//  ScrollingMenuItem.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingMenuItemDelegate.h"

@interface ScrollingMenuItem : CCNode <CCTargetedTouchDelegate> {
    
    CGSize size_;
    
    NSUInteger numID_;
    
    id <ScrollingMenuItemDelegate> delegate_;
    
}

@property (nonatomic, assign) id <ScrollingMenuItemDelegate> delegate;
@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, readonly) CGFloat height;

+ (id) scrollingMenuItem:(NSUInteger)numID height:(CGFloat)height;

- (id) initScrollingMenuItem:(NSUInteger)numID height:(CGFloat)height;

- (BOOL) containsTouchLocation:(UITouch *)touch;

@end
