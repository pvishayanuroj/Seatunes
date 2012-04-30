//
//  MainMenuScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/28/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuScene.h"
#import "PlayMenuScene.h"
#import "FreePlayScene.h"
#import "StarfishButton.h"
#import "AudioManager.h"
#import "DataUtility.h"
#import "SeatunesIAPHelper.h"

@implementation MainMenuScene

static const CGFloat MMS_TITLE_X = 700.0f;
static const CGFloat MMS_TITLE_Y = 600.0f;
static const CGFloat MMS_PLAY_X = 100.0f;
static const CGFloat MMS_PLAY_Y = 600.0f;
static const CGFloat MMS_FREEPLAY_X = 200.0f;
static const CGFloat MMS_FREEPLAY_Y = 475.0f;
static const CGFloat MMS_BUY_X = 200.0f;
static const CGFloat MMS_BUY_Y = 500.0f;

- (id) init
{
    if ((self = [super init])) {
        
        // Initialize the audio engine and all preload sounds
        [AudioManager audioManager];        
        
        // Load all the IAP singleton with all product identifiers (does not make a network request)
        NSSet *productIdentifiers = [NSSet setWithArray:[[DataUtility manager] allProductIdentifiers]];
        [[SeatunesIAPHelper manager] loadProductIdentifiers:productIdentifiers];
         
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];          

        CCSprite *foreground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        foreground.anchorPoint = CGPointZero;
        [self addChild:foreground];                  
        
        CCSprite *title = [CCSprite spriteWithFile:@"Seatunes Title.png"];
        title.position = ccp(MMS_TITLE_X, MMS_TITLE_Y);
        [self addChild:title];
        
        Button *playButton = [StarfishButton starfishButton:kPlayButton text:@"Play"];
        playButton.delegate = self;
        playButton.position = ccp(MMS_PLAY_X, MMS_PLAY_Y);
        
        Button *freePlayButton = [StarfishButton starfishButton:kFreePlayButton text:@"Free Play"];
        freePlayButton.delegate = self;
        freePlayButton.position = ccp(MMS_FREEPLAY_X, MMS_FREEPLAY_Y);        
        
        [self addChild:playButton];
        [self addChild:freePlayButton];        
        
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
            scene = [PlayMenuScene playMenuScene];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:NO]];
            [[AudioManager audioManager] playSound:kC4 instrument:kMenu];        
            break;
        case kFreePlayButton:
            scene = [FreePlayScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:NO]];
            [[AudioManager audioManager] playSound:kD4 instrument:kMenu];        
            break;
        case kBuySongsButton:
            break;
        default:
            break;
    }
}

@end
