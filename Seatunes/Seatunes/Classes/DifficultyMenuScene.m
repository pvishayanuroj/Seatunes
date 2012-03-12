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
static const CGFloat DMS_TITLE_Y = 650.0f;

static const CGFloat DMS_TEXT_Y = 530.0f;
static const CGFloat DMS_BUTTON_Y = 420.0f;
static const CGFloat DMS_BUTTON2_Y = 430.0f;
static const CGFloat DMS_BUTTON_X = 512.0f;
static const CGFloat DMS_BUTTON_PADDING = 200.0f;

static const CGFloat DMS_MENU_FRAME_X = 512.0f;
static const CGFloat DMS_MENU_FRAME_Y = 440.0f;

static const CGFloat DMS_BACK_BUTTON_X = 50.0f;
static const CGFloat DMS_BACK_BUTTON_Y = 730.0f;

static const CGFloat DMS_PLAY_BUTTON_X = 650.0f;
static const CGFloat DMS_PLAY_BUTTON_Y = 250.0f;

static const GLubyte DMS_FULL_OPACITY = 255;
static const GLubyte DMS_SEMI_OPACITY = 150;

+ (id) startWithSongName:(NSString *)songName
{
    return [[[self alloc] initWithSongName:songName] autorelease];
}

- (id) initWithSongName:(NSString *)songName
{
    if ((self = [super init])) {
        
        // Add background
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];      
        songName_ = [songName retain];
        
        // Add the frame
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Difficulty Menu Frame.png"];
        menuFrame.position = ccp(DMS_MENU_FRAME_X, DMS_MENU_FRAME_Y);
        [self addChild:menuFrame];        
        
        // Add text
        CCLabelBMFont *titleText = [CCLabelBMFont labelWithString:@"Choose Play Mode" fntFile:@"MenuFont.fnt"];
        titleText.position = ccp(DMS_TITLE_X, DMS_TITLE_Y);
        [self addChild:titleText];
        
        easyText_ = [[CCLabelBMFont labelWithString:@"Novice" fntFile:@"MenuFont.fnt"] retain];
        mediumText_ = [[CCLabelBMFont labelWithString:@"Pro" fntFile:@"MenuFont.fnt"] retain];
        hardText_ = [[CCLabelBMFont labelWithString:@"Master" fntFile:@"MenuFont.fnt"] retain];        
        
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
        easyButton_ = [[ScaledImageButton scaledImageButton:kDifficultyEasy image:@"Bubble Icon.png"] retain];
        mediumButton_ = [[ScaledImageButton scaledImageButton:kDifficultyMedium image:@"Clam Icon Unselected.png"] retain];
        hardButton_ = [[ScaledImageButton scaledImageButton:kDifficultyHard image:@"Music Note Icon Unselected.png"] retain];        
        
        easyButton_.delegate = self;
        mediumButton_.delegate = self;
        hardButton_.delegate = self;        
        
        easyButton_.position = ccp(DMS_BUTTON_X - DMS_BUTTON_PADDING, DMS_BUTTON_Y);
        mediumButton_.position = ccp(DMS_BUTTON_X, DMS_BUTTON2_Y);
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
        Button *backButton = [ScaledImageButton scaledImageButton:kDMSBack image:@"Back Arrow.png"];
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
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Icon.png"];
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Icon Unselected.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Icon Unselected.png"];  
            easyText_.opacity = DMS_SEMI_OPACITY;
            mediumText_.opacity = DMS_SEMI_OPACITY;
            hardText_.opacity = DMS_FULL_OPACITY;            
            difficulty_ = kDifficultyHard;   
            [[AudioManager audioManager] playSoundEffect:kMenuG1];            
            break;
        case kDMSMedium:
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Icon Unselected.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Icon.png"];            
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Icon Unselected.png"];    
            easyText_.opacity = DMS_SEMI_OPACITY;
            mediumText_.opacity = DMS_FULL_OPACITY;
            hardText_.opacity = DMS_SEMI_OPACITY;               
            difficulty_ = kDifficultyMedium;       
            [[AudioManager audioManager] playSoundEffect:kMenuE1];            
            break;
        case kDMSEasy:
            [(ScaledImageButton *)hardButton_ setImage:@"Music Note Icon Unselected.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Clam Icon Unselected.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Bubble Icon.png"];        
            easyText_.opacity = DMS_FULL_OPACITY;
            mediumText_.opacity = DMS_SEMI_OPACITY;
            hardText_.opacity = DMS_SEMI_OPACITY;                           
            difficulty_ = kDifficultyEasy;
            [[AudioManager audioManager] playSoundEffect:kMenuC1];            
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
    CCScene *scene = [GameScene startWithDifficulty:difficulty_ songName:songName_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
    [[AudioManager audioManager] playSoundEffect:kMenuB1];    
}

- (void) playMenu
{
    CCScene *scene = [PlayMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];
    [[AudioManager audioManager] playSoundEffect:kMenuA1];    
}

@end
