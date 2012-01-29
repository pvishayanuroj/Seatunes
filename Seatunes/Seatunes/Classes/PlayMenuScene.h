//
//  PlayMenuScene.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SliderBoxMenuDelegate.h"
#import "ScrollingMenuDelegate.h"

@class ScrollingMenu;
@class SliderBoxMenu;

@interface PlayMenuScene : CCScene <SlideBoxMenuDelegate, ScrollingMenuDelegate> {
    
    ScrollingMenu *scrollingMenu_;
    
    SliderBoxMenu *sliderBoxMenu_;
    
    /* Maps song menu item IDs to song names */
    NSMutableDictionary *songIDs_;
    
}

@end
