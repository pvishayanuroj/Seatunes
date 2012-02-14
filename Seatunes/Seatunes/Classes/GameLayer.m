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
#import "CCNode+PauseResume.h"
#import "GameLogic.h"
#import "GameLogicA.h"
#import "GameLogicB.h"
#import "GameLogicC.h"
#import "Menu.h"
#import "Button.h"
#import "Utility.h"
#import "DataUtility.h"

@implementation GameLayer

const static CGFloat GL_INSTRUCTOR_X = 200.0f;
const static CGFloat GL_INSTRUCTOR_Y = 550.0f;
const static CGFloat GL_KEYBOARD_X = 100.0f;
const static CGFloat GL_KEYBOARD_Y = 100.0f;

const static CGFloat GL_SIDEMENU_BUTTON_X = 970.0f;
const static CGFloat GL_SIDEMENU_BUTTON_Y = 720.0f;
const static CGFloat GL_SIDEMENU_ROTATION = 180.0f;
const static CGFloat GL_SIDEMENU_X = 1130.0f;
const static CGFloat GL_SIDEMENU_Y = 550.0f;
const static CGFloat GL_SIDEMENU_MOVE_TIME = 0.5f;
const static CGFloat GL_SIDEMENU_MOVE_AMOUNT = 200.0f;

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
        [self addChild:sideMenuButton_];
        
        sideMenu_ = [[Menu menu:150.0f isVertical:YES offset:15.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ccp(GL_SIDEMENU_X, GL_SIDEMENU_Y);
        
        [sideMenu_ addMenuBackground:@"Side Menu.png" pos:ccp(0, -140.0f)];
        
        Button *nextButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Next Button.png" scale:0.9f];
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Replay Button.png" scale:0.9f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonNext image:@"Menu Button.png" scale:0.9f];        
        
        [sideMenu_ addMenuItem:nextButton];
        [sideMenu_ addMenuItem:replayButton];
        [sideMenu_ addMenuItem:menuButton];        
        
        [self addChild:sideMenu_];
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GL_INSTRUCTOR_X, GL_INSTRUCTOR_Y);
        [self addChild:instructor_ z:-1];
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.position = ccp(GL_KEYBOARD_X, GL_KEYBOARD_Y);
        [self addChild:keyboard_];
        
        switch (difficulty) {
            case kDifficultyEasy:
                gameLogic_ = [[GameLogicA gameLogicA:songName] retain];
                break;
            case kDifficultyMedium:
                gameLogic_ = [[GameLogicB gameLogicB:songName] retain];
                break;
            case kDifficultyHard:
                gameLogic_ = [[GameLogicC gameLogicC:songName] retain];
                break;
            default:
                gameLogic_ = nil;
                break;
        }
        
        gameLogic_.delegate = self; 
        [gameLogic_ setInstructor:instructor_];
        [gameLogic_ setKeyboard:keyboard_];
        [self addChild:gameLogic_];
    }
    return self;
}

- (void) dealloc
{
    [gameLogic_ release];
    [instructor_ release];
    [keyboard_ release];
    [processor_ release];
    [sideMenu_ release];
    [sideMenuButton_ release];
    [songName_ release];
    
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [keyboard_ touchesBegan:touches];
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {    
        [keyboard_ touchesMoved:touches];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!isPaused_) {
        [keyboard_ touchesEnded:touches];
    }
}

- (void) songComplete:(ScoreInfo)scoreInfo
{
    [DataUtility saveSongScore:songName_ score:scoreInfo.score];
    
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty_];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
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
    switch (button.numID) {
        case kButtonNext:
            break;
        case kButtonReplay:
            break;
        case kButtonMenu:
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

- (void) pauseGame
{
    isPaused_ = YES;
    keyboard_.isClickable = NO;
    [gameLogic_ pauseHierarchy];
    [instructor_ pauseHierarchy];
    [keyboard_ pauseHierarchy];
}

- (void) resumeGame
{
    isPaused_ = NO;
    [gameLogic_ resumeHierarchy];
    [instructor_ resumeHierarchy];
    [keyboard_ resumeHierarchy];
}

@end
