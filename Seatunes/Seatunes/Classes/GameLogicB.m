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
#import "AudioManager.h"
#import "Light.h"

@implementation GameLogicB

static const CGFloat GLB_INSTRUCTOR_X = 200.0f;
static const CGFloat GLB_INSTRUCTOR_Y = 265.0f;
static const CGFloat GLB_KEYBOARD_X = 100.0f;
static const CGFloat GLB_KEYBOARD_Y = 100.0f;
static const CGFloat GLB_LIGHT_X = 800.0f;
static const CGFloat GLB_LIGHT_Y = 600.0f;

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
        notesToRemove_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        CCSprite *background = [CCSprite spriteWithFile:@"Game Background Dark.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];             
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(GLB_KEYBOARD_X, GLB_KEYBOARD_Y);
        [self addChild:keyboard_];                
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;        
        [self addChild:noteGenerator_];  
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLB_INSTRUCTOR_X, GLB_INSTRUCTOR_Y);
        [self addChild:instructor_];        
        
        light_ = [Light light];
        light_.position = ccp(GLB_LIGHT_X, GLB_LIGHT_Y);
        [self addChild:light_];

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
    [notesToRemove_ release];
    [keyboard_ release];
    [noteGenerator_ release];
    
    [super dealloc];
}

- (void) start
{
    keyboard_.isClickable = YES;
    [self schedule:@selector(loop:) interval:1.5f];
    [self schedule:@selector(lightLoop:) interval:1.0f/60.0f];
}

- (void) loop:(ccTime)dt
{
    if ([notes_ count] > noteIndex_) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_];
        
        KeyType keyType = [key integerValue];
        
        // As long as not blank, play the note and store
        if (keyType != kBlankNote) {
            [queue_ addObject:[NSNumber numberWithUnsignedInteger:noteIndex_]];
            [instructor_ showSing];
            [noteGenerator_ addInstructorNote:keyType numID:noteIndex_];
        }
        
        // Check if this is the last note
        if (([notes_ count] - 1) == noteIndex_) {
            onLastNote_ = YES;
            [self unschedule:@selector(loop:)];                     
        }
        
        noteIndex_++;
    } 
}

- (void) lightLoop:(ccTime)dt
{
    NSArray *notes = noteGenerator_.notes;
    
    for (Note *note in notes) {
        if (!note.lightCrossFlag) {
            if ([light_ noteIntersectLight:note]) {
                note.lightCrossFlag = YES;                
                if ([light_ noteWithinLight:note]) {
                    [self noteFullyInLight:note];
                }
                else {
                    [self notePartiallyInLight:note];
                }
            }
        }
    }

    for (Note *note in notesToRemove_) {
        [noteGenerator_ popNoteWithID:note.numID];
    }
   
    [notesToRemove_ removeAllObjects];    
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    if (!ignoreInput_) {
        
        [light_ turnOn:keyType];
        
        BOOL flag = YES;
        NSArray *notes = noteGenerator_.notes;        
        for (Note *note in notes) {
            if (!note.lightCrossFlag) {
                if ([light_ noteIntersectLight:note]) {    
                    flag = NO;
                    break;
                }
            }
        }        
        
        if (flag) {
            [[AudioManager audioManager] playSoundEffect:kClamHit];            
        }
    }
}

- (void) keyboardKeyDepressed:(KeyType)keyType time:(CGFloat)time
{
    [light_ turnOff];
}

- (void) noteCrossedBoundary:(Note *)note
{
    [self removeNote:note];
    [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];       
    
    // This note is the last note in the song
    if (onLastNote_ && [queue_ count] == 0) {
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];                         
    }        
}

- (void) noteFullyInLight:(Note *)note
{
    [[AudioManager audioManager] playSound:note.keyType instrument:kPiano];
    [self removeNote:note];  
    
    // This note is the last note in the song
    if (onLastNote_ && [queue_ count] == 0) {
        keyboard_.isClickable = NO;
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];                         
    }    
}

- (void) notePartiallyInLight:(Note *)note
{
    [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];     
    
    [[AudioManager audioManager] playSoundEffect:kBubblePop];
    [self removeNote:note];            
    
    // This note is the last note in the song
    if (onLastNote_ && [queue_ count] == 0) {
        keyboard_.isClickable = NO;
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];                         
    }    
}

- (void) removeNote:(Note *)note
{
    [queue_ removeObject:[NSNumber numberWithUnsignedInteger:note.numID]];           
    [notesToRemove_ addObject:note];
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

    keyboard_.isKeyboardMuted = NO;
    [keyboard_ applause];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

@end
