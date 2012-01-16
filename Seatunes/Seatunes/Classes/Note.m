//
//  Note.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Note.h"
#import "Utility.h"

@implementation Note

+ (id) note:(KeyType)keyType
{
    return [[[self alloc] initNote:keyType] autorelease];
}

- (id) initNote:(KeyType)keyType
{
    if ((self = [super init])) {
        
        NSString *keyName = [Utility keyNameFromEnum:keyType];
        NSString *spriteFrameName = [NSString stringWithFormat:@"Bubble %@.png", keyName];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain]; 
        [self addChild:sprite_];        
        
        [self blowAction];
        //[self curveAction];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (void) floatAction
{
    CCActionInterval *up = [CCMoveBy actionWithDuration:4.0f position:ccp(0, 500.0f)];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [self runAction:[CCSequence actions:up, done, nil]];
}

- (void) blowAction
{
    CGFloat time = 1.5f;
    
    CGFloat originalScale = 1.0f;
    CCScaleTo *flatten = [CCScaleTo actionWithDuration:0.25f * originalScale scaleX:1.1f*originalScale scaleY:0.8f*originalScale];
    CCScaleTo *elongate = [CCScaleTo actionWithDuration:0.25f * originalScale scaleX:0.8f*originalScale scaleY:1.1f*originalScale];
    CCSequence *wobble = [CCSequence actions:flatten, elongate, nil];
    CCRepeatForever *repeatWobble = [CCRepeatForever actionWithAction:wobble];
    
    
    CCActionInterval *move = [CCMoveBy actionWithDuration:time position:ccp(300.0f, -30.0f)];
    //CCActionInterval *ease = [CCEaseExponentialOut actionWithAction:move];
    CCActionInterval *ease = [CCEaseOut actionWithAction:move rate:1.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(blowActionDone)];
    
    [self runAction:repeatWobble];
    [self runAction:[CCSequence actions:ease, done, nil]];
    [self scaleAction];
}

- (void) blowActionDone
{
    //[self curveAction];
    //[self scaleAction];
}

- (void) scaleAction
{
    CCActionInterval *scale = [CCScaleBy actionWithDuration:1.5f scale:2.5f];
    CCActionInterval *ease = [CCEaseIn actionWithAction:scale rate:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(scaleActionDone)];    
    [sprite_ runAction:[CCSequence actions:ease, done, nil]];
}

- (void) scaleActionDone
{
    NSLog(@"scale done");
    
    [self destroy];
}

- (void) burstAction
{
    
}

- (void) curveAction
{
    ccBezierConfig bz;
    bz.endPosition = ccp(300, -15);
    bz.controlPoint_1 = ccp(100, -30);
    bz.controlPoint_2 = ccp(200, -35);
    //bz.endPosition = ccp(225, 400);
    //bz.controlPoint_1 = ccp(110, -35);
    //bz.controlPoint_2 = ccp(240, -30);
    CCActionInterval *curve = [CCBezierBy actionWithDuration:1.0f bezier:bz];
    CCActionInterval *ease = [CCEaseOut actionWithAction:curve rate:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(curveActionDone)];
    [self runAction:[CCSequence actions:ease, done, nil]];
}

- (void) curveActionDone
{
    [self floatAction];
}

@end
