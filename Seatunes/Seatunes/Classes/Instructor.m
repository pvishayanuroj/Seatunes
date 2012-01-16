//
//  Instructor.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Instructor.h"
#import "Utility.h"
#import "GameLayer.h"
#import "AudioManager.h"

@implementation Instructor

+ (id) instructor:(InstructorType)instructorType
{
    return [[[self alloc] initInstructor:instructorType] autorelease];
}

- (id) initInstructor:(InstructorType)instructorType
{
    if ((self = [super init])) {
        
        clickable_ = YES;
        
        switch (instructorType) {
            case kWhaleInstructor:
                instrumentType_ = kLowStrings;
                break;       
            default:
                instrumentType_ = kPiano;
                break;
        }
        
        name_ = [[NSString stringWithFormat:@"%@", [Utility instructorNameFromEnum:instructorType]] retain];
        NSString *spriteFrameName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
        [self addChild:sprite_];
        
        [self initAnimations];
    }
    return self;
}

- (void) dealloc
{
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (void) initAnimations
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Idle", name_];    
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	idleAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
    
    animationName = [NSString stringWithFormat:@"%@ Sing", name_];
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    singingAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
    
    animationName = [NSString stringWithFormat:@"%@ Wrong", name_];
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
    wrongAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
}

- (void) showIdle
{
    [sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];
}

- (void) showSing
{
    [sprite_ stopAllActions];
	[sprite_ runAction:singingAnimation_];    
}

- (void) playNote:(KeyType)keyType
{
    [self showSing];
    GameLayer *gameLayer = (GameLayer *)self.parent;
    [gameLayer addNote:keyType];
    [[AudioManager audioManager] playSound:keyType instrument:instrumentType_];
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

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (clickable_ && [self containsTouchLocation:touch]) {
        [self playNote:kC4];
        return YES;
    }
    return NO;
}

@end
