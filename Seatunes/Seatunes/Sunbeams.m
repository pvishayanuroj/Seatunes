//
//  Sunbeams.m
//  Seatunes
//
//  Created by Patrick Vishayanuroj on 5/11/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Sunbeams.h"

@implementation Sunbeams

static const CGFloat SB_FADE_IN_DURATION = 0.35f;
static const CGFloat SB_FADE_OUT_DURATION = 0.35f;

+ (id) sunbeamsCycling:(NSUInteger)numbeams 
{
    return [[[self alloc] initSunbeams:numbeams showAll:NO] autorelease];
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
            sprite.anchorPoint = CGPointZero;
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
