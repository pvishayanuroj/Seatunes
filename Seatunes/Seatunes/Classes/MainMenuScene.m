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
static const CGFloat MMS_MUSIC_X = 1000.0f;
static const CGFloat MMS_MUSIC_Y = 740.0f;

- (id) init
{
    if ((self = [super init])) {
        
        // Initialze the data manager
        [DataUtility manager];
        
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
        
        if ([DataUtility manager].backgroundMusicOn) {
            musicButton_ = [[ScaledImageButton scaledImageButton:kMusicButton image:@"Music On Button.png"] retain];    
            [[AudioManager audioManager] playBackgroundMusic:kHappyJumper];                        
        }
        else {
            musicButton_ = [[ScaledImageButton scaledImageButton:kMusicButton image:@"Music Off Button.png"] retain];            
        }
        
        musicButton_.delegate = self;
        musicButton_.position = ccp(MMS_MUSIC_X, MMS_MUSIC_Y);
        [self addChild:musicButton_];
    }
    return self;
}

- (void) dealloc
{
    [musicButton_ release];
    
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
        case kCreditsButton:
            break;
        case kMusicButton:
            // If music was playing
            if ([DataUtility manager].backgroundMusicOn) {
                [[AudioManager audioManager] playSound:kE4 instrument:kMenu];
                [DataUtility manager].backgroundMusicOn = NO;
                [[AudioManager audioManager] pauseBackgroundMusic];
                [musicButton_ setImage:@"Music Off Button.png"];
            }
            // Else music was off
            else {
                [[AudioManager audioManager] playSound:kG4 instrument:kMenu];                
                [DataUtility manager].backgroundMusicOn = YES;
                [[AudioManager audioManager] resumeBackgroundMusic];
                [musicButton_ setImage:@"Music On Button.png"];
            }
            break;
        default:
            break;
    }
}

@end
