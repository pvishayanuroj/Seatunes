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
#import "ScoreLayerDelegate.h"

@class Keyboard;
@class Instructor;
@class Processor;
@class Menu;
@class Button;
@class GameLogic;
@class ScoreLayer;

@interface GameLayer : CCLayer <MenuDelegate, ButtonDelegate, GameLogicDelegate, ScoreLayerDelegate> {
 
    GameLogic *gameLogic_;
    
    Instructor *instructor_;
    
    Keyboard *keyboard_;
    
    Processor *processor_;
    
    Menu *sideMenu_;
    
    Button *sideMenuButton_;
    
    NSString *songName_;
    
    DifficultyType difficulty_;
    
    BOOL sideMenuOpen_;
    
    BOOL sideMenuLocked_;
    
    BOOL sideMenuMoving_;
    
    BOOL isPaused_;
}

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName;

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName;

- (void) menuSelection:(Button *)button;

- (void) showSideMenu;

- (void) hideSideMenu;

- (void) showScoreMenu:(ScoreInfo)scoreInfo;

- (void) pauseGame;

- (void) resumeGame;

@end
