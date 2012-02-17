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

@synthesize delegate = delegate_;

static const CGFloat IN_NOTE_X = 153.0f;
static const CGFloat IN_NOTE_Y = -60.0f;

#pragma mark - Object Lifecycle

+ (id) instructor:(InstructorType)instructorType
{
    return [[[self alloc] initInstructor:instructorType] autorelease];
}

- (id) initInstructor:(InstructorType)instructorType
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        clickable_ = YES;
        curveCounter_ = 0;
        notes_ = [[NSMutableArray arrayWithCapacity:10] retain];
        
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
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

#pragma mark - Helper Methods

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
    NSString *spriteFrameName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];
    [sprite_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]];
}

- (void) playNote:(KeyType)keyType
{
    if (keyType != kBlankNote) {
        [self showSing];
        [self addNote:keyType];
    }
}

- (void) addNote:(KeyType)keyType
{
    BubbleCurveType curveType = curveCounter_++ % 2 ? kBubbleCurve1 : kBubbleCurve2;
    Note *note = [Note note:keyType curveType:curveType];
    note.delegate = self;
    note.position = ccp(IN_NOTE_X, IN_NOTE_Y);
    [notes_ addObject:note];
    [self addChild:note z:-2];    
}

- (void) popOldestNote
{
    if ([notes_ count] > 0) {   
        [[notes_ objectAtIndex:0] destroy];
        [notes_ removeObjectAtIndex:0];
    }
}

#pragma mark - Delegate Methods

- (void) noteCrossedBoundary:(Note *)note
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(noteCrossedBoundary:)]) {
        [delegate_ noteCrossedBoundary:note];
    }
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
        [self playNote:kC4];
        return YES;
    }
    return NO;
}

- (void) draw
{
#if DEBUG_SHOWMAPCURVES
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
    
    CGPoint start = ccp(IN_NOTE_X, IN_NOTE_Y);
    CGPoint c1 = ccp(IN_NOTE_X + NT_CURVE1_C1_X, IN_NOTE_Y + NT_CURVE1_C1_Y);
    CGPoint c2 = ccp(IN_NOTE_X + NT_CURVE1_C2_X, IN_NOTE_Y + NT_CURVE1_C2_Y);
    CGPoint end = ccp(IN_NOTE_X + NT_CURVE1_END_X, IN_NOTE_Y + NT_CURVE1_END_Y);
    
    ccDrawCircle(start, 3, 360, 64, NO);
    ccDrawCircle(c1, 3, 360, 64, NO);        
    ccDrawCircle(c2, 3, 360, 64, NO);
    ccDrawCubicBezier(start, c1, c2, end, 128);
    
    CGPoint c11 = ccp(IN_NOTE_X + NT_CURVE2_C1_X, IN_NOTE_Y + NT_CURVE2_C1_Y);
    CGPoint c21 = ccp(IN_NOTE_X + NT_CURVE2_C2_X, IN_NOTE_Y + NT_CURVE2_C2_Y);
    CGPoint end1 = ccp(IN_NOTE_X + NT_CURVE2_END_X, IN_NOTE_Y + NT_CURVE2_END_Y);
    
    ccDrawCircle(start, 3, 360, 64, NO);
    ccDrawCircle(c11, 3, 360, 64, NO);        
    ccDrawCircle(c21, 3, 360, 64, NO);
    ccDrawCubicBezier(start, c11, c21, end1, 128);    
#endif
}

@end
