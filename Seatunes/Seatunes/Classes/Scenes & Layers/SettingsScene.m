//
//  SettingsScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SettingsScene.h"
#import "Button.h"
#import "AudioManager.h"
#import "MainMenuScene.h"
#import "Slider.h"
#import "DataUtility.h"
#import "StarfishButton.h"
#import "Apsalar.h"

@implementation SettingsScene

static const CGFloat SS_TITLE_X = 512.0f;
static const CGFloat SS_TITLE_Y = 580.0f;
static const CGFloat SS_BACK_BUTTON_X = 50.0f;
static const CGFloat SS_BACK_BUTTON_Y = 730.0f;
static const CGFloat SS_RESET_BUTTON_X = 560.0f;
static const CGFloat SS_RESET_BUTTON_Y = 250.0f;
static const CGFloat SS_MENU_FRAME_X = 512.0f;
static const CGFloat SS_MENU_FRAME_Y = 500.0f;

static const CGFloat SS_SLIDER_WIDTH = 500.0f;
static const CGFloat SS_SLIDER_X = 512.0f;
static const CGFloat SS_SLIDER_Y = 470.0f;
static const CGFloat SS_SPEED_Y_OFFSET = -40.0f;
static const CGFloat SS_SPEED_Y_OFFSET_M = -20.0f;
static const CGFloat SS_SPEED_X_PADDING = 240.0f;

static const CGFloat SS_SPEED_SLOW_VALUE = 0.0f;
static const CGFloat SS_SPEED_NORMAL_VALUE = 0.5f;
static const CGFloat SS_SPEED_FAST_VALUE = 1.0f;

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Small Parchment.png"];
        menuFrame.position = ADJUST_IPAD_CCP(ccp(SS_MENU_FRAME_X, SS_MENU_FRAME_Y));
        menuFrame.scaleY = CHOOSE_REL_CCP(0.7f, 0.8f);
        [self addChild:menuFrame];        
        
        // Add text
        CCLabelBMFont *titleText = [CCLabelBMFont labelWithString:@"Song Speed" fntFile:@"BoldMenuFont.fnt"];
        titleText.position = ADJUST_IPAD_CCP(ccp(SS_TITLE_X, SS_TITLE_Y));
        [self addChild:titleText];        
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kSSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ADJUST_IPAD_CCP(ccp(SS_BACK_BUTTON_X, SS_BACK_BUTTON_Y));
        [self addChild:backButton];         
        
        Button *resetButton = [StarfishButton starfishButtonBlue:kSSResetTutorials text:@"Reset Instructions"];
        resetButton.delegate = self;
        resetButton.scale = 0.8f;
        resetButton.position = ADJUST_IPAD_CCP(ccp(SS_RESET_BUTTON_X, SS_RESET_BUTTON_Y));
        [self addChild:resetButton];                 
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];             
        
        slowLabel_ = [[CCLabelBMFont labelWithString:@"Easy" fntFile:@"Dialogue Font.fnt"] retain];
        normalLabel_ = [[CCLabelBMFont labelWithString:@"Normal" fntFile:@"Dialogue Font.fnt"] retain];
        fastLabel_ = [[CCLabelBMFont labelWithString:@"Hard" fntFile:@"Dialogue Font.fnt"] retain];    
        
        CGFloat yOffset = CHOOSE_REL_CCP(SS_SLIDER_Y + SS_SPEED_Y_OFFSET, ADJUST_IPAD_HEIGHT(SS_SLIDER_Y) + SS_SPEED_Y_OFFSET_M);
        slowLabel_.position = ccp(ADJUST_IPAD_WIDTH((SS_SLIDER_X - SS_SPEED_X_PADDING)), yOffset); // Note extra parentheses
        normalLabel_.position = ccp(ADJUST_IPAD_WIDTH(SS_SLIDER_X), yOffset);
        fastLabel_.position = ccp(ADJUST_IPAD_WIDTH((SS_SLIDER_X + SS_SPEED_X_PADDING)), yOffset);        
        
        [self addChild:slowLabel_];
        [self addChild:normalLabel_];
        [self addChild:fastLabel_];  
        
        slider_ = nil;        
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:0.4f];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(showSlider)];
        [self runAction:[CCSequence actions:delay, done, nil]];
        
#if ANALYTICS_ON
        [Apsalar event:@"Settings"];
#endif              
    }
    return self;
}

- (void) dealloc
{
    [slowLabel_ release];
    [normalLabel_ release];
    [fastLabel_ release];
    [slider_ release];
    
    [super dealloc];
}

- (void) showSlider
{
    
    slider_ = [[Slider slider:ADJUST_IPAD_CCP(ccp(SS_SLIDER_X, SS_SLIDER_Y)) width:ADJUST_IPAD_WIDTH(SS_SLIDER_WIDTH)] retain];
    slider_.delegate = self;    
    
    SongSpeed songSpeed = [[DataUtility manager] getSongSpeed];
    switch (songSpeed) {
        case kSongSpeedSlow:
            [slider_ setSliderNoAnimation:SS_SPEED_SLOW_VALUE];
            break;
        case kSongSpeedNormal:
            [slider_ setSliderNoAnimation:SS_SPEED_NORMAL_VALUE];
            break;
        case kSongSpeedFast:
            [slider_ setSliderNoAnimation:SS_SPEED_FAST_VALUE];
            break;
        default:
            [slider_ setSliderNoAnimation:SS_SPEED_NORMAL_VALUE];
            break;
    }  
    
    [self addChild:slider_];     
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kSSBack:
            [self loadMainMenu];            
            break;
        case kSSResetTutorials:
            [self showResetConfirmation];
            break;
        default:
            break;
    }    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        [[DataUtility manager] resetTutorials];
        [slider_ setSlider:SS_SPEED_NORMAL_VALUE];
        [[DataUtility manager] setSongSpeed:kSongSpeedNormal];          
        [self showResetSuccess];
#if ANALYTICS_ON  
        [Apsalar event:@"TutorialsReset"];
#endif                      
    }
}

- (void) doneSliding:(CGFloat)value
{
    [[AudioManager audioManager] playSoundEffect:kClick];
    if (value < 0.33f) {
        [slider_ setSlider:SS_SPEED_SLOW_VALUE];
        [[DataUtility manager] setSongSpeed:kSongSpeedSlow];       
#if ANALYTICS_ON  
        [Apsalar eventWithArgs:@"SetSongSpeed", @"Speed", @"Slow", nil];
#endif              
    }
    else if (value > 0.66f) {
        [slider_ setSlider:SS_SPEED_FAST_VALUE];
        [[DataUtility manager] setSongSpeed:kSongSpeedFast];
#if ANALYTICS_ON  
        [Apsalar eventWithArgs:@"SetSongSpeed", @"Speed", @"Fast", nil];
#endif                      
    }
    else {
        [slider_ setSlider:SS_SPEED_NORMAL_VALUE];
        [[DataUtility manager] setSongSpeed:kSongSpeedNormal];      
#if ANALYTICS_ON  
        [Apsalar eventWithArgs:@"SetSongSpeed", @"Speed", @"Normal", nil];
#endif                      
    }
}

- (void) showResetConfirmation
{
    [[AudioManager audioManager] playSound:kE4 instrument:kMenu];           
    
    NSString *title = @"Reset instructional dialogue?";
    NSString *text = @"This makes Willy forget he met you!\n(Does not delete progress)";
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Reset", nil] autorelease];
    [message show];    
}

- (void) showResetSuccess
{
    NSString *title = @"Reset";
    NSString *text = @"Instructional dialogue has been reset!";
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [message show];        
}

- (void) loadMainMenu
{
    [slider_ remove];
    [[AudioManager audioManager] stopNarration];
    [[AudioManager audioManager] playSound:kA4 instrument:kMenu];       
    CCScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];    
    [[AudioManager audioManager] playSoundEffect:kPageFlip];  
}

@end
