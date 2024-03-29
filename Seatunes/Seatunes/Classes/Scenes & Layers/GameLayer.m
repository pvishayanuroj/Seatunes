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
#import "Staff.h"
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
#import "Apsalar.h"

@implementation GameLayer

static const CGFloat GL_SIDEMENU_BUTTON_X = 970.0f;
static const CGFloat GL_SIDEMENU_BUTTON_Y = 720.0f;
static const CGFloat GL_SIDEMENU_BUTTON_X_M = 454.0f;
static const CGFloat GL_SIDEMENU_BUTTON_Y_M = 295.0f;
static const CGFloat GL_SIDEMENU_BUTTON_LABEL_X = 970.0f;
static const CGFloat GL_SIDEMENU_BUTTON_LABEL_Y = 670.0f;
static const CGFloat GL_SIDEMENU_BUTTON_LABEL_X_M = 454.0f;
static const CGFloat GL_SIDEMENU_BUTTON_LABEL_Y_M = 274.2f;
static const CGFloat GL_HELP_BUTTON_X = 850.0f;
static const CGFloat GL_HELP_BUTTON_Y = 730.0f;
static const CGFloat GL_HELP_BUTTON_X_M = 398.4f;
static const CGFloat GL_HELP_BUTTON_Y_M = 302.0f;
static const CGFloat GL_HELP_BUTTON_LABEL_X = 850.0f;
static const CGFloat GL_HELP_BUTTON_LABEL_Y = 690.0f;
static const CGFloat GL_HELP_BUTTON_LABEL_X_M = 398.4f;
static const CGFloat GL_HELP_BUTTON_LABEL_Y_M = 285.0f;

static const CGFloat GL_SIDEMENU_ROTATION = 180.0f;
static const CGFloat GL_SIDEMENU_ITEM_PADDING = 150.0f;
static const CGFloat GL_SIDEMENU_ITEM_PADDING_M = 78.0f;
static const CGFloat GL_SIDEMENU_X = 1150.0f;
static const CGFloat GL_SIDEMENU_Y = 450.0f;
static const CGFloat GL_SIDEMENU_SPRITE_Y = -70.0f;
static const CGFloat GL_SIDEMENU_MOVE_TIME = 0.5f;
static const CGFloat GL_SIDEMENU_MOVE_AMOUNT = 200.0f;

#pragma mark - Object Lifecycle

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    return [[[self alloc] initWithDifficulty:difficulty songName:songName packIndex:packIndex] autorelease];
}

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex
{
    if ((self = [super init])) {
        
        [[AudioManager audioManager] pauseBackgroundMusic];
        
        self.isTouchEnabled = YES;
        helpOn_ = NO;
        helpClickable_ = YES;
        sideMenuOpen_ = NO;
        sideMenuLocked_ = NO;
        sideMenuMoving_ = NO;
        isPaused_ = NO;
        songName_ = [songName retain];
        packIndex_ = packIndex;
        difficulty_ = difficulty;
        helpButton_ = nil;
        
        sideMenuButton_ = [[ImageButton imageButton:kButtonSideMenu unselectedImage:@"Starfish Button.png" selectedImage:@"Starfish Button.png"] retain];
        sideMenuButton_.delegate = self;
        sideMenuButton_.position = CHOOSE_REL_CCP(ccp(GL_SIDEMENU_BUTTON_X, GL_SIDEMENU_BUTTON_Y), ccp(GL_SIDEMENU_BUTTON_X_M, GL_SIDEMENU_BUTTON_Y_M));

        sideMenu_ = [[Menu menu:CHOOSE_REL_CCP(GL_SIDEMENU_ITEM_PADDING, GL_SIDEMENU_ITEM_PADDING_M) isVertical:YES offset:0.0f] retain];
        sideMenu_.delegate = self; 
        sideMenu_.position = ADJUST_IPAD_CCP(ccp(GL_SIDEMENU_X, GL_SIDEMENU_Y));
        
        [sideMenu_ addMenuBackground:@"Side Parchment.png" pos:ADJUST_IPAD_CCP(ccp(0, GL_SIDEMENU_SPRITE_Y))];
        
        Button *replayButton = [ScaledImageButton scaledImageButton:kButtonReplay image:@"Restart Button.png" scale:0.9f];
        Button *menuButton = [ScaledImageButton scaledImageButton:kButtonMenu image:@"Home Button.png" scale:0.9f];        
        
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
                helpButton_ = [[ScaledImageButton scaledImageButton:kButtonHelp image:@"Help Button.png" scale:0.8f] retain];
                helpButton_.position = CHOOSE_REL_CCP(ccp(GL_HELP_BUTTON_X, GL_HELP_BUTTON_Y), ccp(GL_HELP_BUTTON_X_M, GL_HELP_BUTTON_Y_M));
                helpButton_.delegate = self;                
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
        
        if (helpButton_) {
            [self addChild:helpButton_];   
            CCLabelBMFont *helpLabel = [CCLabelBMFont labelWithString:@"Help" fntFile:@"MenuFont.fnt"];
            helpLabel.position = CHOOSE_REL_CCP(ccp(GL_HELP_BUTTON_LABEL_X, GL_HELP_BUTTON_LABEL_Y), ccp(GL_HELP_BUTTON_LABEL_X_M, GL_HELP_BUTTON_LABEL_Y_M));
            [self addChild:helpLabel];            
        }
        [self addChild:sideMenuButton_];        
        [self addChild:sideMenu_];         
        
        CCLabelBMFont *menuLabel = [CCLabelBMFont labelWithString:@"Menu" fntFile:@"MenuFont.fnt"];
        menuLabel.position = CHOOSE_REL_CCP(ccp(GL_SIDEMENU_BUTTON_LABEL_X, GL_SIDEMENU_BUTTON_LABEL_Y), ccp(GL_SIDEMENU_BUTTON_LABEL_X_M, GL_SIDEMENU_BUTTON_LABEL_Y_M));
        [self addChild:menuLabel];
    }
    return self;
}

- (void) dealloc
{
    [gameLogic_ release];
    [sideMenu_ release];
    [sideMenuButton_ release];
    [songName_ release];
    [helpButton_ release];
    
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
    [[AudioManager audioManager] resumeBackgroundMusic];
    
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty_];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];    
    
    CCScene *scene = [PlayMenuScene playMenuScene:1];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];  
    
#if ANALYTICS_ON  
    [Apsalar event:@"MusicTutorialComplete"];
#endif    
}

- (void) lastNotePlayed
{
    helpClickable_ = NO;
}

- (void) songComplete:(ScoreInfo)scoreInfo 
{    
    // Record that this difficulty has been played, and record that at least the first song has been played
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty_];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kFirstPlay];
    
    [self showScoreMenu:scoreInfo];
    
#if ANALYTICS_ON  
    [Apsalar event:@"SongComplete"];
#endif      
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonHelp:
            if (!gameLogic_.keyboard.isHelpMoving && helpClickable_) {
                [[AudioManager audioManager] playSound:kC4 instrument:kMenu];                
                if (helpOn_) {
                    [self helpOff];
                }
                else {
                    [self helpOn];
                }
            }
            else {
                [[AudioManager audioManager] playSound:kC4 instrument:kMuted];
            }
            break;
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

- (void) showKeyboardLettersComplete
{
    /*
    NSString *text = @"Practice Mode On!\nBadges Disabled";
    CCLabelBMFont *msg = [CCLabelBMFont labelWithString:text fntFile:@"MenuFont.fnt"];
    CGSize size = [[CCDirector sharedDirector] winSize];
    msg.position = ccp(size.width * 0.5f, size.height * 0.5f);
    [self addChild:msg];
     */
}

- (void) hideKeyboardLettersComplete
{
    
}

#pragma mark - Helper Methods

- (void) menuSelection:(Button *)button
{
    CCScene *scene;
    switch (button.numID) {
        case kButtonReplay:
            [[AudioManager audioManager] playSound:kE4 instrument:kMenu];
            scene = [GameScene startWithDifficulty:difficulty_ songName:songName_ packIndex:packIndex_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                             
            break;
        case kButtonMenu:
            [[AudioManager audioManager] playSound:kE4 instrument:kMenu];            
            scene = [PlayMenuScene playMenuScene:packIndex_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];   
            if ([DataUtility manager].backgroundMusicOn) {
                [[AudioManager audioManager] resumeBackgroundMusic];            
            }
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
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ADJUST_IPAD_CCP(ccp(-GL_SIDEMENU_MOVE_AMOUNT, 0))];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneShowSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle:-GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:8];
        NSMutableArray *tones = [NSMutableArray arrayWithCapacity:4];
        
        [tones addObject:[NSNumber numberWithInteger:kC4]];
        [tones addObject:[NSNumber numberWithInteger:kE4]];
        [tones addObject:[NSNumber numberWithInteger:kG4]];
        [tones addObject:[NSNumber numberWithInteger:kC5]];        
        
        for (NSNumber *tone in tones) {
            CCActionInstant *sound = [CCCallBlock actionWithBlock:^{
                [[AudioManager audioManager] playSound:[tone integerValue] instrument:kMenu];
            }];
            CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];
            [actions addObject:sound];
            [actions addObject:delay];
        }
        
        [self runAction:[CCSequence actionsWithArray:actions]];
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
        
        CCActionInterval *move = [CCMoveBy actionWithDuration:GL_SIDEMENU_MOVE_TIME position:ADJUST_IPAD_CCP(ccp(GL_SIDEMENU_MOVE_AMOUNT, 0))];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneHideSideMenu)];
        [sideMenu_ runAction:[CCSequence actions:move, done, nil]];    
        
        CCActionInterval *spin = [CCRotateBy actionWithDuration:GL_SIDEMENU_MOVE_TIME angle: GL_SIDEMENU_ROTATION];
        [sideMenuButton_ runAction:spin];     
        
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:8];
        NSMutableArray *tones = [NSMutableArray arrayWithCapacity:4];
        
        [tones addObject:[NSNumber numberWithInteger:kC5]];
        [tones addObject:[NSNumber numberWithInteger:kG4]];
        [tones addObject:[NSNumber numberWithInteger:kE4]];
        [tones addObject:[NSNumber numberWithInteger:kC4]];        
        
        for (NSNumber *tone in tones) {
            CCActionInstant *sound = [CCCallBlock actionWithBlock:^{
                [[AudioManager audioManager] playSound:[tone integerValue] instrument:kMenu];
            }];
            CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];
            [actions addObject:sound];
            [actions addObject:delay];
        }
        
        [self runAction:[CCSequence actionsWithArray:actions]];        
    }
}

- (void) doneHideSideMenu
{
    sideMenuMoving_ = NO;
    sideMenuOpen_ = NO;    
}

- (void) showScoreMenu:(ScoreInfo)scoreInfo 
{
    CCScene *scene = [ScoreScene scoreScene:scoreInfo songName:songName_ packIndex:packIndex_];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];                            
}

- (void) helpOn
{
    [gameLogic_.keyboard showLetters];
    gameLogic_.staff.showName = YES;
    helpOn_ = YES;
}

- (void) helpOff
{
    [gameLogic_.keyboard hideLetters];
    gameLogic_.staff.showName = NO;
    helpOn_ = NO;
}

- (void) pauseGame
{
    isPaused_ = YES;
    if (helpButton_) {
        helpButton_.isClickable = NO;
    }
    [gameLogic_ pauseHierarchy];
    [[AudioManager audioManager] pause];
}

- (void) resumeGame
{
    isPaused_ = NO;
    if (helpButton_) {
        helpButton_.isClickable = YES;
    }
    [gameLogic_ resumeHierarchy];
    [[AudioManager audioManager] resume];
}

@end
