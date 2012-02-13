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

#import "AudioManager.h"

@implementation GameLogicA

static const CGFloat GLA_BUBBLE_X = 620.0f;
static const CGFloat GLA_BUBBLE_Y = 500.0f;

+ (id) gameLogicA:(NSString *)songName
{
    return [[[self alloc] initGameLogicA:songName] autorelease];
}

- (id) initGameLogicA:(NSString *)songName
{
    if ((self = [super init])) {
        
        isFirstPlay_ = false;
        noteIndex_ = 0;
        numWrongNotes_ = 0;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        // If first time playing
        if (isFirstPlay_) {
            [self runSingleSpeech:kEasyInstructions tapRequired:NO];
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
    keyboard_.isClickable = NO;    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:1.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(forward)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) forward
{
    if (noteIndex_ < [notes_ count]) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_++];
        
        KeyType keyType = [key integerValue];
        
        if (keyType != kBlankNote) {
            [queue_ addObject:key];  
            [self playExampleNote:keyType];      
        }
        else {
            [self forward];
        }
    }   
    else {
        NSLog(@"Song complete");
    }
}

- (void) replay
{
    if (noteIndex_ < [notes_ count]) { 
        KeyType keyType = [[notes_ objectAtIndex:(noteIndex_ - 1)] integerValue];
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
    
    [instructor_ playNote:keyType];  
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
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    // Playing the example note causes the delegate to be called
    if (!ignoreInput_) {
        NSNumber *key = [NSNumber numberWithInteger:keyType];
        
        if ([queue_ count] > 0) {
            
            keyboard_.isClickable = NO;            
            NSNumber *correctNote = [queue_ objectAtIndex:0];
            
            // Correct note played
            if ([key isEqualToNumber:correctNote]) {
                [queue_ removeObjectAtIndex:0];
                [instructor_ popOldestNote];
                
                // If first time and first note, show an encouraging message
                if (isFirstPlay_ && noteIndex_ == 1) {
                    [self runSingleSpeech:kEasyCorrectNote tapRequired:NO];
                }
                else {
                    [self start];
                }
            }
            // Incorrect note played
            else {
                numWrongNotes_++;
                [instructor_ showWrongNote];
                
                // If the first time and first note, show a more detailed message
                if (isFirstPlay_ && noteIndex_ == 1) {
                    NSArray *text = [NSArray arrayWithObjects:[NSNumber numberWithInteger:kEasyWrongNote], 
                                                              [NSNumber numberWithInteger:kEasyReplay], nil];
                    [self runSpeech:text tapRequired:NO];
                }
                // If wrong note played three times in a row, replay the note
                else if (numWrongNotes_ == 3) {
                    [self runSingleSpeech:kEasyReplay tapRequired:NO];
                }
                // Wrong note played (less than three times)
                else {
                    [self runSingleSpeech:kWrongNote tapRequired:NO];                    
                }
            }
        }
    }
}

- (void) runSingleSpeech:(SpeechType)speechType tapRequired:(BOOL)tapRequired
{
    NSArray *text = [NSArray arrayWithObject:[NSNumber numberWithInteger:speechType]];            
    [self runSpeech:text tapRequired:tapRequired];
}

- (void) runSpeech:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    SpeechReader *reader = [SpeechReader speechReader:speeches tapRequired:tapRequired];
    reader.delegate = self;
    reader.position = ccp(GLA_BUBBLE_X, GLA_BUBBLE_Y);
    [self addChild:reader];        
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
    [self runSingleSpeech:kEasyInstructions2 tapRequired:YES];
}

- (void) delayedReplay
{
    [self stopAllActions];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:10.0f];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(replay)];
    [self runAction:[CCSequence actions:delay, method, nil]];    
}

@end
