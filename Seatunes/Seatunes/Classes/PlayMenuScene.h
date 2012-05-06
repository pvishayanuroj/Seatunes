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
    kButtonBuyCurrentPack,
    kButtonBack
};

typedef enum {
    kStateNoPurchase,
    kStateBuyAllPacks,
    kStateBuyCurrentPack
} BuyState;

@interface PlayMenuScene : CCScene <ScrollingMenuDelegate, ButtonDelegate, UIAlertViewDelegate> {
    
    ScrollingMenu *songMenu_;
    
    ScrollingMenu *packMenu_;
    
    CCLabelBMFont *packTitle_;
    
    Button *allPacksButton_;
    
    Button *packButton_;
    
    NSUInteger currentPack_;
    
    //NSString *currentPack_;
    
    /* Maps song menu item IDs to song names */
    NSArray *songNames_;
    
    /* Maps pack menu item IDs to pack names */
    NSArray *packNames_;
    
    BuyState buyState_;

    LoadingIndicator *loadingIndicator_;

    CCSprite *packUpArrow_;
    
    CCSprite *packDownArrow_;
}

//@property (nonatomic, retain) NSString *currentPack;
@property (nonatomic, readonly) NSUInteger currentPack;

+ (id) playMenuScene;

+ (id) playMenuScene:(NSUInteger)packIndex;

- (id) initPlayMenuScene:(NSUInteger)packIndex;

- (void) buyProduct:(BuyState)buyState;

- (void) togglePackSelect:(NSUInteger)packIndex;

- (void) loadPackMenu;

- (void) loadSongMenu:(NSUInteger)packIndex;

- (void) reloadScreen;

- (void) addBuyAllButton;

- (void) removeBuyAllButton;

- (void) loadMainMenu;

- (void) loadSong:(NSString *)songName;

- (void) cleanupSongMenu;

- (void) cleanupPackMenu;

- (void) showDialog:(NSString *)title text:(NSString *)text;

- (void) showBuyDialog;

- (void) showLoading;

- (void) finishLoading;

@end
