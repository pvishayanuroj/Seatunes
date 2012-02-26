//
//  PlayMenuScene.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingMenuDelegate.h"
#import "ButtonDelegate.h"

@class ScrollingMenu;

enum {
    kScrollingMenuPack,
    kScrollingMenuSong
};
typedef NSUInteger ScrollingMenuType;

@interface PlayMenuScene : CCScene <ScrollingMenuDelegate, ButtonDelegate> {
    
    ScrollingMenu *scrollingMenu_;
    
    ScrollingMenu *packMenu_;
    
    CCLabelBMFont *packTitle_;
    
    NSString *currentPack_;
    
    /* Maps song menu item IDs to song names */
    NSArray *songNames_;
    
    /* Maps pack menu item IDs to pack names */
    NSArray *packNames_;
}

@property (nonatomic, retain) NSString *currentPack;

- (void) togglePackSelect:(NSUInteger)packIndex;

- (void) loadPackMenu;

- (void) loadSongMenu:(NSString *)packName;

- (void) loadDifficultyMenu:(NSString *)songName;

- (void) cleanupSongMenu;

- (void) cleanupPackMenu;

@end
