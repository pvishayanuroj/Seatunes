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
#import "MenuDelegate.h"

@interface DifficultyMenuScene : CCScene <MenuDelegate> {
    
    NSString *songName_;
    
}

+ (id) startWithSongName:(NSString *)songName;

- (id) initWithSongName:(NSString *)songName;

- (void) loadDifficultyMenu;

- (void) startSong:(DifficultyType)difficulty songName:(NSString *)songName;

@end
