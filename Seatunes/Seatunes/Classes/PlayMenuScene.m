//
//  PlayMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PlayMenuScene.h"
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

static const CGFloat PMS_MENU_FRAME_X = 550.0f;
static const CGFloat PMS_MENU_FRAME_Y = 400.0f;
static const CGFloat PMS_PACK_TITLE_X = 700.0f;
static const CGFloat PMS_PACK_TITLE_Y = 630.0f;

static const CGFloat PMS_ALL_PACKS_BUTTON_X = 150.0f;
static const CGFloat PMS_ALL_PACKS_BUTTON_Y = 90.0f;

static const CGFloat PMS_CURRENT_PACK_BUTTON_X = 450.0f;
static const CGFloat PMS_CURRENT_PACK_BUTTON_Y = 90.0f;

static const CGFloat PMS_PACK_MENU_X = 100.0f;
static const CGFloat PMS_PACK_MENU_Y = 175.0f;
static const CGFloat PMS_PACK_MENU_WIDTH = 200.0f;
static const CGFloat PMS_PACK_MENU_HEIGHT = 425.0f;

static const CGFloat PMS_SONG_MENU_X = 350.0f;
static const CGFloat PMS_SONG_MENU_Y = 175.0f;
static const CGFloat PMS_SONG_MENU_WIDTH = 650.0f;
static const CGFloat PMS_SONG_MENU_HEIGHT = 425.0f;

@synthesize currentPack = currentPack_;

- (id) init
{
    if ((self = [super init])) {
        
        scrollingMenu_ = nil;
        currentPack_ = nil;
        allPacksButton_ = nil;
        packButton_ = nil;
        songNames_ = nil;        
        productIdentifierToBuy_ = nil;
        loadingIndicator_ = nil;
        
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Menu Frame.png"];
        menuFrame.position = ccp(PMS_MENU_FRAME_X, PMS_MENU_FRAME_Y);
        [self addChild:menuFrame];
        
        packTitle_ = [[CCLabelBMFont labelWithString:@"" fntFile:@"MenuFont.fnt"] retain];
        packTitle_.position = ccp(PMS_PACK_TITLE_X, PMS_PACK_TITLE_Y);
        [self addChild:packTitle_];
        
        [self loadPackMenu];        
        
        // Always show the first pack
        [self loadSongMenu:[packNames_ objectAtIndex:0]];
        
        // Check if all packs purchased. If not, add button
        if (![[SeatunesIAPHelper manager] allPacksPurchased]) {
            allPacksButton_ = [[StarfishButton starfishButton:kButtonBuyAllPacks text:@"Buy All"] retain];
            allPacksButton_.delegate = self;
            allPacksButton_.position = ccp(PMS_ALL_PACKS_BUTTON_X, PMS_ALL_PACKS_BUTTON_Y);
            [self addChild:allPacksButton_];
        }
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:0.2f];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(delayedSound)];
        [self runAction:[CCSequence actions:delay, done, nil]];
        
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

- (void) buyProduct:(BuyState)buyState
{
    // Check for a connection
    if ([Utility hasInternetConnection]) {
    
        [self showLoading];
        
        // Set the product to buy
        buyState_ = buyState;
        [productIdentifierToBuy_ release];
        productIdentifierToBuy_ = [[[DataUtility manager] productIdentifierFromName:kAllPacks] retain];    
        
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
    NSLog(@"PRODUCTS LOADED!");
    
    switch (buyState_) {
        case kStateBuyAllPacks:
        case kStateBuyCurrentPack:
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchaseNotification object:nil];       
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedFailed:) name:kProductPurchaseFailedNotification object:nil];                   
            [[SeatunesIAPHelper manager] buyProductIdentifier:productIdentifierToBuy_];            
            break;
        default:
            break;
    }
}

- (void) productsLoadedFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [self finishLoading];
    [self showDialog:@"Error" text:@"Oops! Unable to make purchase. Try again later."];    
    NSLog(@"PRODUCTS LOADING FAILED");
}

- (void) productPurchased:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [self finishLoading];    
    NSString *productIdentifier = [notification object];
    NSLog(@"BOUGHT %@", productIdentifier);
}

- (void) productPurchasedFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    [self finishLoading];    
    [self showDialog:@"Error" text:@"Oops! Unable to make purchase. Try again later."];        
    NSLog(@"Product purchased FAILED");
}

#pragma mark - Delegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
        default:
            break;
    }
}

- (void) scrollingMenuItemClicked:(ScrollingMenu *)scrollingMenu menuItem:(ScrollingMenuItem *)menuItem
{
    NSString *packName;
    
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            [self loadDifficultyMenu:[songNames_ objectAtIndex:menuItem.numID]];
            break;
        case kScrollingMenuPack:
            packName = [packNames_ objectAtIndex:menuItem.numID];
            if (![packName isEqualToString:currentPack_]) {
                [self togglePackSelect:menuItem.numID];
                [self loadSongMenu:packName];
                [[AudioManager audioManager] playSoundEffect:kMenuB1];
            }
            break;
        default:
            break; 
    }
}

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
    BOOL isLocked = !([[DataUtility manager] isDefaultPack:packName] || [[SeatunesIAPHelper manager] packPurchased:packName]);
    
    // Setup the scrolling menu for the songs
    CGRect menuFrame = CGRectMake(PMS_SONG_MENU_X, PMS_SONG_MENU_Y, PMS_SONG_MENU_WIDTH, PMS_SONG_MENU_HEIGHT);
    CGFloat scrollSize = SONG_MENU_CELL_HEIGHT * [songNames_ count];
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuSong] retain]; 

    scrollingMenu_.delegate = self;
    [self addChild:scrollingMenu_]; 
    
    // Get scores for songs
    NSDictionary *scores = [[DataUtility manager] loadSongScores];
    
    NSUInteger idx = 0;
    for (NSString *songName in songNames_) {
        
        // Load score
        NSNumber *score = [scores objectForKey:songName];
        ScoreType scoreType = (score == nil) ? kScoreZeroStar : [score integerValue];
        
        ScrollingMenuItem *menuItem = [SongMenuItem songMenuItem:songName songScore:scoreType songIndex:idx++ locked:isLocked];
        [scrollingMenu_ addMenuItem:menuItem];
    }    
    
    // If locked, add purchase button
    if (isLocked) {
        packButton_ = [[StarfishButton starfishButton:kButtonBuyCurrentPack text:@"Buy Pack"] retain];
        packButton_.delegate = self;
        packButton_.position = ccp(PMS_CURRENT_PACK_BUTTON_X, PMS_CURRENT_PACK_BUTTON_Y);
        [self addChild:packButton_];
    }
}

- (void) loadDifficultyMenu:(NSString *)songName
{
    CCScene *scene = [DifficultyMenuScene startWithSongName:songName];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
    [[AudioManager audioManager] playSoundEffect:kPageFlip];    
}

- (void) cleanupSongMenu
{
    [scrollingMenu_ removeFromParentAndCleanup:YES];
    [scrollingMenu_ removeSuperview];
    [scrollingMenu_ release];   
    scrollingMenu_ = nil;
    
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

- (void) delayedSound
{
    [[AudioManager audioManager] playSoundEffect:kPageFlip];
}

- (void) showDialog:(NSString *)title text:(NSString *)text
{
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
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
    
    scrollingMenu_.isClickable = NO;
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
    
    scrollingMenu_.isClickable = YES;
    packMenu_.isClickable = YES;

}

@end
