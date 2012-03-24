//
//  StaffNote.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "StaffNote.h"


@implementation StaffNote

@synthesize state = state_;
@synthesize numID = numID_;

static const CGFloat SN_NOTE_PADDING = 12.65f;
static const CGFloat SN_NOTE_OFFSET_Y = 23.0f;
static const CGFloat SN_NOTE_FLIPPED_OFFSET_Y = 75.0f;
static const CGFloat SN_MOVE_X = -800.0f;

+ (id) staticStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID
{
    return [[[self alloc] initStaffNote:keyType pos:pos numID:numID isStatic:YES] autorelease];
}

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID
{
    return [[[self alloc] initStaffNote:keyType pos:pos numID:numID isStatic:NO] autorelease];
}

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos numID:(NSUInteger)numID isStatic:(BOOL)isStatic
{
    if ((self = [super init])) {
        
        keyType_ = keyType;
        line_ = nil;
        numID_ = numID;     
        state_ = kStaffNoteStart;
        self.position = pos;
        
        if (keyType == kC4) {
            sprite_ = [[CCSprite spriteWithFile:@"C Note.png"] retain];
        }
        else if (keyType < kB4) {
            sprite_ = [[CCSprite spriteWithFile:@"Note.png"] retain];
        }
        else {
            sprite_ = [[CCSprite spriteWithFile:@"Flipped Note.png"] retain];
        } 
        
        [self addChild:sprite_];
        
        if (!isStatic) {
            [self runPlaySequence];         
        }
        else {

        }
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [line_ release];
    
    [super dealloc];
}
             
- (void) runPlaySequence
{
    [self curvedMove];
    sprite_.scale = 0.5f;
    [self scaleUp];      
}

- (void) scaleUp
{
    id scale = [CCScaleTo actionWithDuration:2.0f scale:1.0f];
    [sprite_ runAction:scale];   
}

- (void) curvedMove
{
    CGPoint start = ccp(0, 0);
    CGPoint c1 = ccp(start.x + 275, start.y - 125);
    CGPoint c2 = ccp(start.x + 430, start.y + 125);
    CGPoint end = ccp(start.x + 430, start.y + 275);
    end.y += [self calculateNoteY:keyType_];
    
    ccBezierConfig b;
    b.controlPoint_1 = c1;
    b.controlPoint_2 = c2;
    b.endPosition = end;
    
    CCActionInterval *move = [CCBezierBy actionWithDuration:5.0 bezier:b];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(moveAcross)];
    [self runAction:[CCSequence actions:move, done, nil]];
}
- (void) moveAcross
{
    state_ = kStaffNoteActive;
    CCActionInterval *move = [CCMoveBy actionWithDuration:6.0f position:ccp(SN_MOVE_X, 0)];
    [self runAction:move];
}

- (void) fadeDestroy
{
    state_ = kStaffNoteFade;
    
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:0.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [sprite_ runAction:[CCSequence actions:fadeOut, done, nil]];  
}

- (void) jumpDestroy
{
    [self stopAllActions];
 
    id jump = [CCJumpBy actionWithDuration:0.4f position:ccp(0, 25) height:100 jumps:1];
    id ease = [CCEaseOut actionWithAction:jump rate:1.25f];    
    id done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    
    [self runAction:[CCSequence actions:ease, done, nil]];    
    
    id delay = [CCDelayTime actionWithDuration:0.3f];
    id fade = [CCFadeOut actionWithDuration:0.1f];
    
    [sprite_ runAction:[CCSequence actions:delay, fade, nil]];
}

- (void) jump
{
    
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (CGFloat) calculateNoteY:(KeyType)key
{
    NSInteger idx = (NSInteger)key;
    CGFloat y = idx * SN_NOTE_PADDING - SN_NOTE_OFFSET_Y;
    if (idx > kA4) {
        y -= SN_NOTE_FLIPPED_OFFSET_Y;
    }
    return y;
}

#if !DEBUG_SHOWSTAFFCURVES
- (void) draw
{
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
     
    ccBezierConfig b;
    b.controlPoint_1 = ccp(-60, 100);
    b.controlPoint_2 = ccp(-120, 120);
    b.endPosition = ccp(-700, -250);    
    
    CGPoint start = CGPointZero;
    CGPoint c1 = ccpAdd(start, b.controlPoint_1);
    CGPoint c2 = ccpAdd(start, b.controlPoint_2);
    CGPoint end = ccpAdd(start, b.endPosition);
     
    ccDrawCircle(start, 3, 360, 64, NO);
    ccDrawCircle(c1, 3, 360, 64, NO);        
    ccDrawCircle(c2, 3, 360, 64, NO);
    ccDrawCircle(end, 3, 360, 64, NO);    
    ccDrawCubicBezier(start, c1, c2, end, 128);        
}
#endif

@end
