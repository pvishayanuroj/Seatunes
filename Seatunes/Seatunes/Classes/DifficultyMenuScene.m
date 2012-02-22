//
//  DifficultyMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/13/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "DifficultyMenuScene.h"
#import "GameScene.h"
#import "Button.h"
#import "StarfishButton.h"

@implementation DifficultyMenuScene

static const CGFloat DMS_TITLE_X = 512.0f;
static const CGFloat DMS_TITLE_Y = 650.0f;

static const CGFloat DMS_TEXT_Y = 530.0f;
static const CGFloat DMS_BUTTON_Y = 420.0f;
static const CGFloat DMS_BUTTON_X = 512.0f;
static const CGFloat DMS_BUTTON_PADDING = 200.0f;

static const CGFloat DMS_PLAY_BUTTON_X = 650.0f;
static const CGFloat DMS_PLAY_BUTTON_Y = 250.0f;

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
        
        // Add text
        CCLabelBMFont *titleText = [CCLabelBMFont labelWithString:@"Choose Difficulty" fntFile:@"MenuFont.fnt"];
        titleText.position = ccp(DMS_TITLE_X, DMS_TITLE_Y);
        [self addChild:titleText];
        
        CCLabelBMFont *easyText = [CCLabelBMFont labelWithString:@"Novice" fntFile:@"MenuFont.fnt"];
        CCLabelBMFont *mediumText = [CCLabelBMFont labelWithString:@"Pro" fntFile:@"MenuFont.fnt"];
        CCLabelBMFont *hardText = [CCLabelBMFont labelWithString:@"Master" fntFile:@"MenuFont.fnt"];        
        
        easyText.position = ccp(DMS_BUTTON_X - DMS_BUTTON_PADDING, DMS_TEXT_Y);
        mediumText.position = ccp(DMS_BUTTON_X, DMS_TEXT_Y);
        hardText.position = ccp(DMS_BUTTON_X + DMS_BUTTON_PADDING, DMS_TEXT_Y);        
        
        [self addChild:easyText];
        [self addChild:mediumText];
        [self addChild:hardText];        
        
        // Add buttons
        difficulty_ = kDifficultyEasy;
        easyButton_ = [[ScaledImageButton scaledImageButton:kDifficultyEasy image:@"Full Star.png"] retain];
        mediumButton_ = [[ScaledImageButton scaledImageButton:kDifficultyMedium image:@"Empty Star.png"] retain];
        hardButton_ = [[ScaledImageButton scaledImageButton:kDifficultyHard image:@"Empty Star.png"] retain];        
        
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
    }
    return self;
}

- (void) dealloc
{
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
            [(ScaledImageButton *)hardButton_ setImage:@"Full Star.png"];
            [(ScaledImageButton *)mediumButton_ setImage:@"Full Star.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Full Star.png"];  
            difficulty_ = kDifficultyHard;   
            break;
        case kDMSMedium:
            [(ScaledImageButton *)hardButton_ setImage:@"Empty Star.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Full Star.png"];            
            [(ScaledImageButton *)easyButton_ setImage:@"Full Star.png"];                        
            difficulty_ = kDifficultyMedium;       
            break;
        case kDMSEasy:
            [(ScaledImageButton *)hardButton_ setImage:@"Empty Star.png"];            
            [(ScaledImageButton *)mediumButton_ setImage:@"Empty Star.png"];                        
            [(ScaledImageButton *)easyButton_ setImage:@"Full Star.png"];                        
            difficulty_ = kDifficultyEasy;
            break;
        case kDMSPlay:
            [self startSong];
            break;
        default:
            break;
    }
}

- (void) startSong
{
    CCScene *scene = [GameScene startWithDifficulty:difficulty_ songName:songName_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:scene]];    
}

@end
