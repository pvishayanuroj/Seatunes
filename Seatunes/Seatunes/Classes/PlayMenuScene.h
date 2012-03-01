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
@class Button;
@class LoadingIndicator;

enum {
    kScrollingMenuPack,
    kScrollingMenuSong,
    kButtonBuyAllPacks,
    kButtonBuyCurrentPack
};

typedef enum {
    kStateNoPurchase,
    kStateBuyAllPacks,
    kStateBuyCurrentPack
} BuyState;

@interface PlayMenuScene : CCScene <ScrollingMenuDelegate, ButtonDelegate, UIAlertViewDelegate> {
    
    ScrollingMenu *scrollingMenu_;
    
    ScrollingMenu *packMenu_;
    
    CCLabelBMFont *packTitle_;
    
    Button *allPacksButton_;
    
    Button *packButton_;
    
    NSString *currentPack_;
    
    /* Maps song menu item IDs to song names */
    NSArray *songNames_;
    
    /* Maps pack menu item IDs to pack names */
    NSArray *packNames_;
    
    BuyState buyState_;
    
    NSString *productIdentifierToBuy_;

    LoadingIndicator *loadingIndicator_;

}

@property (nonatomic, retain) NSString *currentPack;

- (void) buyProduct:(BuyState)buyState;

- (void) togglePackSelect:(NSUInteger)packIndex;

- (void) loadPackMenu;

- (void) loadSongMenu:(NSString *)packName;

- (void) loadDifficultyMenu:(NSString *)songName;

- (void) cleanupSongMenu;

- (void) cleanupPackMenu;

- (void) showDialog:(NSString *)title text:(NSString *)text;

- (void) showLoading;

- (void) finishLoading;

@end
