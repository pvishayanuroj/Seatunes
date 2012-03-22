//
//  StaffNote.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "StaffNote.h"


@implementation StaffNote

@synthesize numID = numID_;
@synthesize delegate = delegate_;

static const CGFloat SN_LOWC_YOFFSET = -20.0f;
static const CGFloat SN_LINE_YOFFSET = -22.0f;
static const CGFloat SN_REST_YOFFSET = 0.0f;
static const CGFloat SN_NOTE_PADDING = 7.5f;
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
        
        delegate_ = nil;
        line_ = nil;
        numID_ = numID;        
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
            [self curvedMove];
            
            sprite_.scale = 0.5f;
[self scaleUp];            
            //[self bounce];
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
             
- (void) scaleUp
{

    
    id scale = [CCScaleTo actionWithDuration:2.0f scale:1.0f];
    [sprite_ runAction:scale];   
}

- (void) curvedMove
{
    CGPoint start = ccp(0, 0);
    CGPoint c1 = ccp(start.x + 300, start.y - 125);
    CGPoint c2 = ccp(start.x + 450, start.y + 125);
    CGPoint end = ccp(start.x + 450, start.y + 300);    
    
    ccBezierConfig b;
    b.controlPoint_1 = c1;
    b.controlPoint_2 = c2;
    b.endPosition = end;
    
    CCActionInterval *move = [CCBezierBy actionWithDuration:5.0 bezier:b];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(move)];
    [self runAction:[CCSequence actions:move, done, nil]];
}
- (void) move
{
    CCActionInterval *move = [CCMoveBy actionWithDuration:2.5f position:ccp(SN_MOVE_X * 0.4f, 0)];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(move2)];
    [self runAction:[CCSequence actions:move, done, nil]];
    //CCActionInterval *ease = [CCEaseIn actionWithAction:move rate:1.0f];
    //[self runAction:ease];
}

- (void) move2
{
    CCActionInterval *move = [CCMoveBy actionWithDuration:3.5f position:ccp(SN_MOVE_X * 0.6f, 0)];    
    [self runAction:move];
}

- (void) appear
{
    CCActionInterval *fadeIn = [CCFadeIn actionWithDuration:0.5f];
    [sprite_ runAction:fadeIn];
    
    if (line_) {
        CCActionInterval *lineFadeIn = [CCFadeIn actionWithDuration:0.5f];
        [line_ runAction:lineFadeIn];        
    }
}

- (void) staffNoteDestroy
{
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:0.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [sprite_ runAction:[CCSequence actions:fadeOut, done, nil]];
    
    if (line_) {
        CCActionInterval *lineFadeOut = [CCFadeOut actionWithDuration:0.5f];        
        [line_ runAction:lineFadeOut];
    }    
}

- (void) curvedDestroy
{
    [self stopAllActions];
 
    id jump = [CCJumpBy actionWithDuration:0.45f position:ccp(0, 25) height:100 jumps:1];
    id ease = [CCEaseOut actionWithAction:jump rate:1.0f];    
    id done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    
    [self runAction:[CCSequence actions:ease, done, nil]];    
    
    
    /*
    ccBezierConfig b;
    b.controlPoint_1 = ccp(-60, 100);
    b.controlPoint_2 = ccp(-120, 120);
    b.endPosition = ccp(-700, -250);  
    
    id curve = [CCBezierBy actionWithDuration:0.6f bezier:b];
    id ease = [CCEaseOut actionWithAction:curve rate:1.5f];
    id done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    
    [self runAction:[CCSequence actions:ease, done, nil]];
     */
}

- (void) jumpDestroy
{
    
}

- (void) jump
{
    
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (void) staffNoteReturn
{
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:0.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(notifyStaffNoteReturn)];
    
    [sprite_ runAction:[CCSequence actions:fadeOut, done, nil]];
    
    if (line_) {
        CCActionInterval *lineFadeOut = [CCFadeOut actionWithDuration:0.5f];        
        [line_ runAction:lineFadeOut];
    }
}

- (void) notifyStaffNoteReturn
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(staffNoteReturned:)]) {
        [delegate_ staffNoteReturned:self];
    }
    
    [self removeFromParentAndCleanup:YES];
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
