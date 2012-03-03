//
//  CocosOverlayViewController.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CocosOverlayViewController.h"
#import "CocosOverlayScrollView.h"

@implementation CocosOverlayViewController

+ (id) cocosOverlayViewController:(CCNode *)node contentSize:(CGSize)contentSize frame:(CGRect)frame
{
    return [[[self alloc] init:node contentSize:contentSize frame:frame] autorelease];
}

- (id) init:(CCNode *)node contentSize:(CGSize)contentSize frame:(CGRect)frame
{
    if ((self = [super init])) {
        
        node_ = [node retain];
        contentSize_ = contentSize;
        frame_ = frame;
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_SHOWDEALLOC    
    NSLog(@"Cocos overlay view controller dealloc'd");
#endif
    
    [scrollView_ release];
    [node_ release];
    
    [super dealloc];
}

- (void) loadView
{
    scrollView_ = [[CocosOverlayScrollView cocosOverlayScrollView] retain];
    
    scrollView_.contentSize = contentSize_;
    scrollView_.frame = frame_;
    scrollView_.bounds = scrollView_.frame;
    scrollView_.node = node_;
    
    // Forces scrollbar to the top (depending on parameters, it could start in the middle)
    CGPoint offset = CGPointMake(0, 0);
    [scrollView_ setContentOffset:offset animated:NO];
    
    scrollView_.delegate = scrollView_;
    [scrollView_ setUserInteractionEnabled:TRUE];
    [scrollView_ setScrollEnabled:TRUE];
    
    self.view = scrollView_;
}

- (void) setClickable:(BOOL)clickable
{
    scrollView_.scrollEnabled = clickable;
}

@end