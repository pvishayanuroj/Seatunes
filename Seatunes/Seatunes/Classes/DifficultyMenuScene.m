//
//  DifficultyMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/13/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "DifficultyMenuScene.h"
#import "PlayMenuScene.h"
#import "GameScene.h"
#import "Button.h"
#import "StarfishButton.h"
#import "AudioManager.h"

@implementation DifficultyMenuScene

static const CGFloat DMS_TITLE_X = 512.0f;
static const CGFloat DMS_TITLE_Y = 610.0f;

static const CGFloat DMS_TEXT_Y = 360.0f;
static const CGFloat DMS_BUTTON_X = 512.0f;
static const CGFloat DMS_BUTTON_Y = 460.0f;
static const CGFloat DMS_BUTTON_PADDING = 200.0f;

static const CGFloat DMS_MENU_FRAME_X = 512.0f;
static const CGFloat DMS_MENU_FRAME_Y = 480.0f;

static const CGFloat DMS_BACK_BUTTON_X = 50.0f;
static const CGFloat DMS_BACK_BUTTON_Y = 730.0f;

static const CGFloat DMS_PLAY_BUTTON_X = 650.0f;
static const CGFloat DMS_PLAY_BUTTON_Y = 200.0f;

static const GLubyte DMS_FULL_OPACITY = 255;
static const GLubyte DMS_SEMI_OPACITY = 150;

+ (id) startWithSongName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    return [[[self alloc] initWithSongName:songName packIndex:packIndex] autorelease];
}

- (id) initWithSongName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    if ((self = [super init])) {
        
        // Add background
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];      
        songName_ = [songName retain];
        packIndex_ = packIndex;
        
        // Add the frame
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Small Parchment.png"];
        menuFrame.position = ccp(DMS_MENU_FRAME_X, DMS_MENU_FRAME_Y);
        [self addChild:menuFrame];        
        
        // Add text
        CCLabelBMFont *titleText = [CCLabelBMFont labelWithString:@"Choose Play Mode" fntFile:@"BoldMenuFont.fnt"];
        titleText.position = ccp(DMS_TITLE_X, DMS_TITLE_Y);
        [self addChild:titleText];
        
        easyText_ = [[CCLabelBMFont labelWithString:@"Bubble" fntFile:@"MenuFont.fnt"] retain];
        mediumText_ = [[CCLabelBMFont labelWithString:@"Clam" fntFile:@"MenuFont.fnt"] retain];
        hardText_ = [[CCLabelBMFont labelWithString:@"Note" fntFile:@"MenuFont.fnt"] retain];        
        
        easyText_.position = ccp(DMS_BUTTON_X - DMS_BUTTON_PADDING, DMS_TEXT_Y);
        mediumText_.position = ccp(DMS_BUTTON_X, DMS_TEXT_Y);
        hardText_.position = ccp(DMS_BUTTON_X + DMS_BUTTON_PADDING, DMS_TEXT_Y);        
        easyText_.opacity = DMS_FULL_OPACITY;
        mediumText_.opacity = DMS_SEMI_OPACITY;
        hardText_.opacity = DMS_SEMI_OPACITY;
        
        [self addChild:easyText_];
        [self addChild:mediumText_];
        [self addChild:hardText_];        
        
        // Add buttons
        difficulty_ = kDifficultyEasy;
        easyButton_ = [[ScaledImageButton scaledImageButton:kDifficultyEasy image:@"Bubble Button.png"] retain];
        mediumButton_ = [[ScaledImageButton scaledImageButton:kDifficultyMedium image:@"Clam Button Unselected.png"] retain];
        hardButton_ = [[ScaledImageButton scaledImageButton:kDifficultyHard image:@"Music Note Button Unselected.png"] retain];        
        
        easyButton_.delegate = self;
        mediumButton_.delegate = self;
        hardButton_.delegate = self;        
        
        easyButton_.position = ccp(DMS_BUTTON_X - DMS_BUTTON_PADDING, DMS_BUTTON_Y);
        mediumButton_.position = ccp(DMS_BUTTON_X, DMS_BUTTON_Y);
        hardButton_.position = ccp(DMS_BUTTON_X + DMS_BUTTON_PADDING, DMS_BUTTON_Y);        
        
        [self addChild:easyButton_];
        [self addChild:mediumButton_];
        [self addChild:hardButton_];   
        
        // Add play button
        StarfishButton *playButton = [StarfishButton starfishButton:kDMSPlay text:@"Play"];
        playButton.delegate = self;
        playButton.position = ccp(DMS_PLAY_BUTTON_X, DMS_PLAY_BUTTON_Y);
        [self addChild:playButton];        
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kDMSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ccp(DMS_BACK_BUTTON_X, DMS_BACK_BUTTON_Y);
        [self addChild:backButton];
    }
    return self;
}

- (void) dealloc
{
    [easyText_ release];
    [mediumText_ release];
    [hardText_ release];
    [songName_ release];
    [easyButton_ release];
    [mediumButton_ release];
    [hardButton_ release];
    
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{   
    switch (button.numID) {
        case kDMSHard:
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Button.png"];
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Button Unselected.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Button Unselected.png"];  
            easyText_.opacity = DMS_SEMI_OPACITY;
            mediumText_.opacity = DMS_SEMI_OPACITY;
            hardText_.opacity = DMS_FULL_OPACITY;            
            difficulty_ = kDifficultyHard;   
            [[AudioManager audioManager] playSound:kG4 instrument:kMenu];            
            break;
        case kDMSMedium:
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Button Unselected.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Button.png"];            
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Button Unselected.png"];    
            easyText_.opacity = DMS_SEMI_OPACITY;
            mediumText_.opacity = DMS_FULL_OPACITY;
            hardText_.opacity = DMS_SEMI_OPACITY;               
            difficulty_ = kDifficultyMedium;       
            [[AudioManager audioManager] playSound:kE4 instrument:kMenu];             
            break;
        case kDMSEasy:
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Button Unselected.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Button Unselected.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Button.png"];        
            easyText_.opacity = DMS_FULL_OPACITY;
            mediumText_.opacity = DMS_SEMI_OPACITY;
            hardText_.opacity = DMS_SEMI_OPACITY;                           
            difficulty_ = kDifficultyEasy;
            [[AudioManager audioManager] playSound:kC4 instrument:kMenu];            
            break;
        case kDMSPlay:
            [self startSong];
            break;
        case kDMSBack:
            [self playMenu];
            break;
        default:
            break;
    }
}

- (void) startSong
{
    CCScene *scene = [GameScene startWithDifficulty:difficulty_ songName:songName_ packIndex:packIndex_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
    [[AudioManager audioManager] playSound:kC5 instrument:kMenu];  
}

- (void) playMenu
{
    CCScene *scene = [PlayMenuScene playMenuScene:packIndex_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];
    [[AudioManager audioManager] playSound:kA4 instrument:kMenu];   
}

@end
