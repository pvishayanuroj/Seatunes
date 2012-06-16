//
//  DifficultyMenuScene.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/13/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "IAPDelegate.h"

@class Button;
@class StarfishButton;
@class LoadingIndicator;

enum {
    kDMSEasy,
    kDMSMedium,
    kDMSHard,
    kDMSPlay,
    kDMSBack
};

@interface DifficultyMenuScene : CCScene <ButtonDelegate, IAPDelegate> {
    
    NSString *songName_;
    
    NSUInteger packIndex_;
    
    Button *easyButton_;
    
    Button *mediumButton_;
    
    Button *hardButton_;    
    
    Button *backButton_;
    
    StarfishButton *playButton_;    
    
    CCLabelBMFont *easyText_;
    
    CCLabelBMFont *mediumText_;
    
    CCLabelBMFont *hardText_;    
    
    DifficultyType difficulty_;
    
    CCSprite *lockIcon_;
    
    LoadingIndicator *loadingIndicator_;    
}

+ (id) startWithSongName:(NSString *)songName packIndex:(NSUInteger)packIndex;

- (id) initWithSongName:(NSString *)songName packIndex:(NSUInteger)packIndex;

- (void) startSong;

- (void) playMenu;

@end
