//
//  MenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MenuItem.h"


@implementation MenuItem

static NSUInteger countID = 0;

+ (id) menuItem
{
    return [[[self alloc] initMenuItem] autorelease];
}

- (id) initMenuItem
{
    if ((self = [super init])) {
        
        NSString *name = @"Bubble C4.png";
        sprite_ = [CCSprite spriteWithSpriteFrameName:name];
        [self addChild:sprite_];
        
        unitID_ = countID++;
        
    }
    return self;
}

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

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - (r.size.width * sprite_.scaleX) / 2, sprite_.position.y - 
                      (r.size.height *sprite_.scaleY ) / 2, r.size.width * sprite_.scaleX, r.size.height * sprite_.scaleY);
}

- (CGPoint)convertTouchToNodeSpaceAR:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [touch view]];
    UIScrollView *view = (UIScrollView *)touch.view;    
    point.y = point.y - view.contentOffset.y;
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToNodeSpaceAR:point];
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    //NSLog(@"touch began in menuitem");
    if ([self containsTouchLocation:touch]) {
        UIScrollView *view = (UIScrollView *)touch.view;
        NSLog(@"OFFSET: %4.2f", view.contentOffset.y);
        
        
        CGPoint pt = [touch locationInView: [touch view]];        
//        CGPoint pt = [self convertTouchToNodeSpaceAR:touch];
        //NSLog(@"%4.2f, %4.2f", pt.x, pt.y);
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
}


@end
