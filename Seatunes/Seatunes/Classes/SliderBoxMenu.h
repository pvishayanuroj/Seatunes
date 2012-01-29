//
//  SliderBoxMenu.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "SliderBoxMenuDelegate.h"

@class Button;

@interface SliderBoxMenu : CCNode <ButtonDelegate> {
    
    CCSprite *sprite_;
    
    NSUInteger currentItem_;
    
    NSMutableArray *items_;
    
    NSMutableDictionary *itemMap_;
    
    BOOL isMoving_;
    
    CGFloat paddingSize_;
    
    id <SlideBoxMenuDelegate> delegate_;
    
}

@property (nonatomic, assign) id <SlideBoxMenuDelegate> delegate;

+ (id) sliderBoxMenu:(CGFloat)paddingSize;

- (id) initSliderBoxMenu:(CGFloat)paddingSize; 

- (void) addMenuItem:(Button *)menuItem;

- (void) moveBoxTo:(NSUInteger)index;

@end
