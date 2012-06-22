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
#import "IAPDelegate.h"

enum {
    kPlayButton,
    kFreePlayButton,
    kMoreButton,
    kCreditsButton,
    kSettingsButton,
    kMusicButton
};

@class ScaledImageButton;
@class Button;
@class LoadingIndicator;

@interface MainMenuScene : CCScene <ButtonDelegate, IAPDelegate> {
 
    Button *freePlayButton_;
    
    Button *playButton_;
    
    Button *moreButton_;
    
    Button *creditsButton_;
    
    Button *settingsButton_;
    
    ScaledImageButton *musicButton_;
    
    LoadingIndicator *loadingIndicator_;    
    
    CCSprite *lockIcon_;
    
}

@end
