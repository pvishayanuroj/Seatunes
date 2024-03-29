//
//  LittleOceanScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/18/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "LittleOceanScene.h"
#import "AudioManager.h"
#import "CharacterAvatar.h"
#import "MainMenuScene.h"
#import "Button.h"
#import "SpeechManager.h"
#import "Apsalar.h"

@implementation LittleOceanScene

static const CGFloat LOS_BACK_BUTTON_X = 50.0f;
static const CGFloat LOS_BACK_BUTTON_Y = 730.0f;
static const CGFloat LOS_LOGO_X = 700.0f;
static const CGFloat LOS_LOGO_Y = 600.0f;
static const CGFloat LOS_SAM_X = 300.0f;
static const CGFloat LOS_SAM_Y = 300.0f;
static const CGFloat LOS_APPSTORE_X = 800.0f;
static const CGFloat LOS_APPSTORE_Y = 100.0f;

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
    
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kLOSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ADJUST_IPAD_CCP(ccp(LOS_BACK_BUTTON_X, LOS_BACK_BUTTON_Y));
        [self addChild:backButton];           
        
        // Add scuba diver
        avatar_ = [[CharacterAvatar characterAvatarWithTarget:self] retain];
        avatar_.position = ADJUST_IPAD_CCP(ccp(LOS_SAM_X, LOS_SAM_Y));
        [self addChild:avatar_];
        [avatar_ startIdleAnimation];
        
        // Add logo
        CCSprite *logo = [CCSprite spriteWithFile:@"Little Ocean Logo.png"];
        logo.scale = 0.8f;
        logo.position = ADJUST_IPAD_CCP(ccp(LOS_LOGO_X, LOS_LOGO_Y));
        [self addChild:logo];
        
        // Add button
        Button *appStoreButton = [ScaledImageButton scaledImageButton:kLOSAppStore image:@"Appstore Button.png"];
        appStoreButton.delegate = self;
        appStoreButton.position = ADJUST_IPAD_CCP(ccp(LOS_APPSTORE_X, LOS_APPSTORE_Y));
        [self addChild:appStoreButton];
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];        
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:1.0f];
        CCActionInstant *start = [CCCallFunc actionWithTarget:self selector:@selector(start)];
        [self runAction:[CCSequence actions:delay, start, nil]];
        
        introPlaying_ = YES;
        narrationPlaying_ = YES;
        
#if ANALYTICS_ON
        [Apsalar event:@"MoreApps"];
#endif          
    }
    return self;
}

- (void) dealloc
{
    [avatar_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) characterAvatarPressed
{
    if (!introPlaying_ && !narrationPlaying_) {
        [avatar_ startTalking];
        [self playRandomSpeech];
    }
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kLOSBack:
            [self loadMainMenu];            
            break;
        case kLOSAppStore:
#if ANALYTICS_ON
            [Apsalar event:@"URLPromoClicked"];
#endif            
            [self loadAppStore];
            break;
        default:
            break;
    }
}

- (void) narrationComplete:(SpeechType)speechType
{
    switch (speechType) {
        case kLOIntro:
            introPlaying_ = NO;
            narrationPlaying_ = NO;
            [avatar_ stopTalking];
            break;
        default:
            narrationPlaying_ = NO;  
            [avatar_ stopTalking];            
            break;
    }
}

#pragma mark - Helper Methods

- (void) start
{
    [avatar_ startArmWavingAnimation];    
    [avatar_ startTalking];
    NSString *path = [[SpeechManager speechManager] keyFromSpeechType:kLOIntro];
    path = [NSString stringWithFormat:@"%@.%@", path, @"mp3"];    
    [[AudioManager audioManager] playNarration:kLOIntro path:path delegate:self];
}

- (void) playRandomSpeech
{
    SpeechType speechType;
    int rand = arc4random() % 5;
    switch (rand) {
        case 0:
            speechType = kLORandom1;
            break;
        case 1:
            speechType = kLORandom2;            
            break;
        case 2:
            speechType = kLORandom3;            
            break;
        case 3:
            speechType = kLORandom4;            
            break;
        case 4:
            speechType = kLORandom5;            
            break;
        default:
            speechType = kLORandom1;
            break;
    }
    
    NSString *path = [[SpeechManager speechManager] keyFromSpeechType:speechType];
    path = [NSString stringWithFormat:@"%@.%@", path, @"mp3"];
    [[AudioManager audioManager] playNarration:speechType path:path delegate:self];
    narrationPlaying_ = YES;
}

- (void) loadMainMenu
{
    [[AudioManager audioManager] stopNarration];
    [[AudioManager audioManager] playSound:kA4 instrument:kMenu];       
    CCScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];    
    [[AudioManager audioManager] playSoundEffect:kPageFlip];  
}

- (void) loadAppStore
{
    [[AudioManager audioManager] playSound:kE4 instrument:kMenu];       
    
    NSURL *url;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        url = [NSURL URLWithString:LITTLEOCEAN_IPAD_APPSTORE_LINK];
    }
    else {
        url = [NSURL URLWithString:LITTLEOCEAN_IPHONE_APPSTORE_LINK];
    }
    [[UIApplication sharedApplication] openURL:url];    
}

@end
