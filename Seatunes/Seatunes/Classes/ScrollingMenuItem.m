//
//  ScrollingMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScrollingMenuItem.h"


@implementation ScrollingMenuItem

static NSUInteger countID = 0;

+ (id) scrollingMenuItem
{
    return [[[self alloc] initScrollingMenuItem] autorelease];
}

- (id) initScrollingMenuItem
{
    if ((self = [super init])) {
        
        NSString *name = @"Bubble C4.png";
        sprite_ = [CCSprite spriteWithSpriteFrameName:name];
        [self addChild:sprite_];
        
        unitID_ = countID++;
        
    }
    return self;
}

/*
- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}
*/
- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - (r.size.width * sprite_.scaleX) / 2, sprite_.position.y - 
                      (r.size.height *sprite_.scaleY ) / 2, r.size.width * sprite_.scaleX, r.size.height * sprite_.scaleY);
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

    //NSLog(@"origin: %4.2f, size: %4.2f", yOrigin, view.frame.size.height);
    
    // At this point it's in reference to the screen's coordinates
    point = ccpSub(offset, point);
    
    point = [self convertToNodeSpaceAR:point];     
    return point;
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    //NSLog(@"touch began in menuitem");
    if ([self containsTouchLocation:touch]) {

        NSLog(@"item %d got it", unitID_);
         
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
        NSLog(@"touch ended for: %d", unitID_);
    }
}


@end
