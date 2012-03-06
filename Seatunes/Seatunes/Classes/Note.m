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

static const CGFloat NT_WOBBLE_DURATION = 0.35f;
static const CGFloat NT_FLATTEN_SCALE_X = 1.1f;
static const CGFloat NT_FLATTEN_SCALE_Y = 0.9f;
static const CGFloat NT_ELONGATE_SCALE_X = 0.9f;
static const CGFloat NT_ELONGATE_SCALE_Y = 1.1f;

@synthesize keyType = keyType_;
@synthesize numID = numID_;
@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (id) note:(KeyType)keyType curveType:(BubbleCurveType)curveType numID:(NSUInteger)numID
{
    return [[[self alloc] initNote:keyType curveType:curveType poppable:NO numID:numID] autorelease];
}

+ (id) note:(KeyType)keyType curveType:(BubbleCurveType)curveType poppable:(BOOL)poppable numID:(NSUInteger)numID
{
    return [[[self alloc] initNote:keyType curveType:curveType poppable:poppable numID:numID] autorelease];
}

- (id) initNote:(KeyType)keyType curveType:(BubbleCurveType)curveType poppable:(BOOL)poppable numID:(NSUInteger)numID
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        keyType_ = keyType;
        numID_ = numID;
        poppable_ = poppable;
        isClickable_ = NO;
        boundaryCrossFlag_ = NO;
        curveType_ = curveType;
        NSString *keyName = [Utility keyNameFromEnum:keyType];
        NSString *spriteFrameName = [NSString stringWithFormat:@"Bubble %@.png", keyName];
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteFrameName] retain]; 
        sprite_.scale = 0;
        [self addChild:sprite_];        
        
        [self schedule:@selector(loop)];
        
        [self blowAction];
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_SHOWDEALLOC
    NSLog(@"Note dealloc'd");
#endif
    
    [sprite_ release];

    [super dealloc];
}

- (void) destroy
{    
    [self scaleAction];
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
    CCSprite *sprite = [CCSprite spriteWithFile:@"Bubble Burst.png"];
    [self addChild:sprite];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(popActionDone)];        
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

- (void) popActionDone
{
    [delegate_ noteDestroyed:self];
    [self removeFromParentAndCleanup:YES];    
}

#pragma mark - Touch Handlers

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
    if (isClickable_) {
        return [self containsTouchLocation:touch];
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch]) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(noteTouched:)]) {
            [delegate_ noteTouched:self];
        }
    }
}

#pragma mark - Helper Methods

- (void) blowAction
{
    CCActionInterval *scale = [CCScaleTo actionWithDuration:1.0f scale:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(blowActionDone)];    
    [sprite_ runAction:[CCSequence actions:scale, done, nil]];    
}

- (void) blowActionDone
{
    if (poppable_) {
        isClickable_ = YES;
    }
    
    [self curveAction];
    [self wobbleAction];
}

- (void) wobbleAction
{
    CCScaleTo *flatten = [CCScaleTo actionWithDuration:NT_WOBBLE_DURATION scaleX:NT_FLATTEN_SCALE_X scaleY:NT_FLATTEN_SCALE_Y];
    CCScaleTo *elongate = [CCScaleTo actionWithDuration:NT_WOBBLE_DURATION scaleX:NT_ELONGATE_SCALE_X scaleY:NT_ELONGATE_SCALE_Y];
    CCSequence *wobble = [CCSequence actions:flatten, elongate, nil];
    [sprite_ runAction:[CCRepeatForever actionWithAction:wobble]];
}

- (void) curveAction
{
    ccBezierConfig bz;
    
    switch (curveType_) {
        case kBubbleCurve1:
            bz.endPosition = ccp(NT_CURVE1_END_X, NT_CURVE1_END_Y);
            bz.controlPoint_1 = ccp(NT_CURVE1_C1_X, NT_CURVE1_C1_Y);
            bz.controlPoint_2 = ccp(NT_CURVE1_C2_X, NT_CURVE1_C2_Y);            
            break;
        case kBubbleCurve2:
            bz.endPosition = ccp(NT_CURVE2_END_X, NT_CURVE2_END_Y);
            bz.controlPoint_1 = ccp(NT_CURVE2_C1_X, NT_CURVE2_C1_Y);
            bz.controlPoint_2 = ccp(NT_CURVE2_C2_X, NT_CURVE2_C2_Y);            
            break;
        case kBubbleCurve3:
            bz.endPosition = ccp(NT_CURVE3_END_X, NT_CURVE3_END_Y);
            bz.controlPoint_1 = ccp(NT_CURVE3_C1_X, NT_CURVE3_C1_Y);
            bz.controlPoint_2 = ccp(NT_CURVE3_C2_X, NT_CURVE3_C2_Y);                        
            break;
        default:
            break;
    }

    CCActionInterval *curve = [CCBezierBy actionWithDuration:4.0f bezier:bz];
    CCActionInterval *ease = [CCEaseOut actionWithAction:curve rate:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(curveActionDone)];
    [self runAction:[CCSequence actions:ease, done, nil]];
}

- (void) curveActionDone
{
    [self destroy];
}

- (void) loop
{
    CGFloat y = [self parent].position.y + self.position.y;
    
    if (!boundaryCrossFlag_ && y > [[CCDirector sharedDirector] winSize].height) {
        boundaryCrossFlag_ = YES;
        if (delegate_ && [delegate_ respondsToSelector:@selector(noteCrossedBoundary:)]) {
            [delegate_ noteCrossedBoundary:self];
        }
    }
    // Why doesn't this give the correct value??
    //CGPoint pt = [self convertToWorldSpace:self.position];
}

@end
