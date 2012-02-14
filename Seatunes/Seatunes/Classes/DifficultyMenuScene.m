//
//  DifficultyMenuScene.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/13/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "DifficultyMenuScene.h"
#import "GameScene.h"
#import "Menu.h"
#import "Button.h"

@implementation DifficultyMenuScene

+ (id) startWithSongName:(NSString *)songName
{
    return [[[self alloc] initWithSongName:songName] autorelease];
}

- (id) initWithSongName:(NSString *)songName
{
    if ((self = [super init])) {
        
        CCSprite *background = [CCSprite spriteWithFile:@"Menu Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];      
        songName_ = [songName retain];
        
        [self loadDifficultyMenu];
        
    }
    return self;
}

- (void) dealloc
{
    [songName_ release];
    
    [super dealloc];
}

- (void) menuItemSelected:(Button *)button
{
    [self startSong:button.numID songName:songName_];
}

- (void) loadDifficultyMenu
{
    Menu *menu = [Menu menu:256.0f isVertical:NO];
    menu.delegate = self;
    menu.position = ccp(256.0f, 400.0f);
    
    [menu addMenuBackground:@"Difficulty Text.png" pos:ccp(256.0f, 148.0f)];    
    
    Button *easyButton = [ImageButton imageButton:kDifficultyEasy unselectedImage:@"Easy Button.png" selectedImage:@"Easy Button Selected.png"];
    Button *mediumButton = [ImageButton imageButton:kDifficultyMedium unselectedImage:@"Medium Button.png" selectedImage:@"Medium Button Selected.png"];
    Button *hardButton = [ImageButton imageButton:kDifficultyHard unselectedImage:@"Hard Button.png" selectedImage:@"Hard Button Selected.png"];    
    
    [menu addMenuItem:easyButton];
    [menu addMenuItem:mediumButton];
    [menu addMenuItem:hardButton];    
    
    [self addChild:menu];
}

- (void) startSong:(DifficultyType)difficulty songName:(NSString *)songName
{
    CCScene *scene = [GameScene startWithDifficulty:difficulty songName:songName];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:scene]];    
}

@end
