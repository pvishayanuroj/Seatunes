//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"
#import "Utility.h"
#import "DataUtility.h"

@implementation SongMenuItem

static const CGFloat SMI_CELL_HEIGHT = SONG_MENU_CELL_HEIGHT;

static const CGFloat SMI_SONG_NAME_X = 200.0f;
static const CGFloat SMI_LOCKED_ICON_X = 100.0f;
static const CGFloat SMI_STAR_X = 70.0f;
static const CGFloat SMI_STAR_PADDING = 40.0f;
static const CGFloat SMI_STAR_SCALE = 0.25f;
static const CGFloat SMI_LOCK_SCALE = 0.25f;

+ (id) songMenuItem:(NSString *)songName scores:(NSDictionary *)scores songIndex:(NSUInteger)songIndex hasScore:(BOOL)hasScore locked:(BOOL)locked
{
    return [[[self alloc] initSongMenuItem:songName scores:scores songIndex:songIndex hasScore:hasScore locked:locked] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName scores:(NSDictionary *)scores songIndex:(NSUInteger)songIndex hasScore:(BOOL)hasScore locked:(BOOL)locked
{
    if ((self = [super initScrollingMenuItem:songIndex height:SMI_CELL_HEIGHT])) {
        
        if (locked) {
            label_ = [[CCLabelBMFont labelWithString:songName fntFile:@"MenuFontDisabled.fnt"] retain];   
        }
        else {
            label_ = [[CCLabelBMFont labelWithString:songName fntFile:@"MenuFont.fnt"] retain];   
        }
        label_.anchorPoint = ccp(0, 0.5f);
        label_.position = ccp(SMI_SONG_NAME_X, 0);
        [self addChild:label_];

        // If not a training song
        if (hasScore) {
        
            CCSprite *easySprite;        
            CCSprite *mediumSprite;        
            CCSprite *hardSprite;
            
            NSString *easyKey = [Utility songKey:songName difficulty:kDifficultyEasy];
            NSString *mediumKey = [Utility songKey:songName difficulty:kDifficultyMedium];
            NSString *hardKey = [Utility songKey:songName difficulty:kDifficultyHard];        

            if ([scores objectForKey:easyKey]) {
                easySprite = [CCSprite spriteWithFile:@"Bubble Button Small.png"];                                    
            }
            else {
                easySprite = [CCSprite spriteWithFile:@"Bubble Button Small Unselected.png"];                                    
            }                
            
            if ([scores objectForKey:mediumKey]) {
                mediumSprite = [CCSprite spriteWithFile:@"Clam Button Small.png"];            
            }
            else {
                mediumSprite = [CCSprite spriteWithFile:@"Clam Button Small Unselected.png"];                        
            }         
            
            if ([scores objectForKey:hardKey]) {
                hardSprite = [CCSprite spriteWithFile:@"Music Note Button Small.png"];
            }
            else {
                hardSprite = [CCSprite spriteWithFile:@"Music Note Button Small Unselected.png"];
            }

            easySprite.position = ccp(SMI_STAR_X + 0 * SMI_STAR_PADDING, 0);        
            mediumSprite.position = ccp(SMI_STAR_X + 1 * SMI_STAR_PADDING, 3);        
            hardSprite.position = ccp(SMI_STAR_X + 2 * SMI_STAR_PADDING, 0);
            [self addChild:easySprite];        
            [self addChild:mediumSprite];                
            [self addChild:hardSprite];      
        }
        else {
            
            // Change this check for later tutorials
            NSString *spriteName;
            if ([[DataUtility manager] isFirstPlayForDifficulty:kDifficultyMusicNoteTutorial]) {
                spriteName = @"Checkmark Unselected.png";
            }
            else {
                spriteName = @"Checkmark.png";
            }
            
            CCSprite *sprite = [CCSprite spriteWithFile:spriteName];            
            sprite.position = ccp(SMI_STAR_X + 1 * SMI_STAR_PADDING, 0);
            [self addChild:sprite];            
        }
    }
    return self;
}

- (void) dealloc
{
    [label_ release];
    
    [super dealloc];
}

@end
