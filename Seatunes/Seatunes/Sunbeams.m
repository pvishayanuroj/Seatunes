//
//  Sunbeams.m
//  Seatunes
//
//  Created by Patrick Vishayanuroj on 5/11/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Sunbeams.h"
#import "Sunbeam.h"
#import "Utility.h"

@implementation Sunbeams

static const CGFloat SB_POS0_X = 150.0f;
static const CGFloat SB_POS0_Y = 670.0f;
static const CGFloat SB_POS1_X = 250.0f;
static const CGFloat SB_POS1_Y = 600.0f;
static const CGFloat SB_POS2_X = 470.0f; 
static const CGFloat SB_POS2_Y = 700.0f;
static const CGFloat SB_POS3_X = 540.0f;
static const CGFloat SB_POS3_Y = 650.0f;
static const CGFloat SB_POS4_X = 740.0f;
static const CGFloat SB_POS4_Y = 650.0f;
static const CGFloat SB_POS5_X = 910.0f;
static const CGFloat SB_POS5_Y = 650.0f;

static const CGFloat SB_POS_X[NUM_SUNBEAMS] = {SB_POS0_X, SB_POS1_X, SB_POS2_X, SB_POS3_X, SB_POS4_X, SB_POS5_X};
static const CGFloat SB_POS_Y[NUM_SUNBEAMS] = {SB_POS0_Y, SB_POS1_Y, SB_POS2_Y, SB_POS3_Y, SB_POS4_Y, SB_POS5_Y};

static const CGFloat SB_FADE_IN_DURATION = 0.35f;
static const CGFloat SB_FADE_OUT_DURATION = 0.35f;

+ (id) sunbeamsCycling:(NSUInteger)numbeams 
{
    return [[[self alloc] initSunbeams:numbeams showAll:NO] autorelease];
}

+ (id) sunbeamsRandom:(NSUInteger)numbeams
{
    return [[[self alloc] initRandomSunbeams:numbeams] autorelease];
}

+ (id) sunbeamsStatic:(NSUInteger)numbeams
{
    return [[[self alloc] initSunbeams:numbeams showAll:YES] autorelease];
}

- (id) initSunbeams:(NSUInteger)numbeams showAll:(BOOL)showAll
{
    if ((self = [super init])) {
        
        numbeams_ = numbeams;
        sprites_ = [[NSMutableArray arrayWithCapacity:numbeams] retain];
        
        for (NSUInteger i = 0; i < numbeams; ++i) {
            
            NSString *spriteName = [NSString stringWithFormat:@"Sunbeam %d.png", i];
            CCSprite *sprite = [CCSprite spriteWithFile:spriteName];
            sprite.position = ccp(SB_POS_X[i], SB_POS_Y[i]);
            [self addChild:sprite];
            
            [sprites_ addObject:sprite];
        }   
        
        if (!showAll) {
            for (CCSprite *sprite in sprites_) {
                sprite.opacity = 0;
            }
            [self scheduleCycle];
        }
    }
    
    return self;
}

- (id) initRandomSunbeams:(NSUInteger)numbeams
{
    if ((self = [super init])) {
        
        sprites_ = [[NSMutableArray array] retain];
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:numbeams*2];

        NSMutableArray *indices = [NSMutableArray arrayWithCapacity:numbeams];
        for (NSInteger i = 0; i < numbeams; ++i) {
            [indices addObject:[NSNumber numberWithInteger:i]];
        }
        
        [Utility shuffleArray:indices];
        
        for (NSNumber *number in indices) {
            CCActionInstant *add = [CCCallBlock actionWithBlock:^{
                NSInteger i = [number integerValue];
                NSString *spriteName = [NSString stringWithFormat:@"Sunbeam %d.png", i];
                Sunbeam *sunbeam = [Sunbeam sunbeam:spriteName period:0.5f];
                sunbeam.position = ccp(SB_POS_X[i], SB_POS_Y[i]);
                [self addChild:sunbeam];
            }];
            
            CGFloat time = [Utility randomIncl:500 b:2500] * 0.001f;
            //NSLog(@"%d, %4.2f", [number integerValue], time);
            CCActionInterval *delay = [CCDelayTime actionWithDuration:time];
            [actions addObject:add];
            [actions addObject:delay];            
        }        
        
        [self runAction:[CCSequence actionsWithArray:actions]];
    }
    return self;
}

- (void) dealloc
{
    [sprites_ release];
    
    [super dealloc];
}

- (void) scheduleCycle
{
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:numbeams_ * 2];
    
    for (NSUInteger i = 0; i < numbeams_; ++i) {
        
        CGFloat delayTime = 1.0f;
        CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
        
        CCActionInstant *set = [CCCallBlock actionWithBlock:^{
            CCSprite *sprite = [sprites_ objectAtIndex:i]; 
//            sprite.visible = !sprite.visible;
//            NSLog(@"set %@, %d, vis: %d", sprite, i, sprite.visible);            
  
            CCActionInterval *fade;
            if (sprite.opacity == 0) {
                fade = [CCFadeIn actionWithDuration:SB_FADE_IN_DURATION];
            }
            else {
                fade = [CCFadeOut actionWithDuration:SB_FADE_OUT_DURATION];
            }
            [sprite runAction:fade];
        }];

        [actions addObject:delay];
        [actions addObject:set];
    }
    
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(done)];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];
}

- (void) done
{
    [self scheduleCycle];
}

@end
