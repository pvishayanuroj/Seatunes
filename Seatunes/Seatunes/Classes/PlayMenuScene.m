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

@implementation PlayMenuScene

- (id) init
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];        
        
        CCSprite *menuFrame = [CCSprite spriteWithFile:@"Menu Frame.png"];
        menuFrame.position = ccp(550, 400);
        [self addChild:menuFrame];
        
        [self loadPackMenu];        
        
        scrollingMenu_ = nil;
        [self loadSongMenu:kExercisePack];
        
    }
    return self;
}

- (void) dealloc
{
    [self cleanupSongMenu];  
    [self cleanupPackMenu];
    [songNames_ release];
    [packNames_ release];
    
    [super dealloc];
}

- (void) scrollingMenuItemClicked:(ScrollingMenu *)scrollingMenu menuItem:(ScrollingMenuItem *)menuItem
{
    switch (scrollingMenu.numID) {
        case kScrollingMenuSong:
            [self loadDifficultyMenu:[songNames_ objectAtIndex:menuItem.numID]];
            break;
        case kScrollingMenuPack:
            [self togglePackSelect:menuItem.numID];
            [self loadSongMenu:[[packNames_ objectAtIndex:menuItem.numID] integerValue]];
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
    
    CGRect menuFrame = CGRectMake(350, 175, 650, 425);
    CGFloat scrollSize = 800;
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize numID:kScrollingMenuSong] retain]; 

    scrollingMenu_.delegate = self;
    [self addChild:scrollingMenu_]; 
    
    // Get songs for pack
    songNames_ = [[self loadSongNames:[Utility packNameFromEnum:packType]] retain];
    
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
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0f scene:scene]];    
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

@end
