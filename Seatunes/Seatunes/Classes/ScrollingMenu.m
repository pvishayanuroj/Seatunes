//
//  ScrollingMenu.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScrollingMenu.h"
#import "CocosOverlayViewController.h"
#import "ScrollingMenuItem.h"

@implementation ScrollingMenu

@synthesize numID = numID_;
@synthesize delegate = delegate_;

+ (id) scrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize numID:(NSUInteger)numID
{
    return [[[self alloc] initScrollingMenu:menuFrame scrollSize:scrollSize numID:numID] autorelease];
}

- (id) initScrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize numID:(NSUInteger)numID
{
    if ((self = [super init])) {

        self.position = CGPointMake(menuFrame.origin.x, menuFrame.origin.y + menuFrame.size.height);        
        
        numID_ = numID;
        scrollSize_ = scrollSize;
        menuFrame_ = menuFrame;
        currentMenuItem_ = nil;
        delegate_ = nil;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Convert to cocos coordinate system
        CGFloat yOrigin = winSize.height - (menuFrame.origin.y + menuFrame.size.height);
        
        CGSize contentSize = CGSizeMake(menuFrame.size.width, scrollSize);
        CGRect frame = CGRectMake(menuFrame.origin.x, yOrigin, 
                                  menuFrame.size.width, menuFrame.size.height);        
        
        viewController_ = [[CocosOverlayViewController cocosOverlayViewController:self contentSize:contentSize frame:frame] retain];
        [[[CCDirector sharedDirector] openGLView] addSubview:viewController_.view];

        menuItems_ = [[NSMutableArray array] retain];
    }
    return self;
}

- (void) dealloc
{
    NSLog(@"Scrolling Menu dealloc'd");
    
    [menuItems_ release];
    //[viewController_.view removeFromSuperview];
    [currentMenuItem_ release];
    
    [super dealloc];
}

- (void) removeSuperview
{
    [viewController_.view removeFromSuperview];    
    [viewController_ release];    
}

- (void) addMenuItem:(ScrollingMenuItem *)menuItem
{
    NSUInteger count = [menuItems_ count];
    menuItem.delegate = self;
    menuItem.width = menuFrame_.size.width;
    menuItem.position = CGPointMake(0, -(count * menuItem.height + menuItem.height / 2));
    [menuItems_ addObject:menuItem];
    [self addChild:menuItem];       
}

- (void) visit
{
    glEnable(GL_SCISSOR_TEST);
    
    glScissor(menuFrame_.origin.x, menuFrame_.origin.y, menuFrame_.size.width, menuFrame_.size.height);
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);    
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    for (ScrollingMenuItem<CCTargetedTouchDelegate>  *item in menuItems_) {
        if ([item ccTouchBegan:touch withEvent:event]) {
            currentMenuItem_ = [item retain];
            return YES;
        }
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (currentMenuItem_) {
        [currentMenuItem_ ccTouchMoved:touch withEvent:event];
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (currentMenuItem_) {
        [currentMenuItem_ ccTouchEnded:touch withEvent:event];
        [currentMenuItem_ release];
        currentMenuItem_ = nil;
    }
}

- (void) scrollingMenuItemClicked:(ScrollingMenuItem *)menuItem
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuItemClicked:menuItem:)]) {
        [delegate_ scrollingMenuItemClicked:self menuItem:menuItem];
    }
}

@end
