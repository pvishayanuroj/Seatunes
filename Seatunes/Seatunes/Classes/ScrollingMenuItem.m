//
//  ScrollingMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScrollingMenuItem.h"


@implementation ScrollingMenuItem

@synthesize delegate = delegate_;
@synthesize numID = numID_;

+ (id) scrollingMenuItem:(NSUInteger)numID height:(CGFloat)height
{
    return [[[self alloc] initScrollingMenuItem:numID height:height] autorelease];
}

- (id) initScrollingMenuItem:(NSUInteger)numID height:(CGFloat)height
{
    if ((self = [super init])) {
        
        size_ = CGSizeMake(0, height);
        numID_ = numID;
        delegate_ = nil;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (CGFloat) width
{
    return size_.width;
}

- (void) setWidth:(CGFloat)width
{
    size_.width = width;
}

- (CGFloat) height
{
    return size_.height;
}

- (CGRect) rect
{
    return CGRectMake(-size_.width / 2, -size_.height / 2, size_.width, size_.height);
}

- (CGPoint) convertTouchToNodeSpaceAR:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [touch view]];

    // Account for the scroll offset
    UIScrollView *view = (UIScrollView *)touch.view;    
    point.y = point.y - view.contentOffset.y;
    
    CGFloat yOrigin = view.frame.origin.y;
    CGFloat yHeight = view.frame.size.height;
    CGSize winSize = [[CCDirector sharedDirector] winSize];

    yOrigin = -((yOrigin - winSize.height) + yHeight);
    
    CGPoint offset = CGPointMake(view.frame.origin.x + view.frame.size.width, yOrigin + view.frame.size.height);

    // At this point it's in reference to the screen's coordinates
    point.y = offset.y - point.y;
    
    // Convert to the menu item's frame of reference
    point = [self convertToNodeSpaceAR:point];
    return point;
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if ([self containsTouchLocation:touch]) {

        //NSLog(@"item %d got it", numID_);
         
        return YES;
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch]) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(scrollingMenuItemClicked:)]) {
            [delegate_ scrollingMenuItemClicked:self];
        }
        //NSLog(@"touch ended for: %d", numID_);
    }
}


@end
