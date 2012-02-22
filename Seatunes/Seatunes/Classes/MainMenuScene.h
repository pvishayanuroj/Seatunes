//
//  MainMenuScene.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/28/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"

enum {
    kPlayButton,
    kBuySongsButton,
    kCreditsButton
};

@class Button;

@interface MainMenuScene : CCScene <ButtonDelegate> {
    
}

@end
