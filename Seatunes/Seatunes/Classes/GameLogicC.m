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

+ (id) gameLogicC:(NSString *)songName
{
    return [[[self alloc] initGameLogicC:songName] autorelease];
}

- (id) initGameLogicC:(NSString *)songName
{
    if ((self = [super init])) {

        NSString *key = [Utility difficultyPlayedKeyFromEnum:kDifficultyHard];
        isFirstPlay_ = ![[NSUserDefaults standardUserDefaults] boolForKey:key];            
        
        sections_ = [[Utility loadSectionedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
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

- (void) endSong
{
    if (scoreInfo_.notesMissed == 0) {
        scoreInfo_.score = kScoreTwoStar;
    }
    else {
        scoreInfo_.score = kScoreOneStar;
    }
    [delegate_ songComplete:scoreInfo_];
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
        
        if ([queue_ count] > 0) {
            
            NSNumber *correctNote = [queue_ objectAtIndex:0];
            
            // Correct note played
            if ([key isEqualToNumber:correctNote]) {
                numWrongNotes_ = 0;
                [queue_ removeObjectAtIndex:0];
            }
            // Incorrect note played
            else {
                numWrongNotes_++;                        
                [instructor_ showWrongNote];
                
                if (numWrongNotes_ == 3) {
                    keyboard_.isClickable = NO;
                    [self runSingleSpeech:kHardReplay tapRequired:NO];
                }
            }
        }
        // Else section complete
        else {
            keyboard_.isClickable = YES;
            if (sectionIndex_ < [sections_ count]) {
                [self runSingleSpeech:kNextSection tapRequired:YES];
            }
            else {
                [self endSong];
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
        default:
            break;
    }
}

@end
