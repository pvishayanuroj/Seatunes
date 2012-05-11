//
//  Bubble.m
//  Little Ocean
//
//  Created by Jamorn Horathai on 1/24/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import "Bubble.h"
#import "AudioManager.h"

@implementation Bubble

@synthesize isClickable = isClickable_;

+ (id) bubbleWithTouchPriority:(NSInteger)touchPriority
{
    return [[[Bubble alloc] initWithTouchPriority:touchPriority] autorelease];
}

- (id) initWithTouchPriority:(NSInteger)touchPriority
{
    if ((self = [super init])) {
        
        isClickable_ = YES;
        
        sprite_ = [[CCSprite spriteWithFile:@"Bubble.png"] retain];
        [self addChild:sprite_];        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) initAnimations
{
    float originalScale = self.scale;
    
    CCScaleTo *flatten = [CCScaleTo actionWithDuration:0.5f * originalScale scaleX:1.1f*originalScale scaleY:0.8f*originalScale];
    CCScaleTo *elongate = [CCScaleTo actionWithDuration:0.5f * originalScale scaleX:0.8f*originalScale scaleY:1.1f*originalScale];
    CCSequence *wobble = [CCSequence actions:flatten, elongate, nil];
    CCRepeatForever *repeatWobble = [CCRepeatForever actionWithAction:wobble];
    
    [self runAction:repeatWobble];
    
    CCMoveBy *moveLeft = [CCMoveBy actionWithDuration:0.8f * self.scale position:ccp(-20 * self.scale,0)];
    CCMoveBy *moveRight = [CCMoveBy actionWithDuration:0.8f * self.scale position:ccp(20 * self.scale,0)];
    CCSequence *moveLeftRight = [CCSequence actions:moveLeft,moveRight, nil];
    CCRepeatForever *repeatMove = [CCRepeatForever actionWithAction:moveLeftRight];
    
    [self runAction:repeatMove];
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.1f];
    [sprite_ runAction:fadeIn];    
}

- (void) floatUp
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    // Calculate how much the duration should be reduced by in order to adjust for start position.
    CGFloat durationMultiplier = 1.0f - (self.position.y / ((size.height + 50) / self.scale));
    
    CGFloat duration = 3.0f + 7.5f * self.scale;
    CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:ccp(self.position.x, size.height + 50)];    
    //CCMoveTo *move = [CCMoveTo actionWithDuration:duration position:ccp(self.position.x, (size.height + 50) / self.scale)];
    //CCMoveTo *move = [CCMoveTo actionWithDuration:(3.0f + (4.5f * sprite_.scale)) * durationMultiplier position:ccp(self.position.x, (size.height + 50) / self.scale)];
    CCCallBlock *done = [CCCallBlock actionWithBlock:^{
        [self removeFromParentAndCleanup:YES];
    }];
    
    [self runAction:[CCSequence actions:move, done,nil]];
}

- (void) onEnter
{
    
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];    

    [self initAnimations];
    [self floatUp];
    
    [super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (void) bubblePopAction
{
    isClickable_ = NO;
    [self stopAllActions];
    
    [self scaleAction];
    [[AudioManager audioManager] playSoundEffect:kBubblePop2];
}

- (void) scaleAction
{
    CCActionInterval *scale = [CCScaleTo actionWithDuration:0.08f scale:2.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(scaleActionDone)];        
    [sprite_ runAction:[CCSequence actions:scale, done, nil]];
}

- (void) scaleActionDone
{
    [self stopAllActions];    
    [sprite_ removeFromParentAndCleanup:YES]; 
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"Bubble Burst.png"];
    [self addChild:sprite];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.05f];
    
    CCActionInstant *done = [CCCallBlockN actionWithBlock:^(CCNode *node) {
        [self removeFromParentAndCleanup:YES];
    }];
    
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - (r.size.width * sprite_.scaleX) / 2, sprite_.position.y - 
                      (r.size.height *sprite_.scaleY ) / 2, r.size.width * sprite_.scaleX, r.size.height * sprite_.scaleY);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (isClickable_ && [self containsTouchLocation:touch]) {
        [self bubblePopAction];    
        return YES;
    }
    
    return NO;
}


@end
