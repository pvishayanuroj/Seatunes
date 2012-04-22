//
//  GameLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "Keyboard.h"
#import "AudioManager.h"
#import "Note.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "CCNode+PauseResume.h"
#import "GameLogic.h"
#import "GameLogicD.h"
#import "GameLogicE.h"
#import "GameLogicF.h"
#import "MusicNoteTutorial.h"
#import "Menu.h"
#import "Button.h"
#import "Utility.h"
#import "DataUtility.h"
#import "GameScene.h"
#import "PlayMenuScene.h"
#import "ScoreScene.h"

@implementation GameLayer

static const CGFloat GL_SIDEMENU_BUTTON_X = 970.0f;
static const CGFloat GL_SIDEMENU_BUTTON_Y = 720.0f;
static const CGFloat GL_SIDEMENU_ROTATION = 180.0f;
static const CGFloat GL_SIDEMENU_X = 1130.0f;
static const CGFloat GL_SIDEMENU_Y = 550.0f;
static const CGFloat GL_SIDEMENU_MOVE_TIME = 0.5f;
static const CGFloat GL_SIDEMENU_MOVE_AMOUNT = 200.0f;

static const CGFloat GL_SCOREMENU_X = 0.0f;
static const CGFloat GL_SCOREMENU_Y = -430.0f;
static const CGFloat GL_SCOREMENU_MOVE_TIME = 0.4f;

#pragma mark - Object Lifecycle

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName
{
    return [[[self alloc] initWithDifficulty:difficulty songName:songName] autorelease];
}

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        sideMenuOpen_ = NO;
        sideMenuLocked_ = NO;
        sideMenuMoving_ = NO;
        isPaused_ = NO;
        songName_ = [songName retain];
        difficulty_ = difficulty;
        [AudioManager audioManager];
        
        sideMenuButton_ = [[ImageButton imageButton:kButtonSideMenu unselectedImage:@"Starfish Button.png" selectedImage:@"Starfish Button.png"] retain];
        sideMenuButton_.delegate = self;
        sideMenuButton_.position = ccp(GL_SIDEMENU_BUTTON_X, GL_SIDEMENU_BUTTON_Y);
        
        sideMenu_ = [[Menu menu:150.0f isVertical:YES offset:15.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ccp(GL_SIDEMENU_X, GL_SIDEMENU_Y);
        
        [sideMenu_ addMenuBackground:@"Side Parchment.png" pos:ccp(0, -140.0f)];
        
        //Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.9f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Restart Button.png" scale:0.9f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.9f];        
        
        //[sideMenu_ addMenuItem:nextButton];
        [sideMenu_ addMenuItem:replayButton];
        [sideMenu_ addMenuItem:menuButton];        

        switch (difficulty) {
            case kDifficultyEasy:
                gameLogic_ = [[GameLogicD gameLogicD:songName] retain];
                break;
            case kDifficultyMedium:
                gameLogic_ = [[GameLogicF gameLogicF:songName] retain];
                break;
            case kDifficultyHard:
                gameLogic_ = [[GameLogicE gameLogicE:songName] retain];            
                break;
            case kDifficultyMusicNoteTutorial:
                gameLogic_ = [[MusicNoteTutorial musicNoteTutorial] retain];    
                break;
            default:
                gameLogic_ = nil;
                break;
        }

        gameLogic_.delegate = self; 
        [self addChild:gameLogic_];  
        
        [self addChild:sideMenuButton_];        
        [self addChild:sideMenu_];        
    }
    return self;
}

- (void) dealloc
{
    [gameLogic_ release];
    [sideMenu_ release];
    [sideMenuButton_ release];
    [songName_ release];
    
    [super dealloc];
}

#pragma mark - Touch Handlers

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [gameLogic_ touchesBegan:touches];
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {    
        [gameLogic_ touchesMoved:touches];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [gameLogic_ touchesEnded:touches];
    }
}

#pragma mark - Delegate Methods

- (void) exerciseComplete
{
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty_];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];    
    
    CCScene *scene = [PlayMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];     
}

- (void) songComplete:(ScoreInfo)scoreInfo
{
    if (scoreInfo.notesMissed == 0) {
        [[DataUtility manager] saveSongScore:songName_ difficulty:difficulty_];
    }
    
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty_];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstPlay];
    
    [self showScoreMenu:scoreInfo];
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonSideMenu:
            if (!sideMenuLocked_) {
                if (sideMenuOpen_) {
                    [self hideSideMenu];                    
                }
                else {
                    [self showSideMenu];
                }
            }
            break;
        default:
            break;
    }
}

- (void) menuItemSelected:(Button *)button
{
    [self menuSelection:button];
}

#pragma mark - Helper Methods

- (void) menuSelection:(Button *)button
{
    CCScene *scene;
    switch (button.numID) {
        case kButtonNext:
            break;
        case kButtonReplay:
            scene = [GameScene startWithDifficulty:difficulty_ songName:songName_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                             
            break;
        case kButtonMenu:
            scene = [PlayMenuScene node];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                        
            break;
        default:
            break;
    }    
}

- (void) showSideMenu
{ 
    if (!sideMenuMoving_) {
        sideMenuMoving_ = YES;
        
        [self pauseGame];
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ccp(-GL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneShowSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle:-GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];
    }
}

- (void) doneShowSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = YES;
}

- (void) hideSideMenu
{
    if (!sideMenuMoving_) {        
        sideMenuMoving_ = YES;
        
        [self resumeGame];
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ccp(GL_SIDEMENU_MOVE_AMOUNT, 0)];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneHideSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];    
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle: GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];        
    }
}

- (void) doneHideSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = NO;    
}

- (void) showScoreMenu:(ScoreInfo)scoreInfo 
{
    CCScene *scene = [ScoreScene scoreScene:scoreInfo songName:songName_ nextSong:@""];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                            
}

- (void) pauseGame
{
    isPaused_ = YES;
    [gameLogic_ pauseHierarchy];
    [[AudioManager audioManager] pause];
}

- (void) resumeGame
{
    isPaused_ = NO;
    [gameLogic_ resumeHierarchy];
    [[AudioManager audioManager] resume];
}

@end
