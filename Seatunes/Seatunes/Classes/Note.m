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

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (id) note:(KeyType)keyType curveType:(BubbleCurveType)curveType
{
    return [[[self alloc] initNote:keyType curveType:curveType] autorelease];
}

- (id) initNote:(KeyType)keyType curveType:(BubbleCurveType)curveType
{
    if ((self = [super init])) {
        
        delegate_ = nil;
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
    [sprite_ release];
    
    [super dealloc];
}

- (void) destroy
{
    [delegate_ noteDestroyed:self];
    [self stopAllActions];
    [self removeFromParentAndCleanup:YES];
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
        [delegate_ noteCrossedBoundary:self];
    }
    // Why doesn't this give the correct value??
    //CGPoint pt = [self convertToWorldSpace:self.position];

}

@end
