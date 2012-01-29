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

+ (id) scrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize
{
    return [[[self alloc] initScrollingMenu:menuFrame scrollSize:scrollSize] autorelease];
}

- (id) initScrollingMenu:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize
{
    if ((self = [super init])) {
        
        self.position = CGPointMake(menuFrame.origin.x, menuFrame.origin.y + menuFrame.size.height);        
        
        scrollSize_ = scrollSize;
        menuFrame_ = menuFrame;
        paddingSize_ = 40;
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        // Convert to cocos coordinate system
        CGFloat yOrigin = winSize.height - (menuFrame.origin.y + menuFrame.size.height);
        
        CGSize contentSize = CGSizeMake(menuFrame.size.width, scrollSize);
        CGRect frame = CGRectMake(menuFrame.origin.x, yOrigin, 
                                  menuFrame.size.width, menuFrame.size.height);        
        
        viewController_ = [[CocosOverlayViewController cocosOverlayViewController:self contentSize:contentSize frame:frame] retain];
        [[[CCDirector sharedDirector] openGLView] addSubview:viewController_.view];
        
        menuItems_ = [[NSMutableArray array] retain];
        
        for ( int i = 0 ; i < 10; i++) {
            ScrollingMenuItem *item = [ScrollingMenuItem scrollingMenuItem];
            [self addMenuItem:item];
            //item.position = ccp(100, i * 40);
            //[self addChild:item];
        }
        
        ScrollingMenuItem *item = [ScrollingMenuItem scrollingMenuItem];
        //[menuItems_ addObject:item];        
        //item.position = CGPointMake(100, -1000);
        //[self addChild:item];        
    }
    return self;
}

- (void) dealloc
{
    [menuItems_ release];
    [viewController_.view removeFromSuperview];
    [viewController_ release];
    
    [super dealloc];
}

- (void) addMenuItem:(ScrollingMenuItem *)menuItem
{
    NSUInteger count = [menuItems_ count];
    menuItem.position = CGPointMake(100, -(count * paddingSize_ + 50));
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
            return YES;
        }
    }
    return NO;
}


@end