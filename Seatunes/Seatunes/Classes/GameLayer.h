//
//  GameLayer.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuDelegate.h"
#import "ButtonDelegate.h"
#import "GameLogicDelegate.h"

@class Keyboard;
@class Instructor;
@class Menu;
@class Button;
@class ScaledImageButton;
@class GameLogic;
@class ScoreLayer;
@class NoteGenerator;

@interface GameLayer : CCLayer <MenuDelegate, ButtonDelegate, GameLogicDelegate> {
 
    GameLogic *gameLogic_;
    
    Menu *sideMenu_;
    
    Button *sideMenuButton_;
    
    ScaledImageButton *helpButton_;
    
    NSString *songName_;
    
    NSUInteger packIndex_;
    
    DifficultyType difficulty_;
    
    BOOL helpOn_;
    
    BOOL sideMenuOpen_;
    
    BOOL sideMenuLocked_;
    
    BOOL sideMenuMoving_;
    
    BOOL isPaused_;
    
    BOOL pastKeyboardState_;
}

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex;

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex;

- (void) menuSelection:(Button *)button;

- (void) showSideMenu;

- (void) hideSideMenu;

- (void) showScoreMenu:(ScoreInfo)scoreInfo;

- (void) pauseGame;

- (void) resumeGame;

@end
