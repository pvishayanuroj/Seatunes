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

+ (id) gameLogicB:(NSString *)songName
{
    return [[[self alloc] initGameLogicB:songName] autorelease];
}

- (id) initGameLogicB:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        playerNoteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        notesHit_ = [[Utility generateBoolArray:YES size:[Utility countNumNotes:notes_]] retain];        
        
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
                playerNoteIndex_++;
                
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
                [notesHit_ replaceObjectAtIndex:playerNoteIndex_ withObject:[NSNumber numberWithBool:NO]];            
            }
        }
    }
}

- (void) noteCrossedBoundary:(Note *)note
{
    NSUInteger numQueued = [queue_ count];

    for (NSUInteger i = 0; i < numQueued; ++i) {
        [noteGenerator_ popOldestNote];
    }
    
    [self unschedule:@selector(loop:)];
    keyboard_.isClickable = NO;
    noteIndex_ -= numQueued;
    [queue_ removeAllObjects];
    [self runSingleSpeech:kMediumReplay tapRequired:YES];
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
    scoreInfo_.notesMissed = [Utility countNumBool:NO array:notesHit_];
    scoreInfo_.notesHit = [notesHit_ count] - scoreInfo_.notesMissed;

    [keyboard_ applause];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

@end
