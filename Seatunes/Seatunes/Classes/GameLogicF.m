//
//  GameLogicF.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/19/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicF.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "Note.h"
#import "SpeechReader.h"
#import "AudioManager.h"

@implementation GameLogicF

static const CGFloat GLF_INSTRUCTOR_X = 200.0f;
static const CGFloat GLF_INSTRUCTOR_Y = 550.0f;
static const CGFloat GLF_KEYBOARD_X = 100.0f;
static const CGFloat GLF_KEYBOARD_Y = 100.0f;

+ (id) gameLogicF:(NSString *)songName
{
    return [[[self alloc] initGameLogicF:songName] autorelease];
}

- (id) initGameLogicF:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        noteIndex_ = 0;
        ignoreInput_ = NO;
        onLastNote_ = NO;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queueByID_ = [[NSMutableArray arrayWithCapacity:5] retain];
        queueByKey_ = [[NSMutableArray arrayWithCapacity:5] retain];        
        
        notesHit_ = [[Utility generateBoolDictionary:YES size:[notes_ count]] retain];   
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLF_INSTRUCTOR_X, GLF_INSTRUCTOR_Y);
        [self addChild:instructor_];           
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;        
        [self addChild:noteGenerator_];  
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        

        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(GLF_KEYBOARD_X, GLF_KEYBOARD_Y);
        [self addChild:keyboard_];           
        
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [queueByID_ release];
    [queueByKey_ release];
    [notesHit_ release];
    [keyboard_ release];
    [noteGenerator_ release];
    
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

- (void) keyboardKeyPressed:(KeyType)keyType
{
    if (!ignoreInput_) {
        
        if ([queueByID_ count] > 0) {
            
            // The expected key
            NSNumber *key = [queueByKey_ objectAtIndex:0];
            
            // If correct note played
            if ([key integerValue] == keyType) {
                [self removeNote];
                [[AudioManager audioManager] playSound:keyType instrument:kPiano];
                
                // This note is the last note in the song
                if (onLastNote_ && [queueByID_ count] == 0) {
                    ignoreInput_ = YES;            
                    [self runDelayedEndSpeech];                         
                }                  
            }
            // Else incorrect note played
            else {
                [instructor_ showWrongNote];
                [[AudioManager audioManager] playSound:keyType instrument:kMuted];
            }
        }       
    }
}

- (void) noteCrossedBoundary:(Note *)note
{
    [self removeNote];
    [notesHit_ setObject:[NSNumber numberWithBool:NO] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];       
    
    // This note is the last note in the song
    if (onLastNote_ && [queueByID_ count] == 0) {
        ignoreInput_ = YES;            
        [self runDelayedEndSpeech];                         
    }        
}

- (void) removeNote
{
    NSUInteger numID = [[queueByID_ objectAtIndex:0] unsignedIntegerValue];
    [queueByID_ removeObjectAtIndex:0];
    [queueByKey_ removeObjectAtIndex:0];       
    [noteGenerator_ popNoteWithID:numID];
}

- (void) speechComplete:(SpeechType)speechType
{
    /*
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
     */
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
