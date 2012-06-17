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

static const CGFloat SM_EPSILON = 0.001f;

@synthesize numID = numID_;
@synthesize menuItems = menuItems_;
@synthesize isClickable = isClickable_;
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
        isClickable_ = YES;
        prevOffset_ = CGPointZero;
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
#if DEBUG_SHOWDEALLOC
    NSLog(@"Scrolling Menu dealloc'd");
#endif
    
    [menuItems_ release];
    [currentMenuItem_ release];
    
    [super dealloc];
}

- (void) removeSuperview
{
    [viewController_.view removeFromSuperview];    
    [viewController_ release];    
}

- (void) setIsClickable:(BOOL)isClickable
{
    isClickable_ = isClickable;
    [viewController_ setClickable:isClickable];
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
    
    // Note: Apparently for glScissor, coordinates are in pixels, and not points. Account for this via the scale factor
    int factor = CC_CONTENT_SCALE_FACTOR();
    glScissor(menuFrame_.origin.x * factor, menuFrame_.origin.y * factor, menuFrame_.size.width * factor, menuFrame_.size.height * factor);
    
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);    
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isClickable_) {
    
        for (ScrollingMenuItem<CCTargetedTouchDelegate>  *item in menuItems_) {
            if ([item ccTouchBegan:touch withEvent:event]) {
                currentMenuItem_ = [item retain];
                return YES;
            }
        }
        return NO;
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

- (void) setMenuOffset:(NSUInteger)index
{
    if ([menuItems_ count] > 0) {
    
        NSUInteger idx = index;
        if (index >= [menuItems_ count]) {
            idx = [menuItems_ count] - 1;
        }
        
        CGFloat offset = 0;
        for (NSUInteger i = 0; i < index; ++i) {
            ScrollingMenuItem *item = [menuItems_ objectAtIndex:i];
            offset += item.height;
        }
    
        CGFloat maxOffset = scrollSize_ - menuFrame_.size.height;
        if (offset > maxOffset) {
            offset = maxOffset;
        }
        
        [viewController_.scrollView setContentOffset:ccp(0, offset) animated:YES];
    }
}

- (void) menuScrolled:(CGPoint)offset
{
    CGFloat top = 0 + SM_EPSILON;
    CGFloat bottom = scrollSize_ - menuFrame_.size.height - SM_EPSILON;
    //NSLog(@"bottom: %4.2f, prev: %4.2f, offset: %4.2f", bottom, prevOffset_.y, offset.y);
    
    // If leaving the top
    if (prevOffset_.y < top && offset.y > top) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuTopLeft:)]) {
            [delegate_ scrollingMenuTopLeft:self];
        }
    }
    // If leaving the bottom
    else if (prevOffset_.y > bottom && offset.y < bottom) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuBottomLeft:)]) {
            [delegate_ scrollingMenuBottomLeft:self];
        }        
    }
    
    // If reaching the top
    if (prevOffset_.y > top && offset.y < top) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuTopReached:)]) {
            [delegate_ scrollingMenuTopReached:self];
        }        
    }
    // If reaching the bottom
    else if (prevOffset_.y < bottom && offset.y > bottom) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuBottomReached:)]) {
            [delegate_ scrollingMenuBottomReached:self];
        }      
    }
    
    prevOffset_ = offset;
}

- (BOOL) isDownArrowNeeded
{
    return scrollSize_ > menuFrame_.size.height && prevOffset_.y < SM_EPSILON;
}

@end
