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
static const CGFloat MMS_CREDITS_X = 300.0f;
static const CGFloat MMS_CREDITS_Y = 400.0f;

- (id) init
{
    if ((self = [super init])) {
        
        NSString *playText = @"Play Text.png";
        NSString *buyText = @"Buy Text.png";
        NSString *creditsText = @"Credits Text.png";        
        
        Button *playButton = [ImageButton imageButton:kPlayButton unselectedImage:playText selectedImage:playText];
        Button *buyButton = [ImageButton imageButton:kPlayButton unselectedImage:buyText selectedImage:buyText];
        Button *creditsButton = [ImageButton imageButton:kPlayButton unselectedImage:creditsText selectedImage:creditsText];        
        
        playButton.position = ccp(MMS_PLAY_X, MMS_PLAY_Y);
        buyButton.position = ccp(MMS_BUY_X, MMS_BUY_Y);
        creditsButton.position = ccp(MMS_CREDITS_X, MMS_CREDITS_Y);
        
        [self addChild:playButton];
        [self addChild:buyButton];
        [self addChild:creditsButton];
        
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
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:2.0 scene:scene]];            
            break;
        case kBuySongsButton:
            break;
        case kCreditsButton:
            break;
        default:
            break;
    }
}

@end
