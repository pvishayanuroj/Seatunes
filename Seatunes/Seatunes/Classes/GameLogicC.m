//
//  GameLogicC.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicC.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "AudioManager.h"

@implementation GameLogicC

#pragma mark - Object Lifecycle

+ (id) gameLogicC:(NSString *)songName
{
    return [[[self alloc] initGameLogicC:songName] autorelease];
}

- (id) initGameLogicC:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyHard])) {
        
        sections_ = [[Utility loadSectionedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        notesHit_ = [[Utility generateBoolArray:YES size:[Utility countNumNotesFromSections:sections_]] retain];        
        
        playerNoteIndex_ = 0;
        sectionIndex_ = 0;
        
        // If first time playing
        if (isFirstPlay_) {
            [self runSingleSpeech:kHardInstructions tapRequired:YES];
        }
        else { 
            [self runSingleSpeech:kSongStart tapRequired:YES];
        }           
    }
    return self;
}

- (void) dealloc
{
    [sections_ release];
    [queue_ release];
    
    [super dealloc];
}

#pragma mark - Helper Methods

- (void) startSection
{
    keyboard_.isClickable = NO;
    ignoreInput_ = YES;
    
    notes_ = [[sections_ objectAtIndex:sectionIndex_++] retain];
    noteIndex_ = 0;
    
    [self schedule:@selector(loop) interval:1.0f];    
}

- (void) loop
{
    // Play next note
    if ([notes_ count] > noteIndex_) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_++];
        
        KeyType keyType = [key integerValue];
        
        if (keyType != kBlankNote) {
            [queue_ addObject:key];
        }
        
        [instructor_ playNote:keyType];  
        [keyboard_ playNote:keyType time:0.5f withSound:NO];            
        [[AudioManager audioManager] playSound:keyType instrument:kLowStrings];        
    } 
    // Finished playing notes in section
    else {
        [self unschedule:@selector(loop)]; 
        [notes_ release];
        [self runSingleSpeech:kHardPlay tapRequired:NO];
    }    
}

- (void) replay
{
    numWrongNotes_ = 0;
    replayNoteIndex_ = 0;
    ignoreInput_ = YES;
    replayNotes_ = [[NSMutableArray arrayWithCapacity:3] retain];
    for (NSUInteger i = 0; i < 3; i++) {
        if (i < [queue_ count]) {
            [replayNotes_ addObject:[queue_ objectAtIndex:i]];
        }
        else {
            break;
        }
    }

    [self schedule:@selector(replayLoop) interval:1.0f];
}

- (void) replayLoop
{
    // Play next note
    if ([replayNotes_ count] > replayNoteIndex_) {
        
        NSNumber *key = [replayNotes_ objectAtIndex:replayNoteIndex_++];
        KeyType keyType = [key integerValue];
        [instructor_ playNote:keyType];        
        [keyboard_ playNote:keyType time:0.5f withSound:NO];            
        [[AudioManager audioManager] playSound:keyType instrument:kLowStrings];                
    } 
    // Finished playing notes in section
    else {
        [self unschedule:@selector(replayLoop)];
        [replayNotes_ release];
        keyboard_.isClickable = YES;
        ignoreInput_ = NO;
    }     
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    // Playing the example note causes the delegate to be called
    if (!ignoreInput_) {    
        NSNumber *key = [NSNumber numberWithInteger:keyType];
        NSNumber *correctNote = [queue_ objectAtIndex:0];
        
        // Correct note played
        if ([key isEqualToNumber:correctNote]) {
            numWrongNotes_ = 0;
            [queue_ removeObjectAtIndex:0];
            playerNoteIndex_++; 
            
            // Section end
            if ([queue_ count] == 0) {
                keyboard_.isClickable = NO;
                // More sections left
                if (sectionIndex_ < [sections_ count]) {
                    [self runSingleSpeech:kNextSection tapRequired:YES];
                }
                // Song complete
                else {
                    ignoreInput_ = YES;
                    [self runDelayedEndSpeech];
                }                     
            }
            
        }
        // Incorrect note played
        else {
            numWrongNotes_++;                        
            [instructor_ showWrongNote];
            [notesHit_ replaceObjectAtIndex:playerNoteIndex_ withObject:[NSNumber numberWithBool:NO]];                            
            
            // If wrong note played three times in a row, replay the note                
            if (numWrongNotes_ == 3) {
                keyboard_.isClickable = NO;
                [self runSingleSpeech:kHardReplay tapRequired:NO];
            }
        }
    }
}

- (void) speechComplete:(SpeechType)speechType
{
    switch (speechType) {
        case kHardInstructions:
            [self startSection];
            break;
        case kSongStart:
            [self startSection];            
            break;
        case kNextSection:
            [self startSection];
            break;
        case kHardPlay:
            keyboard_.isClickable = YES;
            ignoreInput_ = NO;
            break;
        case kHardReplay:
            [self replay];
            break;
        case kSongComplete:
            [self endSong];
            break;
        default:
            break;
    }
}

- (void) endSong
{
    scoreInfo_.notesMissed = [Utility countNumBool:NO array:notesHit_];
    scoreInfo_.notesHit = [notesHit_ count] - scoreInfo_.notesMissed;    
    
    if (scoreInfo_.notesMissed == 0) {
        scoreInfo_.score = kScoreThreeStar;
    }
    else {
        scoreInfo_.score = kScoreTwoStar;
    }
    
    [keyboard_ applause];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

@end
