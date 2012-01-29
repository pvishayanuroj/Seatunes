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
#import "Button.h"
#import "ScrollingMenuItem.h"
#import "SongMenuItem.h"
#import "Utility.h"
#import "GameScene.h"

@implementation PlayMenuScene

- (id) init
{
    if ((self = [super init])) {
        
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
    [self startSong];
}

- (void) loadPackMenu
{
    sliderBoxMenu_ = [[SliderBoxMenu sliderBoxMenu:120] retain];
    sliderBoxMenu_.position = ccp(150, 600);
    sliderBoxMenu_.delegate = self;
    [self addChild:sliderBoxMenu_];
    
    NSArray *packNames = [Utility allPackNames];
    
    for (NSNumber *packName in packNames) {
        NSUInteger packType = [packName unsignedIntegerValue];
        NSString *imageName = [NSString stringWithFormat:@"%@.png", [Utility packNameFromEnum:packType]];
        Button *button = [ImageButton imageButton:packType unselectedImage:imageName selectedImage:imageName];
        [sliderBoxMenu_ addMenuItem:button];
    }
}

- (void) loadSongMenu:(PackType)packType
{
    [self cleanupSongMenu];
    
    CGRect menuFrame = CGRectMake(1024 - 650, 0, 650, 600);
    CGFloat scrollSize = 1000;
    scrollingMenu_ = [[ScrollingMenu scrollingMenu:menuFrame scrollSize:scrollSize] retain]; 

    scrollingMenu_.delegate = self;
    [self addChild:scrollingMenu_]; 
    
    // Get songs for pack
    songNames_ = [[self loadSongNames:[Utility packNameFromEnum:packType]] retain];
    
    NSUInteger idx = 0;
    for (NSString *songName in songNames_) {
        ScrollingMenuItem *menuItem = [SongMenuItem songMenuItem:songName songIndex:idx++];
        [scrollingMenu_ addMenuItem:menuItem];
    }    
}

- (void) startSong
{
    CCScene *scene = [GameScene node];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:scene]];    
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
}

@end
