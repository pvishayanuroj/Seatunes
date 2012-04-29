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

@implementation PlayMenuScene

static const CGFloat PMS_MENU_FRAME_X = 470.0f;
static const CGFloat PMS_MENU_FRAME_Y = 350.0f;
static const CGFloat PMS_PACK_TITLE_X = 615.0f;
static const CGFloat PMS_PACK_TITLE_Y = 630.0f;

static const CGFloat PMS_BACK_BUTTON_X = 50.0f;
static const CGFloat PMS_BACK_BUTTON_Y = 730.0f;

static const CGFloat PMS_ALL_PACKS_BUTTON_X = 150.0f;
static const CGFloat PMS_ALL_PACKS_BUTTON_Y = 90.0f;

static const CGFloat PMS_CURRENT_PACK_BUTTON_X = 450.0f;
static const CGFloat PMS_CURRENT_PACK_BUTTON_Y = 90.0f;


static const CGFloat PMS_PACK_MENU_X = 100.0f;
static const CGFloat PMS_PACK_MENU_Y = 150.0f;
static const CGFloat PMS_PACK_MENU_WIDTH = 230.0f;
static const CGFloat PMS_PACK_MENU_HEIGHT = 425.0f;

static const CGFloat PMS_SONG_MENU_X = 325.0f;
static const CGFloat PMS_SONG_MENU_Y = 150.0f;
static const CGFloat PMS_SONG_MENU_WIDTH = 565.0f;
static const CGFloat PMS_SONG_MENU_HEIGHT = 425.0f;

@synthesize currentPack = currentPack_;

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
        
        songMenu_ = nil;
        currentPack_ = nil;
        allPacksButton_ = nil;
        packButton_ = nil;
        songNames_ = nil;        
        loadingIndicator_ = nil;
        buyState_ = kStateNoPurchase;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Main Parchment.png"];
        menuFrame.position = ccp(PMS_MENU_FRAME_X, PMS_MENU_FRAME_Y);
        [self addChild:menuFrame];
        
        packTitle_ = [[CCLabelBMFont labelWithString:@"" fntFile:@"BoldMenuFont.fnt"] retain];
        packTitle_.position = ccp(PMS_PACK_TITLE_X, PMS_PACK_TITLE_Y);
        [self addChild:packTitle_];
        
        [self loadPackMenu];        
        
        // Always show the first pack
        [self loadSongMenu:[packNames_ objectAtIndex:0]];
        
#if IAP_ON
        // Check if all packs purchased. If not, add button
        if (![[SeatunesIAPHelper manager] allPacksPurchased]) {
            [self addBuyAllButton];
        }
#endif
        
        // Add back button
        Button *backButton = [ScaledImageButton scaledImageButton:kDMSBack image:@"Back Button.png"];
        backButton.delegate = self;
        backButton.position = ccp(PMS_BACK_BUTTON_X, PMS_BACK_BUTTON_Y);
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
    [allPacksButton_ release];  
    
    [super dealloc];
}

#pragma mark - In-App Purchase Methods

- (void) buyProduct:(BuyState)buyState
{
    // Check for a connection
    if ([Utility hasInternetConnection]) {
    
        [self showLoading];
        
        // Set the product to buy
        buyState_ = buyState;
        
        // Setup the notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoadedFailed) name:kProductsLoadedFailedNotification object:nil];            
        
        // Make the call to request the products first
        [[SeatunesIAPHelper manager] requestProducts];   
    }
    else {
        [self showDialog:@"Error" text:@"Internet connection required to make this purchase!"];
    }   
}

- (void) productsLoaded
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    
    NSString *productIdentifier;
    if (buyState_ == kStateBuyAllPacks) {
        productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];
    }
    else if (buyState_ == kStateBuyCurrentPack) {
        productIdentifier = [[DataUtility manager] productIdentifierFromName:currentPack_];                
    }    
    else {
        return;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchaseNotification object:nil];       
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedFailed:) name:kProductPurchaseFailedNotification object:nil];    
    [[SeatunesIAPHelper manager] buyProductIdentifier:productIdentifier];      
}

- (void) productsLoadedFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    buyState_ = kStateNoPurchase;
    [self finishLoading];
    
    NSString *errorText;
    NSInteger rc = [[notification object] integerValue];
    
    switch (rc) {
        case kIAPPurchasesLocked:
            errorText = @"Oops! Purchases are locked. Go ask your parents to unlock this! (Settings > General > Restrictions)";
            break;
        default:
            errorText = @"Oops! Could not connect to the server. Try again later!";
            break;
    }
    [self showDialog:@"Error" text:errorText];    
    
#if DEBUG_IAP
    NSLog(@"Error - Product loading failed, rc: %d", rc);
#endif
}

- (void) productPurchased:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    buyState_ = kStateNoPurchase;    
    
    [self finishLoading];    
    [self reloadScreen];

#if DEBUG_IAP
    NSString *productIdentifier = [notification object];
    NSLog(@"Successfully bought %@", productIdentifier);
#endif
}

- (void) productPurchasedFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    buyState_ = kStateNoPurchase;    
    [self finishLoading];    
    
    NSInteger rc = [[notification object] integerValue];
    
    if (rc != kIAPUserCancelled) {
        [self showDialog:@"Error" text:@"Oops! Unable to make purchase. Try again later."];                
    }
}

#pragma mark - Delegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Assume that all other 
    if (buttonIndex != 0) {
        [self buyProduct:kStateBuyCurrentPack];
    }
}

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kButtonBuyAllPacks:
            [self buyProduct:kStateBuyAllPacks];
            break;
        case kButtonBuyCurrentPack:
            [self buyProduct:kStateBuyCurrentPack];         
            break;
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
            packName = [packNames_ objectAtIndex:menuItem.numID];
            if (![packName isEqualToString:currentPack_]) {
                [self togglePackSelect:menuItem.numID];
                [self loadSongMenu:packName];
                [[AudioManager audioManager] playSound:kB4 instrument:kMenu];
            }
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
    
    CGRect menuFrame = CGRectMake(PMS_PACK_MENU_X, PMS_PACK_MENU_Y, PMS_PACK_MENU_WIDTH, PMS_PACK_MENU_HEIGHT);
    CGFloat scrollSize = PACK_MENU_CELL_HEIGHT * [packNames_ count];
    packMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuPack] retain]; 
    
    packMenu_.delegate = self;
    [self addChild:packMenu_]; 
    
    NSUInteger idx = 0;
    for (NSString *packName in packNames_) {    
        ScrollingMenuItem *menuItem = [PackMenuItem packenuItem:packName packIndex:idx++ isLocked:NO];
        [packMenu_ addMenuItem:menuItem];
    }
}

- (void) loadSongMenu:(NSString *)packName
{
    // Cleanup any existing menu
    [self cleanupSongMenu];
    
    // Get songs for pack
    [songNames_ release];
    songNames_ = [[[DataUtility manager] loadSongNames:packName] retain];    
    
    // Store this as the current pack
    self.currentPack = packName;
    [packTitle_ setString:packName];
    
    // Unlocked if either default or has been purchased 
#if IAP_ON
    BOOL isLocked = !([[DataUtility manager] isDefaultPack:packName] || [[SeatunesIAPHelper manager] packPurchased:packName]);
#else
    BOOL isLocked = NO;
#endif
    
    // Setup the scrolling menu for the songs
    CGRect menuFrame = CGRectMake(PMS_SONG_MENU_X, PMS_SONG_MENU_Y, PMS_SONG_MENU_WIDTH, PMS_SONG_MENU_HEIGHT);
    CGFloat scrollSize = SONG_MENU_CELL_HEIGHT * [songNames_ count];
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
    
#if IAP_ON    
    // If locked, add purchase button
    if (isLocked) {
        packButton_ = [[StarfishButton starfishButton:kButtonBuyCurrentPack text:@"Buy Pack"] retain];
        packButton_.delegate = self;
        packButton_.position = ccp(PMS_CURRENT_PACK_BUTTON_X, PMS_CURRENT_PACK_BUTTON_Y);
        [self addChild:packButton_];
    }
#endif
}

- (void) reloadScreen
{
    // Check if all packs purchased. If not, add button
    if (![[SeatunesIAPHelper manager] allPacksPurchased]) {
        [self addBuyAllButton];
    }
    
    // Reload the current song menu
    [self loadSongMenu:currentPack_];
}

- (void) addBuyAllButton
{
    if (allPacksButton_ == nil) {
        allPacksButton_ = [[StarfishButton starfishButton:kButtonBuyAllPacks text:@"Buy All"] retain];
        allPacksButton_.delegate = self;
        allPacksButton_.position = ccp(PMS_ALL_PACKS_BUTTON_X, PMS_ALL_PACKS_BUTTON_Y);
        [self addChild:allPacksButton_];    
    }
}

- (void) removeBuyAllButton
{
    if (allPacksButton_ != nil) {
        [allPacksButton_ removeFromParentAndCleanup:YES];
        [allPacksButton_ release];
        allPacksButton_ = nil;   
    }
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
#if DEBUG_ALLUNLOCK
    [[AudioManager audioManager] playSound:kF4 instrument:kMenu];      
    // Check if song is a training song
    if ([[DataUtility manager] isTrainingSong:songName]) {
        CCScene *scene = [GameScene startWithDifficulty:kDifficultyMusicNoteTutorial songName:songName];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];        
    }
    else {
    
        CCScene *scene = [DifficultyMenuScene startWithSongName:songName];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
        [[AudioManager audioManager] playSoundEffect:kPageFlip];    
    }
    
#else
    // Check if pack is locked
    if ([[SeatunesIAPHelper manager] packPurchased:currentPack_]) {    
        CCScene *scene = [DifficultyMenuScene startWithSongName:songName];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
        [[AudioManager audioManager] playSoundEffect:kPageFlip];    
    }
    else {
        [self showBuyDialog];
    }
#endif
}

- (void) cleanupSongMenu
{
    [songMenu_ removeFromParentAndCleanup:YES];
    [songMenu_ removeSuperview];
    [songMenu_ release];   
    songMenu_ = nil;
    
    [packButton_ removeFromParentAndCleanup:YES];
    [packButton_ release];
    packButton_ = nil;
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

- (void) showBuyDialog
{
    NSString *title = @"Pack Not Purchased";
    NSString *text = [NSString stringWithFormat:@"To play this song, the %@ must be purchased.\nBuy it now?", currentPack_];
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
    [message show];    
}

- (void) showLoading
{
    if (allPacksButton_) {
        allPacksButton_.isClickable = NO;
    }
    if (packButton_.isClickable) {
        packButton_.isClickable = NO;
    }
    
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

    if (allPacksButton_) {
        allPacksButton_.isClickable = YES;
    }
    if (packButton_.isClickable) {
        packButton_.isClickable = YES;
    }    
    
    songMenu_.isClickable = YES;
    packMenu_.isClickable = YES;
}

@end
