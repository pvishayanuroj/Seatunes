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
#import "Instructor.h"
#import "SpeechReader.h"
#import "PlayMenuScene.h"
#import "GameScene.h"

@implementation ScoreLayer

static const CGFloat SL_TITLE_LABEL_X = 512.0f; 
static const CGFloat SL_TITLE_LABEL_Y = 660.0f;
static const CGFloat SL_PERCENT_LABEL_X = 75.0f; 
static const CGFloat SL_PERCENT_LABEL_Y = 600.0f;
static const CGFloat SL_NOTES_LABEL_X = 250.0f; 
static const CGFloat SL_NOTES_LABEL_Y = 600.0f;
static const CGFloat SL_EARNED_LABEL_X = 70.0f;
static const CGFloat SL_EARNED_LABEL_Y = 500.0f;
static const CGFloat SL_BADGE_LABEL_X = 70.0f;
static const CGFloat SL_BADGE_LABEL_Y = 450.0f;
static const CGFloat SL_BADGE_X = 520.0f;
static const CGFloat SL_BADGE_Y = 500.0f;

static const CGFloat SL_INSTRUCTOR_X = 100.0f;
static const CGFloat SL_INSTRUCTOR_Y = 200.0f;

static const CGFloat SL_NEXT_X = 790.0f;
static const CGFloat SL_NEXT_Y = 330.0f;
static const CGFloat SL_REPLAY_X = 800.0f;
static const CGFloat SL_REPLAY_Y = 205.0f;
static const CGFloat SL_MENU_X = 810.0f;
static const CGFloat SL_MENU_Y = 75.0f;

+ (id) scoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    return [[[self alloc] initScoreLayer:scoreInfo songName:songName nextSong:nextSong] autorelease];
}

- (id) initScoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    if ((self = [super init])) {
        
        difficulty_ = scoreInfo.difficulty;
        songName_ = [songName retain];
        nextSong_ = [nextSong retain];
        
        // Add background
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];              
        
        CCSprite *frame = [CCSprite spriteWithFile:@"Score Parchment.png"];
        frame.position = ccp(0, 0);
        frame.anchorPoint = CGPointZero;
        [self addChild:frame];
        
        instructor_ = [[Instructor instructor:kWhaleInstructor] retain];
        instructor_.position = ccp(SL_INSTRUCTOR_X, SL_INSTRUCTOR_Y);
        [self addChild:instructor_];              
        
        CCLabelBMFont *songText = [CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"];
        songText.position = ccp(SL_TITLE_LABEL_X, SL_TITLE_LABEL_Y);
        [self addChild:songText];
        
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
        
        // Add the extra score information
        NSString *pctString;
        NSString *notesString;
        
        NSInteger percentage = round(100.0f * (CGFloat)scoreInfo.notesHit / (CGFloat)(scoreInfo.notesHit + scoreInfo.notesMissed));
        pctString = [NSString stringWithFormat:@"%d %%", percentage];
        
        // All notes hit
        if (scoreInfo.notesMissed == 0) {
            notesString = [NSString stringWithFormat:@"You hit all %d notes!", scoreInfo.notesHit];
        }
        // All notes missed
        else if (scoreInfo.notesHit == 0) {
            notesString = [NSString stringWithFormat:@"You missed all %d notes...", scoreInfo.notesMissed];
        }
        // Some hit, some missed
        else {
            if (scoreInfo.notesHit == 1) {
                notesString = [NSString stringWithFormat:@"You hit %d note", scoreInfo.notesHit];
            }
            else {
                notesString = [NSString stringWithFormat:@"You hit %d notes", scoreInfo.notesHit];            
            }
            if (scoreInfo.notesMissed == 1) {
                notesString = [notesString stringByAppendingFormat:@" and missed %d note!", scoreInfo.notesMissed];
            }
            else {
                notesString = [notesString stringByAppendingFormat:@" and missed %d notes", scoreInfo.notesMissed];
            }
        }
        
        CCLabelBMFont *pctLabel = [CCLabelBMFont labelWithString:pctString fntFile:@"MenuFont.fnt"];
        CCLabelBMFont *notesLabel = [CCLabelBMFont labelWithString:notesString fntFile:@"MenuFont.fnt"];
        pctLabel.anchorPoint = ccp(0, 0.5f);
        notesLabel.anchorPoint = ccp(0, 0.5f);        
        pctLabel.position = ccp(SL_PERCENT_LABEL_X, SL_PERCENT_LABEL_Y);
        notesLabel.position = ccp(SL_NOTES_LABEL_X, SL_NOTES_LABEL_Y);        
        [self addChild:pctLabel];
        [self addChild:notesLabel];
        
        CCLabelBMFont *earnedText = [CCLabelBMFont labelWithString:@"You didn't earn a badge this time,\nbetter luck next time!" fntFile:@"MenuFont.fnt"];
        earnedText.position = ccp(SL_EARNED_LABEL_X, SL_EARNED_LABEL_Y);
        earnedText.anchorPoint = ccp(0, 0.5f);
        [self addChild:earnedText];        
        
        if (percentage >= PERCENT_FOR_BADGE) {
            NSString *spriteName;
            NSString *badgeName;
            switch (scoreInfo.difficulty) {
                case kDifficultyEasy:
                    spriteName = @"Bubble Button.png";
                    badgeName = @"The Bubble Badge";
                    break;
                case kDifficultyMedium:
                    spriteName = @"Clam Button.png";                
                    badgeName = @"The Clam Badge";
                    break;
                case kDifficultyHard:
                    spriteName = @"Music Note Button.png";       
                    badgeName = @"The Note Badge";
                    break;
                default:
                    break;
            }
            
            earnedText.string = @"You earned";     
            
            CCLabelBMFont *badgeText = [CCLabelBMFont labelWithString:badgeName fntFile:@"MenuFont.fnt"];
            badgeText.anchorPoint = ccp(0, 0.5f);
            badgeText.position = ccp(SL_BADGE_LABEL_X, SL_BADGE_LABEL_Y);
            [self addChild:badgeText];
            
            CCSprite *sprite;            
            sprite = [CCSprite spriteWithFile:spriteName];
            sprite.position = ccp(SL_BADGE_X, SL_BADGE_Y);
            
            sprite.scale = 0.5f;
            [self addChild:sprite];                    
        }        
    }
    return self;
}

- (void) dealloc
{
    [instructor_ release];
    [songName_ release];
    [nextSong_ release];
    
    [super dealloc];
}

- (void) buttonClicked:(Button *)button
{
    CCScene *scene;
    
    switch (button.numID) {
        case kButtonMenu:
            scene = [PlayMenuScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                                    
            break;
        case kButtonReplay:
            scene = [GameScene startWithDifficulty:difficulty_ songName:songName_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                                         
            break;
        case kButtonNext:
            scene = [GameScene startWithDifficulty:difficulty_ songName:nextSong_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                                                     
            break;
        default:
            break;
    }
}


@end
