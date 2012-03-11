//
//  MainMenuScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/28/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuScene.h"
#import "PlayMenuScene.h"
#import "StarfishButton.h"
#import "AudioManager.h"
#import "DataUtility.h"
#import "SeatunesIAPHelper.h"

@implementation MainMenuScene

static const CGFloat MMS_TITLE_X = 700.0f;
static const CGFloat MMS_TITLE_Y = 600.0f;
static const CGFloat MMS_PLAY_X = 100.0f;
static const CGFloat MMS_PLAY_Y = 600.0f;
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
         
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];          
        
        CCSprite *title = [CCSprite spriteWithFile:@"Seatunes Title.png"];
        title.position = ccp(MMS_TITLE_X, MMS_TITLE_Y);
        [self addChild:title];
        
        Button *playButton = [StarfishButton starfishButton:kPlayButton text:@"Play"];
        playButton.delegate = self;
        playButton.position = ccp(MMS_PLAY_X, MMS_PLAY_Y);
        
        [self addChild:playButton];
        
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
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:NO]];
            [[AudioManager audioManager] playSoundEffect:kMenuE1];
            //[[CCDirector sharedDirector] replaceScene:[CCTransitionFlipY transitionWithDuration:0.5f scene:scene]];            
            break;
        case kBuySongsButton:
            break;
        default:
            break;
    }
}

@end
