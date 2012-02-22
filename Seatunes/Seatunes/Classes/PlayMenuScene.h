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

@class ScrollingMenu;

enum {
    kScrollingMenuPack,
    kScrollingMenuSong
};
typedef NSUInteger ScrollingMenuType;

@interface PlayMenuScene : CCScene <ScrollingMenuDelegate> {
    
    ScrollingMenu *scrollingMenu_;
    
    ScrollingMenu *packMenu_;
    
    /* Maps song menu item IDs to song names */
    NSArray *songNames_;
    
    /* Maps pack menu item IDs to pack names */
    NSArray *packNames_;
}

- (NSArray *) loadSongNames:(NSString *)packName;

- (void) togglePackSelect:(NSUInteger)packIndex;

- (void) loadPackMenu;

- (void) loadSongMenu:(PackType)packType;

- (void) loadDifficultyMenu:(NSString *)songName;

- (void) cleanupSongMenu;

- (void) cleanupPackMenu;

@end
