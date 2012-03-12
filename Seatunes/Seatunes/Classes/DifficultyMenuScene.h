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

@class Button;

enum {
    kDMSEasy,
    kDMSMedium,
    kDMSHard,
    kDMSPlay,
    kDMSBack
};

@interface DifficultyMenuScene : CCScene <ButtonDelegate> {
    
    NSString *songName_;
    
    Button *easyButton_;
    
    Button *mediumButton_;
    
    Button *hardButton_;    
    
    CCLabelBMFont *easyText_;
    
    CCLabelBMFont *mediumText_;
    
    CCLabelBMFont *hardText_;    
    
    DifficultyType difficulty_;
}

+ (id) startWithSongName:(NSString *)songName;

- (id) initWithSongName:(NSString *)songName;

- (void) startSong;

- (void) playMenu;

@end
