//
//  PlayMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PlayMenuScene.h"
#import "SliderBoxMenu.h"
#import "ScrollingMenu.h"
#import "Button.h"
#import "ScrollingMenuItem.h"

@implementation PlayMenuScene

- (id) init
{
    if ((self = [super init])) {
        

        
        sliderBoxMenu_ = [[SliderBoxMenu sliderBoxMenu:80] retain];
        [self addChild:sliderBoxMenu_];
        
    }
    return self;
}

- (void) dealloc
{
    [scrollingMenu_ release];
    [sliderBoxMenu_ release];
    
    [super dealloc];
}

- (void) slideBoxMenuItemSelected:(Button *)button
{
    
}

- (void) scrollingMenuItemClicked:(ScrollingMenuItem *)menuItem
{
    
}

- (void) loadScrollingMenu:(PackType)packType
{
    [scrollingMenu_ release];
    
    CGRect menuFrame = CGRectMake(1024 - 650, 0, 650, 600);
    CGFloat scrollSize = 1000;
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize] retain];
    [self addChild:scrollingMenu_];    
}

@end
