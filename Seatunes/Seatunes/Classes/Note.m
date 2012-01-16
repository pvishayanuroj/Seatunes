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
    CCActionInterval *up = [CCMoveBy actionWithDuration:5.0f position:ccp(0, 500.0f)];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [self runAction:[CCSequence actions:up, done, nil]];
}

- (void) blowAction
{
    CCActionInterval *move = [CCMoveBy actionWithDuration:1.5f position:ccp(200.0f, -60.0f)];
    //CCActionInterval *ease = [CCEaseExponentialOut actionWithAction:move];
    CCActionInterval *ease = [CCEaseOut actionWithAction:move rate:2.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(blowActionDone)];
    [self runAction:[CCSequence actions:ease, done, nil]];
}

- (void) blowActionDone
{
    [self floatAction];
}

@end
