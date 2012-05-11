//
//  GameLogicD.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicD.h"
#import "Utility.h"
#import "DataUtility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "Note.h"
#import "SpeechReader.h"
#import "NoteGenerator.h"
#import "AudioManager.h"
#import "BubbleGroup.h"

@implementation GameLogicD

static const CGFloat GLD_INSTRUCTOR_X = 200.0f;
static const CGFloat GLD_INSTRUCTOR_Y = 550.0f;
static const CGFloat GLD_READER_OFFSET_X = 225.0f;
static const CGFloat GLD_READER_OFFSET_Y = 75.0f;
static const CGFloat GLD_BUBBLE_X = 350.0f;
static const CGFloat GLD_BUBBLE_Y = 200.0f;

+ (id) gameLogicD:(NSString *)songName
{
    return [[[self alloc] initGameLogicD:songName] autorelease];
}

- (id) initGameLogicD:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyEasy])) {
        
        noteIndex_ = 0;
        playerNoteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
        score_ = [[Utility initializeScoreDictionary:notes_] retain];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];         
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLD_INSTRUCTOR_X, GLD_INSTRUCTOR_Y);
        [self addChild:instructor_];        
        
        bubbles_ = [[BubbleGroup bubbleGroupWithBubbles:0.02f] retain];
        bubbles_.position = ccp(GLD_BUBBLE_X, GLD_BUBBLE_Y);
        [self addChild:bubbles_];               
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;
        [self addChild:noteGenerator_];   
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];
        
        NSMutableArray *dialogue = [NSMutableArray array];
        
        // If first time playing entire game, play game introduction
        if ([[DataUtility manager] isFirstPlay]) {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechIntroduction]];
        }
        // Otherwise, play normal greeting
        else { 
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechGreetings]];
        }
        
        // If first time playing difficulty level, play tutorial
        if ([[DataUtility manager] isFirstPlayForDifficulty:kDifficultyEasy]) {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechEasyTutorial]];
        }
        else {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechRandomSaying]];            
        }
        
        [dialogue addObject:[NSNumber numberWithInteger:kSpeechSongStart]];
        
        reader_ = [[SpeechReader speechReader:dialogue prompt:NO] retain];
        reader_.delegate = self;
        reader_.position = ccp(GLD_INSTRUCTOR_X + GLD_READER_OFFSET_X, GLD_INSTRUCTOR_Y + GLD_READER_OFFSET_Y);
        [self addChild:reader_];          
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [queue_ release];
    [score_ release];
    [noteGenerator_ release];
    [reader_ release];
    [bubbles_ release];
    
    [super dealloc];
}

- (void) start
{
    [self schedule:@selector(loop:) interval:1.25f];
}

- (void) loop:(ccTime)dt
{
    if ([notes_ count] > noteIndex_) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_];
        KeyType keyType = [key integerValue];
        
        if (keyType != kBlankNote) {
            [queue_ addObject:[NSNumber numberWithUnsignedInteger:noteIndex_]];
            [noteGenerator_ addFloorNote:keyType numID:noteIndex_];
        }
        
        // Check if this is the last note
        if (([notes_ count] - 1) == noteIndex_) {
            onLastNote_ = YES;
            [self unschedule:@selector(loop:)];                     
        }
        
        noteIndex_++;
    } 
}

#pragma mark - Delegate Methods

- (void) narrationStarting:(SpeechType)speechType
{
    [instructor_ showTalk];     
}

- (void) narrationStopped:(SpeechType)speechType
{
    [instructor_ resetIdleFrame];    
}

- (void) speechComplete:(SpeechType)speechType
{
    [instructor_ resetIdleFrame];
    
    switch (speechType) {
        case kSpeechSongStart:
            reader_.visible = NO;
            [self start];
            break;
        default:
            break;
    }
}

- (void) noteTouched:(Note *)note
{   
    if ([queue_ count] > 0) {
        
        NSNumber *key = [NSNumber numberWithUnsignedInteger:note.numID];
        NSNumber *correctNote = [queue_ objectAtIndex:0];                    
        
        [noteGenerator_ popNoteWithID:note.numID]; 
        
        // Correct note played
        if ([key isEqualToNumber:correctNote]) {
            [[AudioManager audioManager] playSound:note.keyType instrument:kPiano];
        }
        // Incorrect note played
        else {
            [[AudioManager audioManager] playSoundEffect:kBubblePop];
            [instructor_ showWrongNote];
            [score_ setObject:[NSNumber numberWithInteger:kNoteMissed] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];
        }           
        [queue_ removeObject:[NSNumber numberWithUnsignedInteger:note.numID]];       
        
        // This note is the last note in the song
        if (onLastNote_ && [queue_ count] == 0) {
            ignoreInput_ = YES;            
            [self endSong];                          
        }        
    }
}
 
- (void) noteCrossedBoundary:(Note *)note
{
    [[AudioManager audioManager] playSoundEffect:kBubblePop];
    [queue_ removeObject:[NSNumber numberWithUnsignedInteger:note.numID]];            
    [noteGenerator_ popNoteWithID:note.numID];
    [score_ setObject:[NSNumber numberWithInteger:kNoteMissed] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];    
    [instructor_ showWrongNote];    
    
    // This note is the last note in the song
    if (onLastNote_ && [queue_ count] == 0) {
        ignoreInput_ = YES;            
        [self endSong];                      
    }    
}

- (void) endSong
{
    scoreInfo_ = [Utility tallyScoreDictionary:score_ scoreInfo:scoreInfo_];   
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:2.0f];
    CCActionInstant *done = [CCCallBlock actionWithBlock:^{
        [delegate_ songComplete:scoreInfo_];    
    }];
    
    [self runAction:[CCSequence actions:delay, done, nil]];    
}

@end
