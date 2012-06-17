//
//  Menu.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/5/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuDelegate.h"
#import "ButtonDelegate.h"

@interface Menu : CCNode <ButtonDelegate> {
    
    NSUInteger numItems_;
    
    CGFloat paddingSize_;
    
    CGFloat offset_;
    
    BOOL isVertical_;
    
    id <MenuDelegate> delegate_;
    
}

@property (nonatomic, assign) id <MenuDelegate> delegate;

+ (id) menu:(CGFloat)paddingSize isVertical:(BOOL)isVertical;

+ (id) menu:(CGFloat)paddingSize isVertical:(BOOL)isVertical offset:(CGFloat)offset;

- (id) initMenu:(CGFloat)paddingSize isVertical:(BOOL)isVertical offset:(CGFloat)offset;

- (void) addMenuBackground:(NSString *)filename pos:(CGPoint)pos;

- (void) addMenuItem:(Button *)menuItem;

@end
