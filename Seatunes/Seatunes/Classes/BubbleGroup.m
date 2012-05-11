//
//  BubbleGroup.m
//  Little Ocean
//
//  Created by Jamorn Ho on 1/16/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import "BubbleGroup.h"
#import "AudioManager.h"
#import "Bubble.h"

@interface BubbleGroup (Private)

- (void) update:(ccTime)dt;
- (void) explode:(ccTime)dt;
- (void) addBubble:(NSInteger)radius;
@end


@implementation BubbleGroup

+ (id) bubbleGroupWithBubbles:(CGFloat)bubblesChance
{
    BubbleGroup *group = [[[BubbleGroup alloc] initWithBubbles:bubblesChance] autorelease];
    return group;
}

- (id) initWithBubbles:(CGFloat)bubblesChance
{
    if ((self = [super init])) {
        
        masterScale_ = 1.0f;
        
        bubblesChance_ = bubblesChance;
        
        [self schedule:@selector(update:) interval:1.0f/30.0f];
    }
    return self;
}

- (void) setScale:(float)scale
{
    [super setScale:scale];
    masterScale_ = scale;
}



- (void) update:(ccTime)dt
{
    if (timeTillNextBubble_ <= 0.0f) {
        
//        CGFloat ms = (float)(arc4random() % 100) / 100.0f;
        
        
        timeTillNextBubble_ = 1.5f * (float)(arc4random() % 8000) / 8000.0f * (1.0f - bubblesChance_);
        
        //NSLog(@"%4.2f", timeTillNextBubble_);
        
        [self addBubble:30];
    }
    else {
        timeTillNextBubble_ -= dt;
    }
}

- (void) explode:(ccTime)dt
{
    for (int i=0; i < 2; i++) {
        [self addBubble:70];
    }
}

- (void) addBubble:(NSInteger)radius
{
    Bubble *bubble = [Bubble bubbleWithTouchPriority:1];
    CGFloat minScale = 0.2f;
    CGFloat maxScale = 0.5f;
    bubble.scale = (minScale + (maxScale * (float)(arc4random() % 10 + 1) / 10.0f)) * masterScale_;
    int randX = arc4random() % (2*radius) + 1;
    bubble.position = ccp(-radius + randX, 0);
    
    [self addChild:bubble];
}

- (void) bubbleExplosionStart
{
    [self schedule:@selector(explode:) interval:1.0f/60.0f];
    bubbleSoundPlaying_ = YES;
    [self playBubbleSound];
}

- (void) bubbleExplosionStop
{
    [self unschedule:@selector(explode:)];
    [self stopBubbleSound];
    //[self performSelector:@selector(stopBubbleSound) withObject:nil afterDelay:5.0f / masterScale_];
    bubbleSoundPlaying_ = NO;
}

- (void) playBubbleSound
{
    if (bubbleSoundPlaying_) {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CGFloat pan = -1.0f + (2.0f * (float)self.position.x / (float)size.width);
        
        //bubbleSoundEffect_ = [[AudioManager audioManager] playSoundEffect:@"bubbles.mp3" pitch:0.2f + (0.5f* masterScale_) pan:pan gain:0.6f * masterScale_];
        
        [self performSelector:@selector(playBubbleSound) withObject:nil afterDelay:10.5f];
    }
}

- (void) stopBubbleSound
{
    //[[AudioManager audioManager] stopSoundEffect:bubbleSoundEffect_];
}

- (void) setIsEnabled:(BOOL)isEnabled
{
    for (Bubble *bubble in children_) {
        bubble.isClickable = isEnabled;
    }
}

- (BOOL) isEnabled
{
    return [[children_ objectAtIndex:0] isEnabled];
}

/*
#pragma mark Rock Delegate Methods
- (void) rockTouchBeganWithRock:(Rock *)rock
{
    [self bubbleExplosionStart];
}

- (void) rockTouchEndedWithRock:(Rock *)rock
{
    [self bubbleExplosionStop];
}
*/
 
@end
