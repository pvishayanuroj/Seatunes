//
//  LittleOceanScene.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/18/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "AudioManagerDelegate.h"
#import "CharacterAvatarDelegate.h"

@class CharacterAvatar;

enum {
    kLOSBack,
    kLOSAppStore
};

@interface LittleOceanScene : CCScene <ButtonDelegate, AudioManagerDelegate, CharacterAvatarDelegate> {
    
    CharacterAvatar *avatar_;
    
    BOOL introPlaying_;
    
    BOOL narrationPlaying_;
}

- (void) playRandomSpeech;

- (void) loadMainMenu;

- (void) loadAppStore;

@end
