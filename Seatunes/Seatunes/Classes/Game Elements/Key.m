//
//  Key.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Key.h"
#import "Utility.h"

@implementation Key

static const CGFloat KEY_SCALE = 1.0f;

@synthesize delegate = delegate_;
@synthesize keyType = keyType_;
@synthesize soundID = soundID_;
@synthesize isSelected = isSelected_;

+ (id) key:(KeyType)keyType creature:(CreatureType)creature
{
    return [[[self alloc] initKey:keyType creature:creature] autorelease];
}

- (id) initKey:(KeyType)keyType creature:(CreatureType)creature
{
    if ((self = [super init])) {
        
        keyType_ = keyType;
        isClickable_ = YES;
        isSelected_ = NO;
        
        NSString *keyName = [Utility keyNameFromEnum:keyType];
        NSString *creatureName = [[Utility creatureNameFromEnum:creature] retain];
        
        fullName_ = [[NSString stringWithFormat:@"%@ %@", creatureName, keyName] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ %@.png", creatureName, keyName];
        NSString *selectedName = [NSString stringWithFormat:@"%@ %@ Selected.png", creatureName, keyName];
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        selected_ = [[CCSprite spriteWithSpriteFrameName:selectedName] retain];
        //disabled_ = [[CCSprite spriteWithSpriteFrameName:disabledName] retain];     
        
        sprite_.visible = YES;
        selected_.visible = NO;
        sprite_.scale = KEY_SCALE;
        selected_.scale = KEY_SCALE;
        
        [self addChild:sprite_];
        [self addChild:selected_];
        
        [self initAnimations];
        [self scheduleBlink];
    }
    return self;
}

- (void) dealloc
{
    [fullName_ release];
    [blinkAnimation_ release];
    [sprite_ release];
    [selected_ release];
    //[disabled_ release];
    
    [super dealloc];
}

- (void) initAnimations
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Blink", fullName_];    
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	blinkAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
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

- (void) showBlink
{
    [sprite_ stopAllActions];
    CCActionInstant *done = [CCCallBlock actionWithBlock:^{
        [self resetIdleFrame];
        [self scheduleBlink];
    }];
    
    [sprite_ runAction:[CCSequence actions:(CCFiniteTimeAction *)blinkAnimation_, done, nil]];
}

- (void) scheduleBlink
{
    CGFloat delayTime = [Utility randomIncl:5000 b:30000] * 0.001f;
    CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    CCActionInstant *blink = [CCCallBlock actionWithBlock:^{
        [self showBlink];
    }];
    
    [self runAction:[CCSequence actions:delay, blink, nil]];
}

- (void) resetIdleFrame
{
    [sprite_ stopAllActions];
    
    NSString *spriteFrameName = [NSString stringWithFormat:@"%@.png", fullName_];
    [sprite_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteFrameName]];
}

- (void) selectButton
{
    isSelected_ = YES;
    
    sprite_.visible = NO;
    selected_.visible = YES;
    
    soundID_ = [delegate_ keyPressed:self];    
}

- (void) unselectButton
{
    isSelected_ = NO;
    
    selected_.visible = NO;
    sprite_.visible = YES;
    
    [delegate_ keyDepressed:self];
}

- (void) disableButton
{
    
}

- (void) selectButtonTimed:(CGFloat)time
{
    [self selectButton];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:time];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(unselectButton)];
    
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

@end