//
//  PlayMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/28/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "PlayMenuScene.h"
#import "SliderBoxMenu.h"
#import "ScrollingMenu.h"
#import "Menu.h"
#import "Button.h"
#import "ScrollingMenuItem.h"
#import "SongMenuItem.h"
#import "PackMenuItem.h"
#import "Utility.h"
#import "DataUtility.h"
#import "DifficultyMenuScene.h"
#import "AudioManager.h"

@implementation PlayMenuScene

static const CGFloat PMS_MENU_FRAME_X = 550.0f;
static const CGFloat PMS_MENU_FRAME_Y = 400.0f;
static const CGFloat PMS_PACK_TITLE_X = 700.0f;
static const CGFloat PMS_PACK_TITLE_Y = 630.0f;

- (id) init
{
    if ((self = [super init])) {
        
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
        
        scrollingMenu_ = nil;
        [self loadSongMenu:kExercisePack];
        currentPack_ = 0;
        
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
    
    [super dealloc];
}

- (void) scrollingMenuItemClicked:(ScrollingMenu *)scrollingMenu menuItem:(ScrollingMenuItem *)menuItem
{
    PackType packType;
    
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            [self loadDifficultyMenu:[songNames_ objectAtIndex:menuItem.numID]];
            break;
        case kScrollingMenuPack:
            packType = [[packNames_ objectAtIndex:menuItem.numID] integerValue];
            if (packType != currentPack_) {
                [self togglePackSelect:menuItem.numID];
                [self loadSongMenu:packType];
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
    CGRect menuFrame = CGRectMake(100, 175, 200, 425);
    CGFloat scrollSize = 500;
    packMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuPack] retain]; 
    
    packMenu_.delegate = self;
    [self addChild:packMenu_]; 
    
    // Get all packs
    packNames_ = [[Utility allPackNames] retain];    
    
    // Get unlocked packs
    NSArray *unlockedPacks = [DataUtility loadUnlockedPacks];
    
    NSUInteger idx = 0;
    for (NSNumber *pack in packNames_) {    
   
        BOOL isLocked = ![unlockedPacks containsObject:pack];
        NSString *packName = [Utility packNameFromEnum:[pack integerValue]];
        ScrollingMenuItem *menuItem = [PackMenuItem packenuItem:packName packIndex:idx++ isLocked:isLocked];
        [packMenu_ addMenuItem:menuItem];
    }
}

- (void) loadSongMenu:(PackType)packType
{
    [self cleanupSongMenu];
    
    currentPack_ = packType;
    NSString *packName = [Utility packNameFromEnum:packType];
    [packTitle_ setString:packName];
    
    // Setup the scrolling menu for the songs
    CGRect menuFrame = CGRectMake(350, 175, 650, 425);
    CGFloat scrollSize = 800;
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuSong] retain]; 

    scrollingMenu_.delegate = self;
    [self addChild:scrollingMenu_]; 
    
    // Get songs for pack
    songNames_ = [[self loadSongNames:packName] retain];
    
    // Get scores for songs
    NSDictionary *scores = [DataUtility loadSongScores];
    
    NSUInteger idx = 0;
    for (NSString *songName in songNames_) {
        
        // Load score
        NSNumber *score = [scores objectForKey:songName];
        ScoreType scoreType = (score == nil) ? kScoreZeroStar : [score integerValue];
        
        ScrollingMenuItem *menuItem = [SongMenuItem songMenuItem:songName songScore:scoreType songIndex:idx++];
        [scrollingMenu_ addMenuItem:menuItem];
    }    
}

- (void) loadDifficultyMenu:(NSString *)songName
{
    CCScene *scene = [DifficultyMenuScene startWithSongName:songName];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];
    [[AudioManager audioManager] playSoundEffect:kPageFlip];    
}

- (NSArray *) loadSongNames:(NSString *)packName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:packName ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *songs = [NSArray arrayWithArray:[data objectForKey:@"Songs"]];

    return songs;
}

- (void) cleanupSongMenu
{
    [scrollingMenu_ removeFromParentAndCleanup:YES];
    [scrollingMenu_ removeSuperview];
    [scrollingMenu_ release];   
    scrollingMenu_ = nil;
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

@end
