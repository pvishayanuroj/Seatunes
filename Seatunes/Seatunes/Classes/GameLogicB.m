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
#import "Note.h"
#import "SpeechReader.h"
#import "Utility.h"

@implementation GameLogicB

+ (id) gameLogicB:(NSString *)songName
{
    return [[[self alloc] initGameLogicB:songName] autorelease];
}

- (id) initGameLogicB:(NSString *)songName
{
    if ((self = [super init])) {
        
        NSString *key = [Utility difficultyPlayedKeyFromEnum:kDifficultyMedium];
        isFirstPlay_ = [[NSUserDefaults standardUserDefaults] boolForKey:key];        
        noteIndex_ = 0;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
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
        
        if (keyType != kBlankNote) {
            [queue_ addObject:key];
        }
        
        [instructor_ playNote:keyType];        
    } 
    else {
        [delegate_ songComplete:scoreInfo_];
    }
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    NSNumber *key = [NSNumber numberWithInteger:keyType];
    
    if ([queue_ count] > 0) {
    
        NSNumber *correctNote = [queue_ objectAtIndex:0];
        
        // Correct note played
        if ([key isEqualToNumber:correctNote]) {
            [queue_ removeObjectAtIndex:0];
            [instructor_ popOldestNote];
        }
        // Incorrect note played
        else {
            NSLog(@"WRONG");
        }
    }
    // Else no pending notes
    else {
        NSLog(@"WRONG");        
    }
}

- (void) noteCrossedBoundary:(Note *)note
{
    [self lossEvent];
}

- (void) lossEvent
{
    [self unschedule:@selector(loop:)];
    NSLog(@"LOSS");
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
        default:
            keyboard_.isClickable = YES;
            break;
    }
}

@end
