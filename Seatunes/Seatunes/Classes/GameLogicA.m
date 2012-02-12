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
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        // If first time playing
        if (isFirstPlay_) {
            [self runSpeech:kEasyInstructions];
        }
        else { 
            [self runSpeech:kSongStart];
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
    CCActionInterval *delay = [CCDelayTime actionWithDuration:1.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(forward)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) forward
{
    if ([notes_ count] > noteIndex_) {
        
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
}

- (void) playExampleNote:(KeyType)keyType
{
    keyboard_.isClickable = NO;
    ignoreInput_ = YES;
    
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
    if (!ignoreInput_) {
        NSNumber *key = [NSNumber numberWithInteger:keyType];
        
        if ([queue_ count] > 0) {
            
            NSNumber *correctNote = [queue_ objectAtIndex:0];
            
            // Correct note played
            if ([key isEqualToNumber:correctNote]) {
                [queue_ removeObjectAtIndex:0];
                [instructor_ popOldestNote];
                [self start];
            }
            // Incorrect note played
            else {
                [instructor_ showWrongNote];
                [self runSpeech:kWrongNote];
            }
        }
        // Else no pending notes
        else {
            NSLog(@"WRONG");        
        }    
    }
}

- (void) runSpeech:(SpeechType)speechType
{
    NSArray *text = [NSArray arrayWithObject:[NSNumber numberWithInteger:speechType]];            
    SpeechReader *reader = [SpeechReader speechReader:text tapRequired:YES];
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
            keyboard_.isClickable = YES;
            [self start];
            break;
        case kSongStart:
            keyboard_.isClickable = YES;            
            [self start];
            break;
        default:
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
    [self runSpeech:kEasyInstructions2];
}

@end
