//
//  GameLogicA.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicA.h"
#import "SpeechReader.h"
#import "Utility.h"
#import "Instructor.h"
#import "Keyboard.h"
#import "NoteGenerator.h"

#import "AudioManager.h"

@implementation GameLogicA

+ (id) gameLogicA:(NSString *)songName
{
    return [[[self alloc] initGameLogicA:songName] autorelease];
}

- (id) initGameLogicA:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyEasy])) {
    
        noteIndex_ = 0;
        numWrongNotes_ = 0;
        playerNoteIndex_ = 0;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        notesHit_ = [[Utility generateBoolArray:YES size:[Utility countNumNotes:notes_]] retain];
        
        // If first time playing
        if (isFirstPlay_) {
            [super runSingleSpeech:kEasyInstructions tapRequired:YES];
        }
        else { 
            [super runSingleSpeech:kSongStart tapRequired:YES];
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
    keyboard_.isClickable = NO;    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:1.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(forward)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) forward
{
    // If more notes to play
    if (noteIndex_ < [notes_ count]) {
        
        // Get note type
        NSNumber *key = [notes_ objectAtIndex:noteIndex_++];
        KeyType keyType = [key integerValue];
        
        // Play the note
        if (keyType != kBlankNote) {
            [queue_ addObject:key];  
            [self playExampleNote:keyType];      
        }
        // Skip blank notes
        else {
            [self forward];
        }
    }   
    // Song complete
    else {
        keyboard_.isClickable = NO;
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];
    }
}

- (void) replay
{
    NSUInteger index = noteIndex_ - 1;
    if (index < [notes_ count]) { 
        KeyType keyType = [[notes_ objectAtIndex:index] integerValue];
        if (keyType != kBlankNote) {     
            [self playExampleNote:keyType];
        }
    }
}

- (void) playExampleNote:(KeyType)keyType
{
    keyboard_.isClickable = NO;
    ignoreInput_ = YES;
    numWrongNotes_ = 0;
    
    [noteGenerator_ addInstructorNote:keyType numID:0];
    //[instructor_ showSing];
    [keyboard_ playNote:keyType time:1.0f withSound:NO];    
    [[AudioManager audioManager] playSound:keyType instrument:kLowStrings];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(donePlaying)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) donePlaying
{
    keyboard_.isClickable = YES;
    ignoreInput_ = NO;
    
    [self delayedReplay];
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    // Playing the example note causes the delegate to be called
    if (!ignoreInput_) {
        NSNumber *key = [NSNumber numberWithInteger:keyType];
        
        if ([queue_ count] > 0) {
            
            // Cancel delayed replay
            [self stopAllActions];
            
            scoreInfo_.notesHit++;
            keyboard_.isClickable = NO;            
            NSNumber *correctNote = [queue_ objectAtIndex:0];
            
            // Correct note played
            if ([key isEqualToNumber:correctNote]) {
                [queue_ removeObjectAtIndex:0];
                //[noteGenerator_ popNewestNote];
                
                // If first time and first note, show an encouraging message
                if (isFirstPlay_ && noteIndex_ == 1) {
                    [super runSingleSpeech:kEasyCorrectNote tapRequired:NO];
                }
                else {
                    [self start];
                }
            }
            // Incorrect note played
            else {
                numWrongNotes_++;
                [instructor_ showWrongNote];
                [notesHit_ replaceObjectAtIndex:(noteIndex_ - 1) withObject:[NSNumber numberWithBool:NO]];
                
                // If the first time and first note, show a more detailed message
                if (isFirstPlay_ && noteIndex_ == 1) {
                    NSArray *text = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kEasyWrongNote], 
                                                              [NSNumber numberWithInteger:kEasyReplay], nil];
                    [super runSpeech:text tapRequired:NO];
                }
                // If wrong note played three times in a row, replay the note
                else if (numWrongNotes_ == 3) {
                    [super runSingleSpeech:kEasyReplay tapRequired:NO];
                }
                // Wrong note played (less than three times)
                else {
                    [self delayedReplay];
                    [super runSingleSpeech:kWrongNote tapRequired:NO];                    
                }
            }
        }
    }
}

- (void) speechComplete:(SpeechType)speechType
{
    switch (speechType) {
        // From start speech, go to directly to gameplay or test play
        case kEasyInstructions:
            [self startTestPlay];
            break;
        case kEasyInstructions2:
            [self start];
            break;
        case kEasyCorrectNote:
            [self start];
            break;
        case kSongStart:
            [self start];
            break;
        case kEasyReplay:
            [self replay];
            break;
        case kSongComplete:
            [self endSong];
            break;                        
        default:
            keyboard_.isClickable = YES;
            break;
    }
}

- (void) startTestPlay
{
    keyboard_.isClickable = YES;
    CCActionInterval *delay = [CCDelayTime actionWithDuration:3.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(endTestPlay)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) endTestPlay
{
    keyboard_.isClickable = NO;    
    [super runSingleSpeech:kEasyInstructions2 tapRequired:YES];
}

- (void) delayedReplay
{
    [self stopAllActions];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:10.0f];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(replay)];
    [self runAction:[CCSequence actions:delay, method, nil]];    
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
