//
//  PlayMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PlayMenuScene.h"
#import "MainMenuScene.h"
#import "GameScene.h"
#import "ScrollingMenu.h"
#import "Menu.h"
#import "StarfishButton.h"
#import "ScrollingMenuItem.h"
#import "SongMenuItem.h"
#import "PackMenuItem.h"
#import "Utility.h"
#import "DataUtility.h"
#import "DifficultyMenuScene.h"
#import "AudioManager.h"
#import "SeatunesIAPHelper.h"
#import "LoadingIndicator.h"
#import "Apsalar.h"

@implementation PlayMenuScene

// Parchment sprite and pack title label
static const CGFloat PMS_MENU_FRAME_X = 515.0f;
static const CGFloat PMS_MENU_FRAME_Y = 380.0f;
static const CGFloat PMS_PACK_TITLE_X = 660.0f;
static const CGFloat PMS_PACK_TITLE_Y = 630.0f;

static const CGFloat PMS_BACK_BUTTON_X = 50.0f;
static const CGFloat PMS_BACK_BUTTON_Y = 730.0f;

static const CGFloat PMS_ALL_PACKS_BUTTON_X = 150.0f;
static const CGFloat PMS_ALL_PACKS_BUTTON_Y = 90.0f;

static const CGFloat PMS_CURRENT_PACK_BUTTON_X = 450.0f;
static const CGFloat PMS_CURRENT_PACK_BUTTON_Y = 90.0f;

static const CGFloat PMS_PACK_MENU_X = 145.0f;
static const CGFloat PMS_PACK_MENU_Y = 125.0f;
static const CGFloat PMS_PACK_MENU_WIDTH = 230.0f;
static const CGFloat PMS_PACK_MENU_HEIGHT = 450.0f;
static const CGFloat PMS_PACK_DOWN_ARROW_X = 245.0f;
static const CGFloat PMS_PACK_DOWN_ARROW_Y = 110.0f;

static const CGFloat PMS_SONG_MENU_X = 370.0f;
static const CGFloat PMS_SONG_MENU_Y = 125.0f;
static const CGFloat PMS_SONG_MENU_WIDTH = 560.0f;
static const CGFloat PMS_SONG_MENU_HEIGHT = 450.0f;
static const CGFloat PMS_SONG_DOWN_ARROW_X = 650.0f;
static const CGFloat PMS_SONG_DOWN_ARROW_Y = 106.0f;

@synthesize currentPack = currentPack_;

#pragma mark - Object Lifecycle

+ (id) playMenuScene
{
    return [[[self alloc] initPlayMenuScene:0] autorelease];
}

+ (id) playMenuScene:(NSUInteger)packIndex
{
    return [[[self alloc] initPlayMenuScene:packIndex] autorelease];
}

- (id) initPlayMenuScene:(NSUInteger)packIndex
{
    if ((self = [super init])) {
        
        songMenu_ = nil;
        songNames_ = nil;        
        loadingIndicator_ = nil;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Main Parchment.png"];
        menuFrame.position = ADJUST_IPAD_CCP(ccp(PMS_MENU_FRAME_X, PMS_MENU_FRAME_Y));
        [self addChild:menuFrame];
        
        packDownArrow_ = [[CCSprite spriteWithFile:@"Down Arrow.png"] retain];
        packDownArrow_.position = ADJUST_IPAD_CCP(ccp(PMS_PACK_DOWN_ARROW_X, PMS_PACK_DOWN_ARROW_Y));
        packDownArrow_.visible = YES;
        packDownArrow_.scaleX = 0.6f;
        [self addChild:packDownArrow_];        

        songDownArrow_ = [[CCSprite spriteWithFile:@"Small Down Arrow.png"] retain];
        songDownArrow_.position = ADJUST_IPAD_CCP(ccp(PMS_SONG_DOWN_ARROW_X, PMS_SONG_DOWN_ARROW_Y));
        songDownArrow_.visible = YES;
        songDownArrow_.scale = 0.8f;
        [self addChild:songDownArrow_];                
        
        packTitle_ = [[CCLabelBMFont labelWithString:@"" fntFile:@"BoldMenuFont.fnt"] retain];
        packTitle_.position = ADJUST_IPAD_CCP(ccp(PMS_PACK_TITLE_X, PMS_PACK_TITLE_Y));
        [self addChild:packTitle_];
        
        [self loadPackMenu];        
        
        // Always show the first pack
        [self togglePackSelect:packIndex];
        [self loadSongMenu:packIndex];
        [packMenu_ setMenuOffset:packIndex];
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kDMSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ADJUST_IPAD_CCP(ccp(PMS_BACK_BUTTON_X, PMS_BACK_BUTTON_Y));
        [self addChild:backButton];        
        
        // Play the sound
        [[AudioManager audioManager] playSoundEffect:kPageFlip];
    }
    return self;    
}

- (void) dealloc
{
    [self cleanupSongMenu];  
    [self cleanupPackMenu];
    [songNames_ release];
    [packNames_ release];
    [packTitle_ release];
    [packDownArrow_ release];
    [songDownArrow_ release];
    [loadingIndicator_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonBack:
            [self loadMainMenu];
            break;
        default:
            break;
    }
}


- (void) scrollingMenuItemClicked:(ScrollingMenu *)scrollingMenu menuItem:(ScrollingMenuItem *)menuItem
{
    NSString *packName;
    
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            [self loadSong:[songNames_ objectAtIndex:menuItem.numID]];
            break;
        case kScrollingMenuPack:
            [[AudioManager audioManager] playSound:kB4 instrument:kMenu];            
            packName = [packNames_ objectAtIndex:menuItem.numID];
#if IAP_ON
            // If selected pack is not a default pack and all packs haven't been purchased
            if (![[DataUtility manager] isDefaultPack:packName] && ![[SeatunesIAPHelper manager] allPacksPurchased]) {
#if ANALYTICS_ON
                [Apsalar eventWithArgs:@"IAP-Started", @"Source", @"Play Scene", nil];
#endif                       
                [[SeatunesIAPHelper manager] buyProduct:self];                  
            }
#endif
            
            if (currentPack_ != menuItem.numID) {
                [self togglePackSelect:menuItem.numID];
                [self loadSongMenu:menuItem.numID];
            }
            
            break;
        default:
            break; 
    }
}

- (void) scrollingMenuBottomLeft:(ScrollingMenu *)scrollingMenu
{
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            songDownArrow_.visible = YES;
            break;
        case kScrollingMenuPack:
            packDownArrow_.visible = YES;            
            break;
        default:
            break;
    }
}

- (void) scrollingMenuBottomReached:(ScrollingMenu *)scrollingMenu
{
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            songDownArrow_.visible = NO;
            break;
        case kScrollingMenuPack:
            packDownArrow_.visible = NO;            
            break;
        default:
            break;
    }    
}

#pragma mark - Helper Methods

- (void) togglePackSelect:(NSUInteger)packIndex
{
    NSArray *menuItems = packMenu_.menuItems;
    NSUInteger index = 0;
    for (ScrollingMenuItem *menuItem in menuItems) {
        
        PackMenuItem *packItem = (PackMenuItem *)menuItem;
        if (index == packIndex) {
            [packItem toggleSelected:YES];
        }
        else {
            [packItem toggleSelected:NO];            
        }
        index++;
    }
}

- (void) loadPackMenu
{
    // Get all packs
    packNames_ = [[[DataUtility manager] allPackNames] retain];    
    
    CGRect menuFrame = ADJUST_IPAD_RECT(CGRectMake(PMS_PACK_MENU_X, PMS_PACK_MENU_Y, PMS_PACK_MENU_WIDTH, PMS_PACK_MENU_HEIGHT));
    CGFloat scrollSize = CHOOSE_REL_CCP((CGFloat)PACK_MENU_CELL_HEIGHT, (CGFloat)PACK_MENU_CELL_HEIGHT_M) * [packNames_ count];
    packMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuPack] retain]; 
    
    packMenu_.delegate = self;
    [self addChild:packMenu_]; 
    
    NSUInteger idx = 0;
    for (NSString *packName in packNames_) {    
        
        //NSLog(@"default: %d, all purch: %d", [DataUtility manager] isDefaultPack:packName], 
        
#if IAP_ON
        BOOL isLocked = !([[DataUtility manager] isDefaultPack:packName] || [[SeatunesIAPHelper manager] allPacksPurchased]);
#else
        BOOL isLocked = NO;
#endif
        ScrollingMenuItem *menuItem = [PackMenuItem packMenuItem:packName packIndex:idx++ isLocked:isLocked];
        [packMenu_ addMenuItem:menuItem];
    }
}

- (void) loadSongMenu:(NSUInteger)packIndex
{
    // Cleanup any existing menu
    [self cleanupSongMenu];
    
    NSString *packName = [packNames_ objectAtIndex:packIndex];    
    
    // Get songs for pack
    [songNames_ release];
    songNames_ = [[[DataUtility manager] loadSongNames:packName] retain];    
    
    // Store this as the current pack
    
    currentPack_ = packIndex;
    [packTitle_ setString:packName];
    
    // Unlocked if either default or has been purchased 
#if IAP_ON
    BOOL isLocked = !([[DataUtility manager] isDefaultPack:packName] || [[SeatunesIAPHelper manager] allPacksPurchased]);
#else
    BOOL isLocked = NO;
#endif
    
    // Setup the scrolling menu for the songs
    CGRect menuFrame = ADJUST_IPAD_RECT(CGRectMake(PMS_SONG_MENU_X, PMS_SONG_MENU_Y, PMS_SONG_MENU_WIDTH, PMS_SONG_MENU_HEIGHT));
    CGFloat scrollSize = CHOOSE_REL_CCP((CGFloat)SONG_MENU_CELL_HEIGHT, (CGFloat)SONG_MENU_CELL_HEIGHT_M) * [songNames_ count];
    songMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuSong] retain]; 

    songMenu_.delegate = self;
    [self addChild:songMenu_]; 
    
    // Get scores for songs
    NSDictionary *scores = [[DataUtility manager] loadSongScores];
    
    NSUInteger idx = 0;
    for (NSString *songName in songNames_) {
        BOOL hasScore = ![[DataUtility manager] isTrainingSong:songName];
        ScrollingMenuItem *menuItem = [SongMenuItem songMenuItem:songName scores:scores songIndex:idx++ hasScore:hasScore locked:isLocked];
        [songMenu_ addMenuItem:menuItem];
    }    
    
    songDownArrow_.visible = [songMenu_ isDownArrowNeeded];
}

- (void) purchaseComplete
{    
    [self cleanupSongMenu];  
    [self cleanupPackMenu];
    
    [self loadPackMenu];
    [self loadSongMenu:currentPack_];
    [self togglePackSelect:currentPack_];    
}

- (void) loadMainMenu
{
    [[AudioManager audioManager] playSound:kA4 instrument:kMenu];       
    CCScene *scene = [MainMenuScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene backwards:YES]];    
    [[AudioManager audioManager] playSoundEffect:kPageFlip];  
}

- (void) loadSong:(NSString *)songName
{  
#if IAP_ON
    NSString *packName = [packNames_ objectAtIndex:currentPack_];          
    // Check if current pack is among the defaults or all packs have been unlocked
    if ([[DataUtility manager] isDefaultPack:packName] || [[SeatunesIAPHelper manager] allPacksPurchased]) {
    
        [[AudioManager audioManager] playSound:kF4 instrument:kMenu];      
        // Check if song is a training song
        if ([[DataUtility manager] isTrainingSong:songName]) {
            CCScene *scene = [GameScene startWithDifficulty:kDifficultyMusicNoteTutorial songName:songName packIndex:currentPack_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];        
        }
        else {
        
            CCScene *scene = [DifficultyMenuScene startWithSongName:songName packIndex:currentPack_];
            [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
            [[AudioManager audioManager] playSoundEffect:kPageFlip];    
        }
    }
    // Else user is trying to click on a locked song
    else {
        //[[AudioManager audioManager] playSound:kA4 instrument:kMuted];          
    }
#else
    [[AudioManager audioManager] playSound:kF4 instrument:kMenu];      
    // Check if song is a training song
    if ([[DataUtility manager] isTrainingSong:songName]) {
        CCScene *scene = [GameScene startWithDifficulty:kDifficultyMusicNoteTutorial songName:songName packIndex:currentPack_];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];        
    }
    else {
        
        CCScene *scene = [DifficultyMenuScene startWithSongName:songName packIndex:currentPack_];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
        [[AudioManager audioManager] playSoundEffect:kPageFlip];    
    }    
#endif
}

- (void) cleanupSongMenu
{
    [songMenu_ removeFromParentAndCleanup:YES];
    [songMenu_ removeSuperview];
    [songMenu_ release];   
    songMenu_ = nil;
}

- (void) cleanupPackMenu
{
    [packMenu_ removeFromParentAndCleanup:YES];
    [packMenu_ removeSuperview];
    [packMenu_ release];
    packMenu_ = nil;
}

- (void) showDialog:(NSString *)title text:(NSString *)text
{
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [message show];
}

- (void) showLoading
{    
    songMenu_.isClickable = NO;
    packMenu_.isClickable = NO;    

    loadingIndicator_ = [[LoadingIndicator loadingIndicator] retain];
    [self addChild:loadingIndicator_];
}

- (void) finishLoading
{
    [loadingIndicator_ remove];
    [loadingIndicator_ release];
    loadingIndicator_ = nil;
    
    songMenu_.isClickable = YES;
    packMenu_.isClickable = YES;
}

@end
