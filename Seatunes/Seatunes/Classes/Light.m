//
//  Light.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Light.h"
#import "Note.h"
#import "Utility.h"

@implementation Light

static const CGFloat LT_SPOTLIGHT_X = -200;
static const CGFloat LT_SPOTLIGHT_Y = 50;
static const CGFloat LT_SPOTLIGHT_SCALE = 0.7f;

static const CGFloat LT_BOUNDARY_OFFSET_X = -100.0f;
static const CGFloat LT_BOUNDARY_OFFSET_Y = 50.0f;
static const CGFloat LT_LOWERLEFT_X = -200.0f;
static const CGFloat LT_LOWERLEFT_Y = -50.0f;
static const CGFloat LT_LOWERRIGHT_X = 0.0f;
static const CGFloat LT_LOWERRIGHT_Y = -20.0f;
static const CGFloat LT_UPPERLEFT_X = -200.0f;
static const CGFloat LT_UPPERLEFT_Y = 50.0f;
static const CGFloat LT_UPPERRIGHT_X = 0.0f;
static const CGFloat LT_UPPERRIGHT_Y = 20.0f;

+ (id) light
{
    return [[[self alloc] initLight] autorelease];
}

- (id) initLight
{
    if ((self = [super init])) {
        
        fish_ = [[CCSprite spriteWithFile:@"Angler Fish.png"] retain];
        [self addChild:fish_ z:-1];
        spotlight_ = [[CCSprite spriteWithFile:@"Spotlight.png"] retain];
        spotlight_.scale = LT_SPOTLIGHT_SCALE;
        spotlight_.position = ccp(LT_SPOTLIGHT_X, LT_SPOTLIGHT_Y);
        spotlight_.visible = NO;
        [self addChild:spotlight_ z:-1];        
        
        CGPoint lowerLeft = ccp(LT_LOWERLEFT_X, LT_LOWERLEFT_Y);
        CGPoint lowerRight = ccp(LT_LOWERRIGHT_X, LT_LOWERRIGHT_Y);      
        CGPoint upperLeft = ccp(LT_UPPERLEFT_X, LT_UPPERLEFT_Y);
        CGPoint upperRight = ccp(LT_UPPERRIGHT_X, LT_UPPERRIGHT_Y); 
        lowerBoundSlope_ = [Utility getSlope:lowerLeft b:lowerRight];
        upperBoundSlope_ = [Utility getSlope:upperLeft b:upperRight];        
    }
    return self;
}

- (void) dealloc
{
    [fish_ release];
    [spotlight_ release];    
    
    [super dealloc];
}

- (BOOL) isLightOn
{
    return spotlight_.visible;
}

- (void) turnOn:(KeyType)key
{
    spotlight_.visible = YES;
}

- (void) turnOff
{
    spotlight_.visible = NO;
}

- (BOOL) noteIntersectLight:(Note *)note
{
    CGFloat leftBoundary = LT_LOWERLEFT_X + LT_BOUNDARY_OFFSET_X + self.position.x;
    CGFloat rightBoundary = LT_LOWERRIGHT_X + LT_BOUNDARY_OFFSET_X + self.position.x;    
    
    if (note.position.x > leftBoundary && note.position.x < rightBoundary) {
        CGFloat yLower = [self yLowerBoundaryForPos:note.position];
        CGFloat yUpper = [self yUpperBoundaryForPos:note.position];
        return (note.position.y + note.radius) > yLower && (note.position.y - note.radius) < yUpper;
    }
    
    return NO;
}

- (BOOL) noteWithinLight:(Note *)note
{
    CGFloat leftBoundary = LT_LOWERLEFT_X + LT_BOUNDARY_OFFSET_X + self.position.x;
    CGFloat rightBoundary = LT_LOWERRIGHT_X + LT_BOUNDARY_OFFSET_X + self.position.x;    
    
    if (note.position.x > leftBoundary && note.position.x < rightBoundary) {
        CGFloat yLower = [self yLowerBoundaryForPos:note.position];
        CGFloat yUpper = [self yUpperBoundaryForPos:note.position];
        return (note.position.y - note.radius) > yLower && (note.position.y + note.radius) < yUpper;
    }
    
    return NO;    
}

- (CGFloat) yLowerBoundaryForPos:(CGPoint)pos
{
    CGPoint anchor = ccp(LT_LOWERLEFT_X, LT_LOWERLEFT_Y);
    anchor = ccpAdd(ccp(LT_BOUNDARY_OFFSET_X, LT_BOUNDARY_OFFSET_Y), anchor);
    anchor = ccpAdd(self.position, anchor);
    
    CGFloat y = (pos.x - anchor.x) * lowerBoundSlope_ + anchor.y;
    return y;
}

- (CGFloat) yUpperBoundaryForPos:(CGPoint)pos
{
    CGPoint anchor = ccp(LT_UPPERLEFT_X, LT_UPPERLEFT_Y);
    anchor = ccpAdd(ccp(LT_BOUNDARY_OFFSET_X, LT_BOUNDARY_OFFSET_Y), anchor);
    anchor = ccpAdd(self.position, anchor);
    
    CGFloat y = (pos.x - anchor.x) * lowerBoundSlope_ + anchor.y;
    return y;
}

#if DEBUG_SHOWLIGHTBOUNDARY
- (void) draw
{
    // top left
    CGPoint p1 = ccp(LT_UPPERLEFT_X, LT_UPPERLEFT_Y);
    // top right
    CGPoint p2 = ccp(LT_UPPERRIGHT_X, LT_UPPERRIGHT_Y);
    // bottom left
    CGPoint p3 = ccp(LT_LOWERLEFT_X, LT_LOWERLEFT_Y);
    // bottom right
    CGPoint p4 = ccp(LT_LOWERRIGHT_X, LT_LOWERRIGHT_Y);
    
    CGPoint offset = ccp(LT_BOUNDARY_OFFSET_X, LT_BOUNDARY_OFFSET_Y);
    p1 = ccpAdd(p1, offset);
    p2 = ccpAdd(p2, offset);
    p3 = ccpAdd(p3, offset);
    p4 = ccpAdd(p4, offset);    
    
    glColor4f(1.0, 0, 0, 1.0);            
    ccDrawLine(p1, p2);
    ccDrawLine(p3, p4);    
    ccDrawLine(p2, p4);
    ccDrawLine(p1, p3);       
}
#endif

@end
