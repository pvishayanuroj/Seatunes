//
//  CocosOverlayScrollView.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CocosOverlayScrollView.h"
#import "cocos2d.h"

@implementation CocosOverlayScrollView

@synthesize node = node_;

+ (id) cocosOverlayScrollView
{
    return [[[self alloc] initCocosOverlayScrollView] autorelease];
}

- (id) initCocosOverlayScrollView
{
    if ((self = [self initWithFrame:[UIScreen mainScreen].applicationFrame])) {
     
        firstScroll_ = YES;
    
    }
    return self;
}

- (void) dealloc
{
    [node_ release];
    
    [super dealloc];
}

- (void) touchesBegan:(NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging) {
        
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        //CGPoint p = [touch locationInView:[touch view]];
        //NSLog(@"p.y: %4.2f", p.y);
        
        CCNode<CCTargetedTouchDelegate> *node = (CCNode<CCTargetedTouchDelegate> *)node_;
        [node ccTouchBegan:touch withEvent:event];
        //[[[CCDirector sharedDirector] openGLView] touchesBegan:touches withEvent:event];
    }
    
    [super touchesBegan: touches withEvent:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CCNode<CCTargetedTouchDelegate> *node = (CCNode<CCTargetedTouchDelegate> *)node_;
        [node ccTouchMoved:touch withEvent:event];        
    }
    
    [super touchesMoved:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging) {
        
        UITouch *touch = [[touches allObjects] objectAtIndex:0];
        CCNode<CCTargetedTouchDelegate> *node = (CCNode<CCTargetedTouchDelegate> *)node_;
        [node ccTouchEnded:touch withEvent:event];                
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (firstScroll_) {
        originalPos_ = node_.position;
        firstScroll_ = NO;
    }
    
    CGPoint dragPt = [scrollView contentOffset];
    CGFloat newY = dragPt.y + originalPos_.y;
    
    //NSLog(@"OrigY: %4.2f, Prev pt: %4.2f, new pt: %4.2f", originalPos_.y, node_.position.y, newY);
    node_.position = CGPointMake(node_.position.x, newY);
}

// Override
- (void)setContentOffset:(CGPoint)contentOffset {
	// UIScrollView uses UITrackingRunLoopMode.
	// NSLog([[NSRunLoop currentRunLoop] currentMode]);
    
	// If we're dragging, mainLoop is going to freeze.
	if (self.dragging && !self.decelerating) {
        
		// Make sure we haven't already created our timer.
		if (timer_ == nil) {
            
			// Schedule a new UITrackingRunLoopModes timer, to fill in for CCDirector while we drag.
			timer_ = [NSTimer scheduledTimerWithTimeInterval:[[CCDirector sharedDirector] animationInterval] target:self selector:@selector(animateWhileDragging) userInfo:nil repeats:YES];
            
            // This could also be NSRunLoopCommonModes
			[[NSRunLoop currentRunLoop] addTimer:timer_ forMode:UITrackingRunLoopMode];
		}
	}
    
	// If we're decelerating, mainLoop is going to stutter.
	if (self.decelerating && !self.dragging) {
        
		// Make sure we haven't already created our timer.
		if (timer_ == nil) {
            
			// Schedule a new UITrackingRunLoopMode timer, to fill in for CCDirector while we decellerate.
			timer_ = [NSTimer scheduledTimerWithTimeInterval:[[CCDirector sharedDirector] animationInterval] target:self selector:@selector(animateWhileDecellerating) userInfo:nil repeats:YES];
			[[NSRunLoop currentRunLoop] addTimer:timer_ forMode:UITrackingRunLoopMode];
		}
	}
    
	[super setContentOffset:contentOffset];
}

- (void)animateWhileDragging {
    
	// Draw.
	[[CCDirector sharedDirector] drawScene];
    
	if (!self.dragging) {
        
		// Don't need this timer anymore.
		[timer_ invalidate];
		timer_ = nil;
	}
}

- (void)animateWhileDecellerating {
    
	// Draw.
	[[CCDirector sharedDirector] drawScene];
    
	if (!self.decelerating) {
        
		// Don't need this timer anymore.
		[timer_ invalidate];
		timer_ = nil;
	}
}

@end