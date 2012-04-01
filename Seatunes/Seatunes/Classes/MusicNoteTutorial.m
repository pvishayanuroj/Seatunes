//
//  MusicNoteTutorial.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/31/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MusicNoteTutorial.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "Note.h"
#import "SpeechReader.h"
#import "AudioManager.h"

@implementation MusicNoteTutorial

static const CGFloat MNT_INSTRUCTOR_X = 200.0f;
static const CGFloat MNT_INSTRUCTOR_Y = 550.0f;
static const CGFloat MNT_KEYBOARD_X = 100.0f;
static const CGFloat MNT_KEYBOARD_Y = 100.0f;

+ (id) musicNoteTutorial:(NSString *)songName
{
    return [[[self alloc] initGameLogicF:songName] autorelease];
}

- (id) initMusicNoteTutorial:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queueByID_ = [[NSMutableArray arrayWithCapacity:5] retain];
        queueByKey_ = [[NSMutableArray arrayWithCapacity:5] retain];        
        
        notesHit_ = [[Utility generateBoolDictionary:YES size:[notes_ count]] retain];   
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(MNT_INSTRUCTOR_X, MNT_INSTRUCTOR_Y);
        [self addChild:instructor_];            
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(MNT_KEYBOARD_X, MNT_KEYBOARD_Y);
        [self addChild:keyboard_];           
        
        // If first time playing
        if (isFirstPlay_) {
            [self runSingleSpeech:kMediumInstructions tapRequired:YES];
        }
        else { 
            [self runSingleSpeech:kSongStart tapRequired:YES];
        }
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [queueByID_ release];
    [queueByKey_ release];
    [notesHit_ release];
    [keyboard_ release];
    [noteGenerator_ release];
    
    [super dealloc];
}

@end
