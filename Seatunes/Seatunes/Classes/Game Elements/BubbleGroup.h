//
//  BubbleGroup.h
//  Little Ocean
//
//  Created by Jamorn Ho on 1/16/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "Rock.h"

//@interface BubbleGroup : CCNode <RockDelegate> {
@interface BubbleGroup : CCNode {
    
    CGFloat bubblesChance_;
    
    CGFloat timeTillNextBubble_;
    
    float masterScale_;
    
    BOOL bubbleSoundPlaying_;
    
    int bubbleSoundEffect_;
}

@property (nonatomic) BOOL isEnabled;

+ (id) bubbleGroupWithBubbles:(CGFloat)bubblesChance;

- (id) initWithBubbles:(CGFloat)bubblesChance;

- (void) bubbleExplosionStart;

- (void) bubbleExplosionStop;

- (void) playBubbleSound;

- (void) stopBubbleSound;

@end
