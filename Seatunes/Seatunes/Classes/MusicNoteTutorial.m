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
        
        //[self test];
        
        dialogue_ = [[self addDialogue] retain];
    } 
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [keyboard_ release];
    [dialogue_ release];
    
    [super dealloc];
}

- (NSArray *) addDialogue
{
    NSMutableArray *dialogue = [NSMutableArray arrayWithCapacity:12];
    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialIntroduction]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialStaff]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialNotes]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialNotes2]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialLetters]];    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialLearnC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayDE]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayFG]];    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayABC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialMnemonic]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialEvery]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialGood]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialBoy]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialFace]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialF]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialA]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialComplete]];
    
    return dialogue;
}

- (void) notesInSequenceAdded
{
    [staff_ destroyNotesInSequence];
}

- (void) notesInSequenceDestroyed
{
    NSLog(@"notes destroyed");
}

- (void) blinkStaff
{
    
}

- (void) showLineNotes
{
    
}

- (void) showSpaceNotes
{
    
}

- (void) showKeyboardLetters
{
    
}

- (void) speechClicked:(SpeechType)speechType
{
    
}

- (void) speechComplete:(SpeechType)speechType
{
    switch (speechType) {
        case kTutorialIntroduction:
            break;
        case kTutorialStaff:
            break;
        case kTutorialNotes:
            break;
        case kTutorialNotes2:
            break;
        case kTutorialLetters:
            break;
        case kTutorialLearnC:
            break;
        case kTutorialPlayC:
            break;
        case kTutorialPlayDE:
            break;
        case kTutorialPlayFG:
            break;
        case kTutorialPlayABC:
            break;
        case kTutorialMnemonic:
            break;
        case kTutorialEvery:
            break;
        case kTutorialGood:
            break;
        case kTutorialBoy:
            break;
        case kTutorialFace:
            break;
        case kTutorialF:
            break;
        case kTutorialA:
            break;
        case kTutorialC:
            break;
        case kTutorialComplete:
            break;            
        default:
            break;
    }      
}

@end
