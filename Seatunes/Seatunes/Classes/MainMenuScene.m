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

@implementation MainMenuScene

static const CGFloat MMS_PLAY_X = 100.0f;
static const CGFloat MMS_PLAY_Y = 600.0f;
static const CGFloat MMS_BUY_X = 200.0f;
static const CGFloat MMS_BUY_Y = 500.0f;

- (id) init
{
    if ((self = [super init])) {
        
        [AudioManager audioManager];        
        
        playMenuScene_ = [[PlayMenuScene node] retain];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];                
        
        Button *playButton = [StarfishButton starfishButton:kPlayButton text:@"Play"];
        playButton.delegate = self;
        playButton.position = ccp(MMS_PLAY_X, MMS_PLAY_Y);
        
        [self addChild:playButton];
        
    }
    return self;
}

- (void) dealloc
{
    [playMenuScene_ release];
    
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kPlayButton:
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:playMenuScene_]];            
            break;
        case kBuySongsButton:
            break;
        default:
            break;
    }
}

@end
