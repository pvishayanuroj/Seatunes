//
//  StarfishButton.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "StarfishButton.h"


@implementation StarfishButton

static const CGFloat SB_BUTTON_X = 100.0f;

#pragma mark - Object Lifecycle

+ (id) starfishButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initStarfishButton:numID text:text] autorelease];
}

- (id) initStarfishButton:(NSUInteger)numID text:(NSString *)text
{
    if ((self = [super initButton:numID toggle:NO])) {
        
        isSpinning_ = NO;
        sprite_ = [[CCSprite spriteWithFile:@"Starfish Button.png"] retain];
        [self addChild:sprite_];
        
        label_ = [[CCLabelBMFont labelWithString:text fntFile:@"MenuFont.fnt"] retain];
        label_.position = ccp(SB_BUTTON_X, 0);
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
        [self startFastSpin];
        [self unselectButton];        
    }
}

- (void) selectButton
{
    [super selectButton];
}

- (void) unselectButton
{
    [super unselectButton];    
}

- (void) startFastSpin
{
    [sprite_ stopAllActions];
    CCActionInterval *spin = [CCRotateBy actionWithDuration:3.0f angle:360.0f * 4];
    CCEaseIn *ease = [CCEaseIn actionWithAction:spin rate:2.0f];
    [sprite_ runAction:ease];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneFastSpin)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) doneFastSpin
{
    if ([delegate_ respondsToSelector:@selector(buttonClicked:)]) {
        [delegate_ buttonClicked:self];
    }    
}

@end
