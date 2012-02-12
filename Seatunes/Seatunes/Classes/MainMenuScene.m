//
//  MainMenuScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/28/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuScene.h"
#import "PlayMenuScene.h"
#import "Button.h"

@implementation MainMenuScene

static const CGFloat MMS_PLAY_X = 100.0f;
static const CGFloat MMS_PLAY_Y = 600.0f;
static const CGFloat MMS_BUY_X = 200.0f;
static const CGFloat MMS_BUY_Y = 500.0f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];                
        
        NSString *playText = @"Play Text.png";
        NSString *buyText = @"Buy Text.png";     
        
        Button *playButton = [ScaledImageButton scaledImageButton:kPlayButton image:playText];
        Button *buyButton = [ScaledImageButton scaledImageButton:kPlayButton image:buyText]; 
        
        playButton.delegate = self;
        buyButton.delegate = self;
        
        playButton.position = ccp(MMS_PLAY_X, MMS_PLAY_Y);
        buyButton.position = ccp(MMS_BUY_X, MMS_BUY_Y);
        
        [self addChild:playButton];
        [self addChild:buyButton];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{
    CCScene *scene;
    switch (button.numID) {
        case kPlayButton:
            scene = [PlayMenuScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:scene]];            
            break;
        case kBuySongsButton:
            break;
        default:
            break;
    }
}

@end
