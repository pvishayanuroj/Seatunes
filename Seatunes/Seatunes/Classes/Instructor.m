//
//  Instructor.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Instructor.h"
#import "Utility.h"
#import "AudioManager.h"
#import "Note.h"

@implementation Instructor

#pragma mark - Object Lifecycle

+ (id) instructor:(InstructorType)instructorType
{
    return [[[self alloc] initInstructor:instructorType] autorelease];
}

- (id) initInstructor:(InstructorType)instructorType
{
    if ((self = [super init])) {
        
        clickable_ = NO;
        
        switch (instructorType) {
            case kWhaleInstructor:
                instrumentType_ = kLowStrings;
                break;       
            default:
                instrumentType_ = kPiano;
                break;
        }
        
        // Setup the sprite
        name_ = [[NSString stringWithFormat:@"%@", [Utility instructorNameFromEnum:instructorType]] retain];
        NSString *spriteFrameName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain];
        [self addChild:sprite_ z:-1];
        
        [self initAnimations];
        [self runBobbingAction];
    }
    return self;
}

- (void) dealloc
{
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    [singingAnimation_ release];
    [wrongAnimation_ release];
    
    [super dealloc];
}

#pragma mark - Helper Methods

- (void) runBobbingAction
{
    // create move actions for the button
    CCMoveBy *moveUp = [CCMoveBy actionWithDuration:1.5f position:ccp(0, 10)];
    CCEaseOut *easeUp = [CCEaseIn actionWithAction:moveUp rate:1.5f];
    CCMoveBy *moveDown = [CCMoveBy actionWithDuration:1.25f position:ccp(0, -10)];
    CCSequence *moveUpDown = [CCSequence actions:easeUp, moveDown, nil];
    CCRepeatForever *repeatMove = [CCRepeatForever actionWithAction:moveUpDown];
    
    // run the action so the button moves up and down forever.
    [self runAction:repeatMove];    
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

- (void) showTalk
{
    [sprite_ stopAllActions];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5f];
    CCActionInterval *talk = [CCRepeat actionWithAction:(CCFiniteTimeAction *)idleAnimation_ times:3];
    CCActionInterval *action = [CCSequence actions:talk, delay, nil];
    [sprite_ runAction:[CCRepeatForever actionWithAction:action]];
}

- (void) showIdle
{
    [sprite_ stopAllActions];
    
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    [sprite_ runAction:[CCSequence actions:(CCFiniteTimeAction *)idleAnimation_, done, nil]];
}

- (void) showWrongNote
{
    [sprite_ stopAllActions];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
                            
    [sprite_ runAction:[CCSequence actions:(CCFiniteTimeAction *)wrongAnimation_, done, nil]];
}

- (void) showSing
{
    [sprite_ stopAllActions];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(resetIdleFrame)];
    
    [sprite_ runAction:[CCSequence actions:(CCFiniteTimeAction *)singingAnimation_, done, nil]];    
}

- (void) resetIdleFrame
{
    [sprite_ stopAllActions];
    
    NSString *spriteFrameName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];
    [sprite_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]];
}

#pragma mark - Touch Methods

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
        //NSInteger note = arc4random() % 8;
        //[self playNote:note];
        return YES;
    }
    return NO;
}

@end
