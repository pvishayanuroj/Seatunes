//
//  GameLogicD.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicD.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "Note.h"
#import "SpeechReader.h"
#import "NoteGenerator.h"
#import "AudioManager.h"

@implementation GameLogicD

static const CGFloat GLD_INSTRUCTOR_X = 200.0f;
static const CGFloat GLD_INSTRUCTOR_Y = 550.0f;

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
        notesHit_ = [[Utility generateBoolDictionary:YES size:[notes_ count]] retain];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];         
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLD_INSTRUCTOR_X, GLD_INSTRUCTOR_Y);
        [self addChild:instructor_];        
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;
        [self addChild:noteGenerator_];   
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];
        
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
    [noteGenerator_ release];
    
    [super dealloc];
}

- (void) start
{
    [self schedule:@selector(loop:) interval:1.5f];
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

- (void) noteTouched:(Note *)note
{
    [[AudioManager audioManager] playSound:note.keyType instrument:kPiano];
    
    if ([queue_ count] > 0) {
        
        NSNumber *key = [NSNumber numberWithUnsignedInteger:note.numID];
        NSNumber *correctNote = [queue_ objectAtIndex:0];                    
        
        [noteGenerator_ popNoteWithID:note.numID]; 
        
        // Correct note played
        if ([key isEqualToNumber:correctNote]) {

        }
        // Incorrect note played
        else {
            [instructor_ showWrongNote];
            [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];
        }           
        [queue_ removeObject:[NSNumber numberWithUnsignedInteger:note.numID]];       
        
        // This note is the last note in the song
        if (onLastNote_ && [queue_ count] == 0) {
            ignoreInput_ = YES;            
            [self runDelayedEndSpeech];                         
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
            break;
    }
}

- (void) endSong
{
    scoreInfo_.notesMissed = [Utility countNumBoolInDictionary:NO dictionary:notesHit_];
    scoreInfo_.notesHit = [notesHit_ count] - scoreInfo_.notesMissed;
    [delegate_ songComplete:scoreInfo_];    
}

@end
