//
//  FreePlayLayer.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuDelegate.h"
#import "ButtonDelegate.h"

@class Instructor;
@class Keyboard;
@class NoteGenerator;
@class Menu;
@class Button;

@interface FreePlayLayer : CCLayer <MenuDelegate, ButtonDelegate> {
    
    NoteGenerator *noteGenerator_;
    
    Instructor *instructor_;
    
    Keyboard *keyboard_;    
    
    Menu *sideMenu_;
    
    Button *sideMenuButton_;    
    
    BOOL sideMenuOpen_;
    
    BOOL sideMenuLocked_;
    
    BOOL sideMenuMoving_;
    
    BOOL isPaused_;    
    
}

- (void) menuSelection:(Button *)button;

- (void) showSideMenu;

- (void) hideSideMenu;

- (void) pauseGame;

- (void) resumeGame;

@end
