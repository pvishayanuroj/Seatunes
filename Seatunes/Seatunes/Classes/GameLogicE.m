//
//  GameLogicE.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicE.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "AudioManager.h"
#import "SpeechReader.h"
#import "Staff.h"
#import "StaffNote.h"

@implementation GameLogicE

static const CGFloat GLE_INSTRUCTOR_X = 200.0f;
static const CGFloat GLE_INSTRUCTOR_Y = 350.0f;
static const CGFloat GLE_KEYBOARD_X = 100.0f;
static const CGFloat GLE_KEYBOARD_Y = 100.0f;
static const CGFloat GLE_STAFF_X = 512.0f;
static const CGFloat GLE_STAFF_Y = 600.0f;

+ (id) gameLogicE:(NSString *)songName
{
    return [[[self alloc] initGameLogicE:songName] autorelease];
}

- (id) initGameLogicE:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        playerNoteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        onBlankNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queueByID_ = [[NSMutableArray arrayWithCapacity:5] retain];
        queueByKey_ = [[NSMutableArray arrayWithCapacity:5] retain];        
        
        notesHit_ = [[Utility generateBoolDictionary:YES size:[notes_ count]] retain];          
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];                     
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        

        staff_ = [[Staff staff] retain]; 
        staff_.delegate = self;
        staff_.position = ccp(GLE_STAFF_X, GLE_STAFF_Y);
        [self addChild:staff_];  
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLE_INSTRUCTOR_X, GLE_INSTRUCTOR_Y);
        [self addChild:instructor_];           
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(GLE_KEYBOARD_X, GLE_KEYBOARD_Y);
        [self addChild:keyboard_];          
        
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
    [queueByID_ release];
    [queueByKey_ release];
    [notesHit_ release];
    [staff_ release];
    
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
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_];
        KeyType keyType = [key integerValue];
        
        // As long as not blank, play the note and store
        if (keyType != kBlankNote) {
            [queueByID_ addObject:[NSNumber numberWithUnsignedInteger:noteIndex_]];
            [queueByKey_ addObject:[NSNumber numberWithInteger:keyType]];            
            [staff_ addMovingNote:keyType numID:noteIndex_];          
            [instructor_ showSing];
        }
        
        // Check if this is the last note
        if (([notes_ count] - 1) == noteIndex_) {
            onLastNote_ = YES;
            [self unschedule:@selector(loop:)];                     
        }
        
        noteIndex_++;
    } 
}

- (void) removeNote
{
    [queueByID_ removeObjectAtIndex:0];
    [queueByKey_ removeObjectAtIndex:0];       
}

#pragma mark - Delegate Methods

- (void) keyboardKeyPressed:(KeyType)keyType
{
    if (!ignoreInput_) {

        // As long as notes to be played
        if ([queueByID_ count] > 0) {
            
            // As long as note to be played is moving across the staff
            if ([staff_ isOldestNoteActive]) {
                
                NSNumber *key = [queueByKey_ objectAtIndex:0];            
                
                // Correct note played
                if ([key integerValue] == keyType) {
                    
                    [self removeNote];
                    [staff_ removeOldestNote];
                    [[AudioManager audioManager] playSound:keyType instrument:kPiano];                    
                    
                    // This note is the last note in the song
                    if (onLastNote_ && [queueByID_ count] == 0) {
                        keyboard_.isClickable = NO;
                        ignoreInput_ = YES;            
                        [self runDelayedEndSpeech];                         
                    }
                }
                // Incorrect note played
                else {
                    [instructor_ showWrongNote];
                    [[AudioManager audioManager] playSound:keyType instrument:kMuted];          
                }
            }
        }
    }
}

- (void) staffNoteReturned:(StaffNote *)note
{
    [self removeNote];
    [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];       
    
    // This note is the last note in the song
    if (onLastNote_ && [queueByID_ count] == 0) {
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
