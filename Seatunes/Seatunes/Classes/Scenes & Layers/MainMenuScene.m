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
#import "Utility.h"
#import "LoadingIndicator.h"

@implementation MainMenuScene

static const CGFloat MMS_TITLE_X = 700.0f;
static const CGFloat MMS_TITLE_Y = 600.0f;
static const CGFloat MMS_PLAY_X = 100.0f;
static const CGFloat MMS_PLAY_Y = 600.0f;
static const CGFloat MMS_FREEPLAY_X = 200.0f;
static const CGFloat MMS_FREEPLAY_Y = 475.0f;
static const CGFloat MMS_BUY_X = 200.0f;
static const CGFloat MMS_BUY_Y = 500.0f;
static const CGFloat MMS_MUSIC_X = 995.0f;
static const CGFloat MMS_MUSIC_Y = 735.0f;
static const CGFloat MMS_LOCK_X = 40.0f;
static const CGFloat MMS_LOCK_Y = -30.0f;
static const CGFloat MMS_LOCK_SCALE = 0.8f;

- (id) init
{
    if ((self = [super init])) {
        
        loadingIndicator_ = nil;
        
        // Initialze the data manager
        [DataUtility manager];
        
        // Initialize the audio engine and all preload sounds
        [AudioManager audioManager];        
        
        // Load all the IAP singleton with all product identifiers (does not make a network request)
        // along with all purchased products (by reading the user defaults)
        NSSet *productIdentifiers = [NSSet setWithArray:[[DataUtility manager] allProductIdentifiers]];
        [[SeatunesIAPHelper manager] loadProductIdentifiers:productIdentifiers];
         
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];          

        CCSprite *foreground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        foreground.anchorPoint = CGPointZero;
        [self addChild:foreground];                  
        
        CCSprite *title = [CCSprite spriteWithFile:@"Seatunes Title.png"];
        //title.position = ccp(MMS_TITLE_X, MMS_TITLE_Y);
        title.position = ADJUST_IPAD_CCP(ccp(MMS_TITLE_X, MMS_TITLE_Y));
        [self addChild:title];
        
        playButton_ = [[StarfishButton starfishButton:kPlayButton text:@"Play"] retain];
        playButton_.delegate = self;
        playButton_.position = ADJUST_IPAD_CCP(ccp(MMS_PLAY_X, MMS_PLAY_Y));

#if IAP_ON
        BOOL isLocked = ![[SeatunesIAPHelper manager] allPacksPurchased];
#else
        BOOL isLocked = NO;
#endif
        
        if (isLocked) {
            freePlayButton_ = [[StarfishButton starfishButtonUnselected:kFreePlayButton text:@"Free Play"] retain];                 
        }
        else {
            freePlayButton_ = [[StarfishButton starfishButton:kFreePlayButton text:@"Free Play"] retain];            
        }
        freePlayButton_.delegate = self;
        freePlayButton_.position = ADJUST_IPAD_CCP(ccp(MMS_FREEPLAY_X, MMS_FREEPLAY_Y));        
        
        [self addChild:playButton_];
        [self addChild:freePlayButton_];        

        lockIcon_ = nil;
        if (isLocked) {
            lockIcon_ = [[CCSprite spriteWithFile:@"Lock Icon.png"] retain];
            lockIcon_.scale = MMS_LOCK_SCALE;
            lockIcon_.position = ADJUST_IPAD_CCP(ccp(MMS_FREEPLAY_X + MMS_LOCK_X, MMS_FREEPLAY_Y + MMS_LOCK_Y));
            [self addChild:lockIcon_];
        }        
        
        if ([DataUtility manager].backgroundMusicOn) {
            musicButton_ = [[ScaledImageButton scaledImageButton:kMusicButton image:@"Music On Button.png"] retain];    
            [[AudioManager audioManager] playBackgroundMusic:kHappyJumper];                        
        }
        else {
            musicButton_ = [[ScaledImageButton scaledImageButton:kMusicButton image:@"Music Off Button.png"] retain];            
        }
        
        musicButton_.delegate = self;
        musicButton_.position = ADJUST_IPAD_CCP(ccp(MMS_MUSIC_X, MMS_MUSIC_Y));
        [self addChild:musicButton_];
    }
    return self;
}

- (void) dealloc
{
    [musicButton_ release];
    [freePlayButton_ release];
    [playButton_ release];
    [loadingIndicator_ release];
    [lockIcon_ release];
    
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
            [[AudioManager audioManager] playSound:kD4 instrument:kMenu];            
#if IAP_ON
            if (![[SeatunesIAPHelper manager] allPacksPurchased]) {
                [[SeatunesIAPHelper manager] buyProduct:self];
            }
            else {
                scene = [FreePlayScene node];
                [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:NO]];                
            }
#else
            scene = [FreePlayScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:NO]];               
#endif  
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

#pragma mark - Delegate Methods

- (void) purchaseComplete
{
    lockIcon_.visible = NO;
    
    [freePlayButton_ removeFromParentAndCleanup:YES];
    [freePlayButton_ release];
    
    freePlayButton_ = [[StarfishButton starfishButton:kFreePlayButton text:@"Free Play"] retain];            
    freePlayButton_.delegate = self;
    freePlayButton_.position = ADJUST_IPAD_CCP(ccp(MMS_FREEPLAY_X, MMS_FREEPLAY_Y));        
}

- (void) showLoading
{    
    playButton_.isClickable = NO;
    freePlayButton_.isClickable = NO;    
    musicButton_.isClickable = NO;
    
    loadingIndicator_ = [[LoadingIndicator loadingIndicator] retain];
    [self addChild:loadingIndicator_];
}

- (void) finishLoading
{ 
    [loadingIndicator_ remove];
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
    
    playButton_.isClickable = YES;
    freePlayButton_.isClickable = YES;    
    musicButton_.isClickable = YES;    
}

@end
