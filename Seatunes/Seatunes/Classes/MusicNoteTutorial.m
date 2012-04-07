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
#import "Staff.h"
#import "Note.h"
#import "SpeechReader.h"
#import "AudioManager.h"

@implementation MusicNoteTutorial

static const CGFloat MNT_INSTRUCTOR_X = 200.0f;
static const CGFloat MNT_INSTRUCTOR_Y = 350.0f;
static const CGFloat MNT_KEYBOARD_X = 100.0f;
static const CGFloat MNT_KEYBOARD_Y = 100.0f;
static const CGFloat MNT_STAFF_X = 512.0f;
static const CGFloat MNT_STAFF_Y = 600.0f;

+ (id) musicNoteTutorial
{
    return [[[self alloc] initMusicNoteTutorial] autorelease];
}

- (id) initMusicNoteTutorial
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;       

        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        staff_ = [[Staff staff] retain]; 
        staff_.delegate = self;
        staff_.position = ccp(MNT_STAFF_X, MNT_STAFF_Y);
        [staff_ disableLoop];
        [self addChild:staff_];              
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(MNT_INSTRUCTOR_X, MNT_INSTRUCTOR_Y);
        [self addChild:instructor_];            
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(MNT_KEYBOARD_X, MNT_KEYBOARD_Y);
        [self addChild:keyboard_];        
        
        [self test];
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [keyboard_ release];
    
    [super dealloc];
}

- (void) test
{
    NSMutableArray *a = [NSMutableArray array];
    [a addObject:[NSNumber numberWithInteger:kE4]];
    [a addObject:[NSNumber numberWithInteger:kG4]];
    [a addObject:[NSNumber numberWithInteger:kB4]];    
    [a addObject:[NSNumber numberWithInteger:kD5]];    
    [a addObject:[NSNumber numberWithInteger:kF5]];        
    [staff_ addNotesInSequence:a];
}

- (void) notesInSequenceAdded
{
    [staff_ destroyNotesInSequence];
}

- (void) notesInSequenceDestroyed
{
    NSLog(@"notes destroyed");
}

@end
