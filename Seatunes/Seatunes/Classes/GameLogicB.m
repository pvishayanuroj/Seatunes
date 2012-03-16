//
//  GameLogicB.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicB.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "Note.h"
#import "SpeechReader.h"

@implementation GameLogicB

static const CGFloat GLB_INSTRUCTOR_X = 200.0f;
static const CGFloat GLB_INSTRUCTOR_Y = 265.0f;
static const CGFloat GLB_KEYBOARD_X = 100.0f;
static const CGFloat GLB_KEYBOARD_Y = 100.0f;
static const CGFloat GLB_FISH_X = 800.0f;
static const CGFloat GLB_FISH_Y = 600.0f;
static const CGFloat GLB_SPOTLIGHT_X = 600.0f;
static const CGFloat GLB_SPOTLIGHT_Y = 650.0f;
static const CGFloat GLB_SPOTLIGHT_SCALE = 0.7f;

+ (id) gameLogicB:(NSString *)songName
{
    return [[[self alloc] initGameLogicB:songName] autorelease];
}

- (id) initGameLogicB:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        notesHit_ = [[Utility generateBoolDictionary:YES size:[notes_ count]] retain];     
        
        CCSprite *background = [CCSprite spriteWithFile:@"Game Background Dark.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];             
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.position = ccp(GLB_KEYBOARD_X, GLB_KEYBOARD_Y);
        [self addChild:keyboard_];                
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;        
        [self addChild:noteGenerator_];  
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLB_INSTRUCTOR_X, GLB_INSTRUCTOR_Y);
        [self addChild:instructor_];        
        
        fish_ = [[CCSprite spriteWithFile:@"Angler Fish.png"] retain];
        fish_.position = ccp(GLB_FISH_X, GLB_FISH_Y);
        [self addChild:fish_];
        spotlight_ = [[CCSprite spriteWithFile:@"Spotlight.png"] retain];
        spotlight_.scale = GLB_SPOTLIGHT_SCALE;
        spotlight_.position = ccp(GLB_SPOTLIGHT_X, GLB_SPOTLIGHT_Y);
        //spotlight_.visible = NO;
        [self addChild:spotlight_];
        
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
    [queue_ release];
    [notesHit_ release];
    [keyboard_ release];
    [noteGenerator_ release];
    [fish_ release];
    [spotlight_ release];
    
    [super dealloc];
}

- (void) start
{
    keyboard_.isClickable = YES;
    [self schedule:@selector(loop:) interval:1.5f];
}

- (void) loop:(ccTime)dt
{
    if ([notes_ count] > noteIndex_) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_++];
        
        KeyType keyType = [key integerValue];
        
        // As long as not blank, play the note and store
        if (keyType != kBlankNote) {
            [queue_ addObject:key];
            [instructor_ showSing];
            [noteGenerator_ addInstructorNote:keyType numID:noteIndex_];
        }
        
        // Check if this is the last note
        if ([notes_ count] == noteIndex_) {
            onLastNote_ = YES;
            [self unschedule:@selector(loop:)];                     
        }
    } 
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    if (!ignoreInput_) {
        NSNumber *key = [NSNumber numberWithInteger:keyType];
    
        if ([queue_ count] > 0) {
            
            NSNumber *correctNote = [queue_ objectAtIndex:0];            
            
            // Correct note played
            if ([key isEqualToNumber:correctNote]) {
                [queue_ removeObjectAtIndex:0];
                [noteGenerator_ popOldestNote];
                
                // This note is the last note in the song
                if (onLastNote_ && [queue_ count] == 0) {
                    keyboard_.isClickable = NO;
                    ignoreInput_ = YES;            
                    [self runDelayedEndSpeech];                         
                }
            }
            // Incorrect note played
            else {
                [instructor_ showWrongNote];
            }
        }
    }
}

- (void) noteCrossedBoundary:(Note *)note
{
    [queue_ removeObject:[NSNumber numberWithUnsignedInteger:note.numID]];            
    [noteGenerator_ popNoteWithID:note.numID];
    [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];    
    [instructor_ showWrongNote];    
    
    // This note is the last note in the song
    if (onLastNote_ && [queue_ count] == 0) {
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];                         
    }        
}

- (void) speechComplete:(SpeechType)speechType
{
    switch (speechType) {
            // From start speech, go to directly to gameplay or test play
        case kMediumInstructions:
            [self start];
            break;
        case kSongStart:
            [self start]; 
            break;
        case kMediumReplay:
            [self start];
            break;
        case kSongComplete:
            [self endSong];
            break;            
        default:
            keyboard_.isClickable = YES;
            break;
    }
}

- (void) endSong
{
    scoreInfo_.notesMissed = [Utility countNumBoolInDictionary:NO dictionary:notesHit_];
    scoreInfo_.notesHit = [notesHit_ count] - scoreInfo_.notesMissed;

    [keyboard_ applause];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

@end
