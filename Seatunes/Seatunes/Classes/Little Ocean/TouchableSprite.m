//
//  TouchableSprite.m
//  Little Ocean
//
//  Created by Jamorn Horathai on 1/23/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import "TouchableSprite.h"

@implementation TouchableSprite

@synthesize isEnabled=isEnabled_;

- (id) initWithFile:(NSString *)filename touchPriority:(NSInteger)touchPriority swallowsTouches:(BOOL)swallowsTouches
{
    if ((self = [super initWithFile:filename])) {
        
        isEnabled_ = YES;
        touchPriority_ = touchPriority;
        swallowsTouches_ = swallowsTouches;
        
    }
    return self;
}

- (void) onEnter
{
    [super onEnter];
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:touchPriority_ swallowsTouches:swallowsTouches_];
}

- (void) onExit
{
    [super onExit];
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{
	CGRect rect = [self textureRect];
    rect.origin.x = rect.origin.x - (rect.size.width * self.anchorPoint.x);
    rect.origin.y = rect.origin.y - (rect.size.height * self.anchorPoint.y);
    
	return CGRectContainsPoint(rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

@end
