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
    [scrollView_ release];
    [node_ release];
    
    [super dealloc];
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView
{
    //CocosOverlayScrollView *scrollView = [[CocosOverlayScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    CocosOverlayScrollView *scrollView = [CocosOverlayScrollView cocosOverlayScrollView];
    
    scrollView.contentSize = contentSize_;
    scrollView.frame = frame_;
    scrollView.bounds = scrollView.frame;
    scrollView.node = node_;
    
    // Forces scrollbar to the top (depending on parameters, it could start in the middle)
    CGPoint offset = CGPointMake(0, 0);
    [scrollView setContentOffset:offset animated:NO];
    
    scrollView.delegate = scrollView;
    [scrollView setUserInteractionEnabled:TRUE];
    [scrollView setScrollEnabled:TRUE];
    
    self.view = scrollView;
}

@end