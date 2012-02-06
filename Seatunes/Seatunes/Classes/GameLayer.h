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

enum {
    kButtonSideMenu,
    kButtonNext,
    kButtonReplay,
    kButtonMenu
};

@interface GameLayer : CCLayer <KeyboardDelegate, MenuDelegate, ButtonDelegate> {
 
    Instructor *instructor_;
    
    Keyboard *keyboard_;
    
    Processor *processor_;
    
    Menu *sideMenu_;
    
    Button *sideMenuButton_;
    
    BOOL sideMenuOpen_;
    
    BOOL sideMenuLocked_;
    
    BOOL sideMenuMoving_;
}

+ (id) start;

- (id) init;

- (void) showSideMenu;

- (void) hideSideMenu;

@end
