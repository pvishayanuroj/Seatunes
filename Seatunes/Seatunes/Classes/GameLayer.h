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
#import "KeyboardDelegate.h"
#import "MenuDelegate.h"
#import "ButtonDelegate.h"

@class Keyboard;
@class Instructor;
@class Processor;
@class Menu;
@class Button;
@class GameLogic;

enum {
    kButtonSideMenu,
    kButtonNext,
    kButtonReplay,
    kButtonMenu
};

@interface GameLayer : CCLayer <KeyboardDelegate, MenuDelegate, ButtonDelegate> {
 
    GameLogic *gameLogic_;
    
    Instructor *instructor_;
    
    Keyboard *keyboard_;
    
    Processor *processor_;
    
    Menu *sideMenu_;
    
    Button *sideMenuButton_;
    
    BOOL sideMenuOpen_;
    
    BOOL sideMenuLocked_;
    
    BOOL sideMenuMoving_;
    
    BOOL isPaused_;
}

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName;

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName;

- (void) showSideMenu;

- (void) hideSideMenu;

- (void) pauseGame;

- (void) resumeGame;

@end
