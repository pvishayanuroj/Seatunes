//
//  StarfishButton.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "StarfishButton.h"


@implementation StarfishButton

static const CGFloat SB_LABEL_X = 75.0f;

#pragma mark - Object Lifecycle

+ (id) starfishButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initStarfishButton:numID text:text image:@"Starfish Button.png" fnt:@"MenuFont.fnt" textScale:CHOOSE_REL_CCP(1.0f, 1.15f)] autorelease];
}

+ (id) starfishButtonUnselected:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initStarfishButton:numID text:text image:@"Starfish Button Unselected.png" fnt:@"MenuFontDisabled.fnt" textScale:CHOOSE_REL_CCP(1.0f, 1.15f)] autorelease];
}

+ (id) starfishButtonBlue:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initStarfishButton:numID text:text image:@"Blue Starfish Button.png" fnt:@"MenuFont.fnt" textScale:CHOOSE_REL_CCP(1.2f, 1.3f)] autorelease];    
}

- (id) initStarfishButton:(NSUInteger)numID text:(NSString *)text image:(NSString *)image fnt:(NSString *)fnt textScale:(CGFloat)textScale
{
    if ((self = [super initButton:numID toggle:NO])) {
        
        isSpinning_ = NO;
        sprite_ = [[CCSprite spriteWithFile:image] retain];
        [self addChild:sprite_];
        
        label_ = [[CCLabelBMFont labelWithString:text fntFile:fnt] retain];
        label_.position = ADJUST_IPAD_CCP(ccp(SB_LABEL_X, 0));
        label_.anchorPoint = ccp(0, 0.5f);
        label_.scale = textScale;
        [self addChild:label_];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [label_ release];
    
    [super dealloc];
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (isClickable_) {    
        if ([self containsTouchLocation:touch]) {
            [self selectButton];            
            return YES;
        }
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch])	{
        [self selectButton];
    }
    else {
        [self unselectButton];       
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch])	{
        //[self startSpin];
        [self unselectButton]; 
        
        if ([delegate_ respondsToSelector:@selector(buttonClicked:)]) {
            [delegate_ buttonClicked:self];
        }            
    }
}

- (void) selectButton
{
    sprite_.scale = 1.1f;
    
    [super selectButton];
}

- (void) unselectButton
{
    sprite_.scale = 1.0f;
    
    [super unselectButton];    
}

- (void) startSpin
{
    [sprite_ stopAllActions];
    CCActionInterval *spin = [CCRotateBy actionWithDuration:0.5f angle:180.0f * 1];
    CCActionInstant *delay = [CCDelayTime actionWithDuration:0.25f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneSpin)];
    [sprite_ runAction:[CCSequence actions:spin, delay, done, nil]];
    
    /*
    CCEaseIn *ease = [CCEaseIn actionWithAction:spin rate:2.0f];
    [sprite_ runAction:ease];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneFastSpin)];
    [self runAction:[CCSequence actions:delay, done, nil]];
     */
}

- (void) doneSpin
{
    if ([delegate_ respondsToSelector:@selector(buttonClicked:)]) {
        [delegate_ buttonClicked:self];
    }    
}

@end
