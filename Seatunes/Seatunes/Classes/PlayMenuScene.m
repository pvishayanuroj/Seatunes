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
    [sliderBoxMenu_ release];
    [songNames_ release];
    
    [super dealloc];
}

- (void) slideBoxMenuItemSelected:(Button *)button
{
    [self loadSongMenu:button.numID];
}

- (void) scrollingMenuItemClicked:(ScrollingMenuItem *)menuItem
{
    NSString *songName = [songNames_ objectAtIndex:menuItem.numID];
    NSLog(@"Song clicked: %@", songName);
    [self loadDifficultyMenu:songName];
}

- (void) loadPackMenu
{
    sliderBoxMenu_ = [[SliderBoxMenu sliderBoxMenu:120] retain];
    sliderBoxMenu_.position = ccp(150, 600);
    sliderBoxMenu_.delegate = self;
    [self addChild:sliderBoxMenu_];
    
    NSArray *packNames = [Utility allPackNames];
    
    for (NSNumber *packName in packNames) {
        NSInteger packType = [packName unsignedIntegerValue];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", [Utility packNameFromEnum:packType]];
        Button *button = [ImageButton imageButton:packType unselectedImage:imageName selectedImage:imageName];
        [sliderBoxMenu_ addMenuItem:button];
    }
}

- (void) loadSongMenu:(PackType)packType
{
    [self cleanupSongMenu];
    
    CGRect menuFrame = CGRectMake(1024 - 650, 100, 650, 500);
    CGFloat scrollSize = 1000;
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize] retain]; 

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

@end
