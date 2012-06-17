//
//  Sunbeam.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 5/12/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Sunbeam.h"
#import "Utility.h"

@implementation Sunbeam

+ (id) sunbeam:(NSString *)spriteName period:(CGFloat)period
{
    return [[[self alloc] initSunbeam:spriteName period:period] autorelease];
}

- (id) initSunbeam:(NSString *)spriteName period:(CGFloat)period
{
    if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:spriteName] retain];
        //sprite_.anchorPoint = CGPointZero;
        sprite_.opacity = 50;
        [self addChild:sprite_];
        
        [self scheduleCycle];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) scheduleCycle
{
    CGFloat r1 = [Utility randomIncl:10 b:200] * 0.01f;
    CGFloat r2 = [Utility randomIncl:200 b:400] * 0.01f;
    CGFloat r3 = [Utility randomIncl:10 b:200] * 0.01f;

    CGFloat f1 = [Utility randomIncl:40 b:60] * 0.01f;
    CGFloat f2 = [Utility randomIncl:40 b:60] * 0.01f;    
    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:r1];        
    CCActionInterval *fadeIn = [CCFadeTo actionWithDuration:f1 opacity:255];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:r2];
    CCActionInterval *fadeOut = [CCFadeTo actionWithDuration:f2 opacity:50];
    CCActionInterval *delay3 = [CCDelayTime actionWithDuration:r3]; 
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(done)];    
    
    CCAction *seq = [CCSequence actions:delay1, fadeIn, delay2, fadeOut, delay3, done, nil];
    [sprite_ runAction:seq];
    
    /*
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:5];
    
    CGFloat delayTime = 1.0f;
    CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    
    CCActionInstant *set = [CCCallBlock actionWithBlock:^{   
        
        CCActionInterval *delay1 = [CCDelayTime actionWithDuration:1.0f];        
        CCActionInterval *fadeIn = [CCFadeTo actionWithDuration:0.5f opacity:225];
        CCActionInterval *delay2 = [CCDelayTime actionWithDuration:1.0f];
        CCActionInterval *fadeOut = [CCFadeTo actionWithDuration:0.5f opacity:50];
        CCActionInterval *delay3 = [CCDelayTime actionWithDuration:1.0f];        
        
        
    }];
    
    [actions addObject:delay];
    [actions addObject:set];
    
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(done)];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];
     */
}

- (void) done
{
    [self scheduleCycle];
}

@end
