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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    CocosOverlayScrollView *scrollView = [[CocosOverlayScrollView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    // NOTE - I have hardcoded the size to 1024x1024 as that is the size of the levels in
    // our game.  Ideally this value would be parameterized or configurable.
    //
    scrollView.contentSize = CGSizeMake(320, 480);
    
    scrollView.delegate = scrollView;
    [scrollView setUserInteractionEnabled:TRUE];
    [scrollView setScrollEnabled:TRUE];
    
    self.view = scrollView;
    
    [scrollView release];
}
@end