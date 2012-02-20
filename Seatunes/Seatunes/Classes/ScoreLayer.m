//
//  ScoreLayer.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/19/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ScoreLayer.h"
#import "Button.h"
#import "Menu.h"

@implementation ScoreLayer

static const CGFloat SL_ROW1_X = 70.0f;
static const CGFloat SL_ROW1_Y = 300.0f;
static const CGFloat SL_ROW2_X = 90.0f;
static const CGFloat SL_ROW2_Y = 210.0f;
static const CGFloat SL_ROW3_X = 110.0f;
static const CGFloat SL_ROW3_Y = 120.0f;

static const CGFloat SL_STAR_X = 395.0f;
static const CGFloat SL_STAR_SPACING = 80.0f;

static const CGFloat SL_NEXT_X = 790.0f;
static const CGFloat SL_NEXT_Y = 330.0f;
static const CGFloat SL_REPLAY_X = 800.0f;
static const CGFloat SL_REPLAY_Y = 205.0f;
static const CGFloat SL_MENU_X = 810.0f;
static const CGFloat SL_MENU_Y = 75.0f;

+ (id) scoreLayer:(ScoreInfo)scoreInfo
{
    return [[[self alloc] initScoreLayer:scoreInfo] autorelease];
}

- (id) initScoreLayer:(ScoreInfo)scoreInfo
{
    if ((self = [super init])) {
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"Score Menu Frame.png"];
        sprite.position = ccp(0, 0);
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.75f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Replay Button.png" scale:0.75f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Menu Button.png" scale:0.75f];           
        
        nextButton.position = ccp(SL_NEXT_X, SL_NEXT_Y);
        replayButton.position = ccp(SL_REPLAY_X, SL_REPLAY_Y);
        menuButton.position = ccp(SL_MENU_X, SL_MENU_Y);        
        
        nextButton.delegate = self;
        replayButton.delegate = self;
        menuButton.delegate = self;
        
        [self addChild:nextButton];
        [self addChild:replayButton];
        [self addChild:menuButton];        
        
        CCLabelBMFont *earnedText = [CCLabelBMFont labelWithString:@"You earned" fntFile:@"MenuFont.fnt"];
        
        switch (scoreInfo.score) {
            case kScoreOneStar:
                earnedText = [CCLabelBMFont labelWithString:@"You earned 1 star:" fntFile:@"MenuFont.fnt"]; 
                break;
            case kScoreTwoStar:
                earnedText = [CCLabelBMFont labelWithString:@"You earned 2 stars:" fntFile:@"MenuFont.fnt"];                 
                break;
            case kScoreThreeStar:
                earnedText = [CCLabelBMFont labelWithString:@"You earned 3 stars:" fntFile:@"MenuFont.fnt"];                                 
                break;
            default:
                break;
        }
        
        earnedText.position = ccp(SL_ROW1_X, SL_ROW1_Y);
        earnedText.anchorPoint = ccp(0, 0.5f);
        [self addChild:earnedText];
        
        // Add the stars        
        for (NSInteger i = 0; i < scoreInfo.score; ++i) {
            CCSprite *sprite = [CCSprite spriteWithFile:@"Full Star.png"];
            sprite.position = ccp(SL_STAR_X + SL_STAR_SPACING * i, SL_ROW1_Y);
            sprite.scale = 0.5f;
            [self addChild:sprite];
        }
        
        // Add the extra score information
        NSString *hitString = [NSString stringWithFormat:@"You hit %d notes", scoreInfo.notesHit];
        NSString *missedString;
        if (scoreInfo.notesMissed == 1) {
            missedString = [NSString stringWithFormat:@"You missed %d note", scoreInfo.notesMissed];                    
        }
        else {
            missedString = [NSString stringWithFormat:@"You missed %d notes", scoreInfo.notesMissed];        
        }
        
        CCLabelBMFont *hitText = [CCLabelBMFont labelWithString:hitString fntFile:@"MenuFont.fnt"];
        CCLabelBMFont *missedText = [CCLabelBMFont labelWithString:missedString fntFile:@"MenuFont.fnt"];
        
        hitText.position = ccp(SL_ROW2_X, SL_ROW2_Y);
        missedText.position = ccp(SL_ROW3_X, SL_ROW3_Y);        
        hitText.anchorPoint = ccp(0, 0.5f);
        missedText.anchorPoint = ccp(0, 0.5f);        
        
        [self addChild:hitText];
        [self addChild:missedText];        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonMenu:
            
            break;
        case kButtonNext:
            break;
        case kButtonReplay:
            break;
        default:
            break;
    }       
}


@end
