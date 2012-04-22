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
#import "Badge.h"
#import "IncrementingText.h"
#import "Text.h"
#import "AudioManager.h"
#import "DataUtility.h"

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
static const CGFloat SL_BADGE_X = 420.0f;
static const CGFloat SL_BADGE_Y = 480.0f;

static const CGFloat SL_INSTRUCTOR_X = 100.0f;
static const CGFloat SL_INSTRUCTOR_Y = 200.0f;
static const CGFloat SL_READER_OFFSET_X = 225.0f;
static const CGFloat SL_READER_OFFSET_Y = 75.0f;

static const CGFloat SL_NEXT_X = 790.0f;
static const CGFloat SL_NEXT_Y = 330.0f;
static const CGFloat SL_REPLAY_X = 800.0f;
static const CGFloat SL_REPLAY_Y = 550.0f;
static const CGFloat SL_MENU_X = 810.0f;
static const CGFloat SL_MENU_Y = 420.0f;

#pragma mark - Object Lifecycle

+ (id) scoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    return [[[self alloc] initScoreLayer:scoreInfo songName:songName nextSong:nextSong] autorelease];
}

- (id) initScoreLayer:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong
{
    if ((self = [super init])) {
        
        difficulty_ = scoreInfo.difficulty;
        scoreInfo_ = scoreInfo;
        scoreInfo_.percentage = round(100.0f * (CGFloat)scoreInfo.notesHit / (CGFloat)(scoreInfo.notesHit + scoreInfo.notesMissed));
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
        
        reader_ = [[SpeechReader speechReader] retain];
        reader_.delegate = self;
        reader_.position = ccp(SL_INSTRUCTOR_X + SL_READER_OFFSET_X, SL_INSTRUCTOR_Y + SL_READER_OFFSET_Y);
        [self addChild:reader_];           
        
        CCLabelBMFont *songText = [CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"];
        songText.position = ccp(SL_TITLE_LABEL_X, SL_TITLE_LABEL_Y);
        [self addChild:songText];
        
        //Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.75f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Restart Button.png" scale:0.75f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.75f];           
        
        //nextButton.position = ccp(SL_NEXT_X, SL_NEXT_Y);
        replayButton.position = ccp(SL_REPLAY_X, SL_REPLAY_Y);
        menuButton.position = ccp(SL_MENU_X, SL_MENU_Y);        
        
        //nextButton.delegate = self;
        replayButton.delegate = self;
        menuButton.delegate = self;
        
        //[self addChild:nextButton];
        [self addChild:replayButton];
        [self addChild:menuButton];        
        
        // Add the extra score information
        statsLabel_ = [[Text text:@"" fntFile:@"MenuFont.fnt" width:600.0f] retain];
        [statsLabel_ addFntFile:@"Dialogue Font.fnt" textType:kTextBold];
        statsLabel_.position = ccp(SL_NOTES_LABEL_X, SL_NOTES_LABEL_Y);
        [self addChild:statsLabel_];
        
        //CCParticleSystem *ps = [self createBadgePS];
        //ps.position = ccp(SL_BADGE_X, SL_BADGE_Y);
        //[self addChild:ps];        
        
        // If first time seeing score screen
        if ([[DataUtility manager] isFirstPlay]) {
            [reader_ loadSingleDialogue:kSpeechScoreExplanation];           
        }
        else {
            CCActionInterval *delay = [CCDelayTime actionWithDuration:1.0f];
            CCActionInstant *start = [CCCallBlock actionWithBlock:^{
                [self placeIncrementingPercentage];
            }];
            [self runAction:[CCSequence actions:delay, start, nil]];
        }        
    }
    return self;
}

- (void) dealloc
{
    [instructor_ release];
    [statsLabel_ release];
    [songName_ release];
    [nextSong_ release];
    [particles_ release];
    [reader_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

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

- (void) narrationStarting:(SpeechType)speechType
{
    [instructor_ showTalk];     
}

- (void) speechComplete:(SpeechType)speechType
{
    [instructor_ resetIdleFrame];
    
    switch (speechType) {
        case kSpeechScoreExplanation:
            [self placeIncrementingPercentage];
            break;
        case kSpeechBubbleBadge:
        case kSpeechClamBadge:
        case kSpeechNoteBadge:
            reader_.visible = NO;
            [self placeBadge];
            break;
        default:
            break;
    }
}

- (void) incrementationDone:(IncrementingText *)text
{
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:5];
    
    // Add the stats
    CCActionInterval *d1 = [CCDelayTime actionWithDuration:1.0f];
    CCActionInstant *t1 = [CCCallBlock actionWithBlock:^{
        [self placeFirstStats];
    }];
    
    [actions addObject:d1];
    [actions addObject:t1];
    
    if (scoreInfo_.notesHit != 0 && scoreInfo_.notesMissed != 0) {
        CCActionInterval *d2 = [CCDelayTime actionWithDuration:1.0f];            
        CCActionInstant *t2 = [CCCallBlock actionWithBlock:^{
            [self placeSecondStats];
        }];        
          
        [actions addObject:d2];
        [actions addObject:t2];
    }
    
    CCActionInterval *d3 = [CCDelayTime actionWithDuration:1.0f];  
    [actions addObject:d3];            
    
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneStats)];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];
}

#pragma mark - Helper Methods

- (void) placeIncrementingPercentage
{
    IncrementingText *pctLabel = [IncrementingText incrementingText:scoreInfo_.percentage font:@"MenuFont.fnt" alignment:kLeftAligned incrementType:kIncrementPercentage];    
    pctLabel.delegate = self;
    pctLabel.anchorPoint = ccp(0, 0.5f);   
    pctLabel.position = ccp(SL_PERCENT_LABEL_X, SL_PERCENT_LABEL_Y);    
    [self addChild:pctLabel];
}

- (void) placeFirstStats
{
    NSString *string;
    
    // All notes hit
    if (scoreInfo_.notesMissed == 0) {
        string = [NSString stringWithFormat:@"You hit all <b>%d</b> notes!", scoreInfo_.notesHit];
    }
    // All notes missed
    else if (scoreInfo_.notesHit == 0) {
        string = [NSString stringWithFormat:@"You missed all <b>%d</b> notes...", scoreInfo_.notesMissed];
    }
    // Some hit, some missed
    else {
        if (scoreInfo_.notesHit == 1) {
            string = [NSString stringWithFormat:@"You hit <b>%d</b> note", scoreInfo_.notesHit];
        }
        else {
            string = [NSString stringWithFormat:@"You hit <b>%d</b> notes", scoreInfo_.notesHit];            
        }
    }    
    
    [[AudioManager audioManager] playSoundEffect:kBubblePop];
    [statsLabel_ setString:string];
}

- (void) placeSecondStats
{
    NSString *string = [statsLabel_ string];
    
    if (scoreInfo_.notesMissed == 1) {
        string = [string stringByAppendingFormat:@" and missed <b>%d</b> note!", scoreInfo_.notesMissed];
    }
    else {
        string = [string stringByAppendingFormat:@" and missed <b>%d</b> notes", scoreInfo_.notesMissed];
    }    
    
    [[AudioManager audioManager] playSoundEffect:kBubblePop];    
    [statsLabel_ setString:string];
}

- (void) doneStats
{
    if (scoreInfo_.percentage >= PERCENT_FOR_BADGE) {
        switch (scoreInfo_.difficulty) {
            case kDifficultyEasy:
                [reader_ loadSingleDialogue:kSpeechBubbleBadge];
                break;
            case kDifficultyMedium:
                [reader_ loadSingleDialogue:kSpeechClamBadge];
                break;
            case kDifficultyHard:
                [reader_ loadSingleDialogue:kSpeechNoteBadge];
                break;
            default:
                break;
        }
    }
    else {
        [self placeNoBadge];
    }
}

- (void) placeNoBadge
{
    CCLabelBMFont *earnedText = [CCLabelBMFont labelWithString:@"You didn't earn a badge this time,\nbetter luck next time!" fntFile:@"MenuFont.fnt"];
    earnedText.position = ccp(SL_EARNED_LABEL_X, SL_EARNED_LABEL_Y);
    earnedText.anchorPoint = ccp(0, 0.5f);
    [self addChild:earnedText];    
    [[AudioManager audioManager] playSoundEffect:kWahWah];
}

- (void) placeBadge
{
    NSString *spriteName;
    NSString *badgeName;
    
    switch (scoreInfo_.difficulty) {
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
    
    CCLabelBMFont *earnedText = [CCLabelBMFont labelWithString:@"You earned" fntFile:@"MenuFont.fnt"];
    earnedText.position = ccp(SL_EARNED_LABEL_X, SL_EARNED_LABEL_Y);
    earnedText.anchorPoint = ccp(0, 0.5f);
    [self addChild:earnedText];      
    
    CCLabelBMFont *badgeText = [CCLabelBMFont labelWithString:badgeName fntFile:@"Dialogue Font.fnt"];
    badgeText.anchorPoint = ccp(0, 0.5f);
    badgeText.position = ccp(SL_BADGE_LABEL_X, SL_BADGE_LABEL_Y);
    [self addChild:badgeText];    
    
    CCSprite *sprite = [CCSprite spriteWithFile:spriteName];
    sprite.position = ccp(SL_BADGE_X, SL_BADGE_Y);
    sprite.opacity = 0;
    [self addChild:sprite];
 
    CCParticleSystem *ps = [self createBadgePS];
    ps.position = ccp(SL_BADGE_X, SL_BADGE_Y);
    [self addChild:ps];
    
    [[AudioManager audioManager] playSoundEffect:kSuccess];
    CCActionInterval *fadeIn = [CCFadeIn actionWithDuration:1.5f];
    [sprite runAction:fadeIn];
    
    particles_ = [[self createPS] retain];
    [self addChild:particles_];
}

- (CCParticleSystem *) createBadgePS
{
    CCParticleSystem *particle=[[[CCParticleSystemQuad alloc] initWithTotalParticles:1500] autorelease];
    ///////**** Assignment Texture Filename!  ****///////
    CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"Star.png"];
    particle.texture=texture;
    particle.emissionRate=1500;
    particle.angle=90.0;
    particle.angleVar=360.0;
    ccBlendFunc blendFunc={GL_SRC_ALPHA,GL_ONE};
    particle.blendFunc=blendFunc;
    particle.duration=0.01;
    particle.emitterMode=kCCParticleModeGravity;
    ccColor4F startColor={0.86,0.57,0.42,1.00};
    particle.startColor=startColor;
    ccColor4F startColorVar={0.00,0.00,0.00,0.00};
    particle.startColorVar=startColorVar;
    ccColor4F endColor={0.00,0.00,0.00,1.00};
    particle.endColor=endColor;
    ccColor4F endColorVar={0.00,0.00,0.00,0.00};
    particle.endColorVar=endColorVar;
    particle.startSize=0.00;
    particle.startSizeVar=0.00;
    particle.endSize=20.00;
    particle.endSizeVar=0.00;
    particle.gravity=ccp(2.00,10.00);
    particle.radialAccel=0.00;
    particle.radialAccelVar=10.00;
    particle.speed=60;
    particle.speedVar= 0;
    particle.tangentialAccel= 0;
    particle.tangentialAccelVar=10;
    particle.totalParticles=1500;
    particle.life=0.00;
    particle.lifeVar=1.20;
    particle.startSpin=0.00;
    particle.startSpinVar=0.00;
    particle.endSpin=0.00;
    particle.endSpinVar=0.00;
    particle.position=ccp(0.00, 0.00);
    particle.posVar=ccp(0.00,0.00);
    
    return particle;
}

- (CCParticleSystem *) createPS
{
    CCParticleSystem *particle=[[[CCParticleSystemQuad alloc] initWithTotalParticles:700] autorelease];
    ///////**** Assignment Texture Filename!  ****///////
    CCTexture2D *texture=[[CCTextureCache sharedTextureCache] addImage:@"Star.png"];
    particle.texture=texture;
    particle.emissionRate=400.00;
    particle.angle=90.0;
    particle.angleVar=20.0;
    ccBlendFunc blendFunc={GL_SRC_ALPHA,GL_SRC_ALPHA_SATURATE};
    particle.blendFunc=blendFunc;
    particle.duration=-1.00;
    particle.emitterMode=kCCParticleModeGravity;
    ccColor4F startColor={0.50,0.50,0.50,1.00};
    particle.startColor=startColor;
    ccColor4F startColorVar={1.00,1.00,1.00,1.00};
    particle.startColorVar=startColorVar;
    ccColor4F endColor={0.10,0.10,0.10,0.20};
    particle.endColor=endColor;
    ccColor4F endColorVar={1.00,1.00,1.00,0.20};
    particle.endColorVar=endColorVar;
    particle.startSize=7.79;
    particle.startSizeVar=2.00;
    particle.endSize=-1.00;
    particle.endSizeVar=0.00;
    particle.gravity=ccp(0.00,-90.00);
    particle.radialAccel=0.00;
    particle.radialAccelVar=0.00;
    particle.speed= 0;
    particle.speedVar=26;
    particle.tangentialAccel= 0;
    particle.tangentialAccelVar= 0;
    particle.totalParticles=700;
    particle.life=6.50;
    particle.lifeVar=1.00;
    particle.startSpin=0.00;
    particle.startSpinVar=0.00;
    particle.endSpin=0.00;
    particle.endSpinVar=0.00;
    particle.position=ccp(512.0f,800.0f);
    particle.posVar=ccp(600.0f,0.00);

    return particle;
}

@end
