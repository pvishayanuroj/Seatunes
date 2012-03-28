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
#import "PlayMenuScene.h"

@implementation ScoreLayer

static const CGFloat SL_ROW1_X = 70.0f;
static const CGFloat SL_ROW1_Y = 300.0f;
static const CGFloat SL_ROW2_X = 90.0f;
static const CGFloat SL_ROW2_Y = 210.0f;
static const CGFloat SL_ROW3_X = 110.0f;
static const CGFloat SL_ROW3_Y = 120.0f;

static const CGFloat SL_BUBBLE_ICON_X = 535.0f;
static const CGFloat SL_CLAM_ICON_X = 520.0f;
static const CGFloat SL_NOTE_ICON_X = 520.0f;
static const CGFloat SL_STAR_SPACING = 80.0f;

static const CGFloat SL_NEXT_X = 790.0f;
static const CGFloat SL_NEXT_Y = 330.0f;
static const CGFloat SL_REPLAY_X = 800.0f;
static const CGFloat SL_REPLAY_Y = 205.0f;
static const CGFloat SL_MENU_X = 810.0f;
static const CGFloat SL_MENU_Y = 75.0f;

@synthesize delegate = delegate_;

+ (id) scoreLayer:(ScoreInfo)scoreInfo
{
    return [[[self alloc] initScoreLayer:scoreInfo] autorelease];
}

- (id) initScoreLayer:(ScoreInfo)scoreInfo
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        
        CCSprite *frame = [CCSprite spriteWithFile:@"Score Parchment.png"];
        frame.position = ccp(0, 0);
        frame.anchorPoint = CGPointZero;
        [self addChild:frame];
        
        Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.75f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Restart Button.png" scale:0.75f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.75f];           
        
        nextButton.position = ccp(SL_NEXT_X, SL_NEXT_Y);
        replayButton.position = ccp(SL_REPLAY_X, SL_REPLAY_Y);
        menuButton.position = ccp(SL_MENU_X, SL_MENU_Y);        
        
        nextButton.delegate = self;
        replayButton.delegate = self;
        menuButton.delegate = self;
        
        [self addChild:nextButton];
        [self addChild:replayButton];
        [self addChild:menuButton];        
        
        CCSprite *sprite;
        CCLabelBMFont *earnedText = [CCLabelBMFont labelWithString:@"You didn't earn any badges this time,\nbetter luck next time!" fntFile:@"MenuFont.fnt"];
        CGFloat rowOffset = -30;
        earnedText.position = ccp(SL_ROW1_X, SL_ROW1_Y);
        earnedText.anchorPoint = ccp(0, 0.5f);
        [self addChild:earnedText];        
        
        if (scoreInfo.notesMissed == 0) {
            switch (scoreInfo.difficulty) {
                case kDifficultyEasy:
                    earnedText.string = @"You earned the Bubble Badge:";
                    sprite = [CCSprite spriteWithFile:@"Bubble Button.png"];
                    sprite.position = ccp(SL_BUBBLE_ICON_X, SL_ROW1_Y);                    
                    break;
                case kDifficultyMedium:
                    earnedText.string = @"You earned the Clam Badge:";
                    sprite = [CCSprite spriteWithFile:@"Clam Button.png"];                
                    sprite.position = ccp(SL_CLAM_ICON_X, SL_ROW1_Y);                    
                    break;
                case kDifficultyHard:
                    earnedText.string = @"You earned the Note Badge";
                    sprite = [CCSprite spriteWithFile:@"Music Note Button.png"];         
                    sprite.position = ccp(SL_NOTE_ICON_X, SL_ROW1_Y);                                        
                    break;
                default:
                    break;
            }
            
            rowOffset = 0;
            sprite.scale = 0.5f;
            [self addChild:sprite];                    
        }
        
        // Add the extra score information
        NSString *hitString;
        NSString *missedString;
        
        if (scoreInfo.notesHit == 1) {
            hitString = [NSString stringWithFormat:@"You hit %d note!", scoreInfo.notesHit];
        }
        else {
            hitString = [NSString stringWithFormat:@"You hit %d notes!", scoreInfo.notesHit];            
        }
        if (scoreInfo.notesMissed == 1) {
            missedString = [NSString stringWithFormat:@"You missed %d note!", scoreInfo.notesMissed];                    
        }
        else {
            missedString = [NSString stringWithFormat:@"You missed %d notes!", scoreInfo.notesMissed];        
        }
        
        CCLabelBMFont *hitText = [CCLabelBMFont labelWithString:hitString fntFile:@"MenuFont.fnt"];
        CCLabelBMFont *missedText = [CCLabelBMFont labelWithString:missedString fntFile:@"MenuFont.fnt"];
        
        hitText.position = ccp(SL_ROW2_X, SL_ROW2_Y + rowOffset);
        missedText.position = ccp(SL_ROW3_X, SL_ROW3_Y + rowOffset);        
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
    [delegate_ scoreLayerMenuItemSelected:button];
}


@end
