//
//  GameLogicF.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/19/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicF.h"
#import "Utility.h"
#import "DataUtility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "Note.h"
#import "SpeechReader.h"
#import "AudioManager.h"
#import "BubbleGroup.h"
#import "Sunbeams.h"

@implementation GameLogicF

static const CGFloat GLF_INSTRUCTOR_X = 200.0f;
static const CGFloat GLF_INSTRUCTOR_Y = 550.0f;
static const CGFloat GLF_KEYBOARD_X = 100.0f;
static const CGFloat GLF_KEYBOARD_Y = 75.0f;
static const CGFloat GLF_READER_OFFSET_X = 225.0f;
static const CGFloat GLF_READER_OFFSET_Y = 75.0f;
static const CGFloat GLF_BUBBLE_X = 350.0f;
static const CGFloat GLF_BUBBLE_Y = 200.0f;

static const NSInteger GLF_BACKGROUND_Z = 1;
static const NSInteger GLF_SUNBEAMS_Z = 2;
static const NSInteger GLF_BUBBLES_Z = 3;
static const NSInteger GLF_INSTRUCTOR_Z = 4;
static const NSInteger GLF_NOTE_Z = 5;
static const NSInteger GLF_FOREGROUND_Z = 6;
static const NSInteger GLF_KEYBOARD_Z = 7;
static const NSInteger GLF_READER_Z = 8;

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
        score_ = [[Utility initializeScoreDictionary:notes_] retain];         
        
        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background z:GLF_BACKGROUND_Z];            
        
        sunbeams_ = [[Sunbeams sunbeamsRandom:NUM_SUNBEAMS] retain];
        [self addChild:sunbeams_ z:GLF_SUNBEAMS_Z];            
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(GLF_INSTRUCTOR_X, GLF_INSTRUCTOR_Y);
        [self addChild:instructor_ z:GLF_INSTRUCTOR_Z];           
        
        bubbles_ = [[BubbleGroup bubbleGroupWithBubbles:0.02f] retain];
        bubbles_.position = ccp(GLF_BUBBLE_X, GLF_BUBBLE_Y);
        [self addChild:bubbles_ z:GLF_BUBBLES_Z];            
        
        noteGenerator_ = [[NoteGenerator noteGenerator] retain];
        noteGenerator_.delegate = self;        
        [self addChild:noteGenerator_ z:GLF_NOTE_Z];  
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground z:GLF_FOREGROUND_Z];        

        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isKeyboardMuted = YES;
        keyboard_.position = ccp(GLF_KEYBOARD_X, GLF_KEYBOARD_Y);
        [self addChild:keyboard_ z:GLF_KEYBOARD_Z];           
        
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
        if ([[DataUtility manager] isFirstPlayForDifficulty:kDifficultyMedium]) {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechMediumTutorial]];
        }
        else {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechRandomSaying]];            
        }
        
        [dialogue addObject:[NSNumber numberWithInteger:kSpeechSongStart]];
        
        reader_ = [[SpeechReader speechReader:dialogue prompt:NO] retain];
        reader_.delegate = self;
        reader_.position = ccp(GLF_INSTRUCTOR_X + GLF_READER_OFFSET_X, GLF_INSTRUCTOR_Y + GLF_READER_OFFSET_Y);
        [self addChild:reader_ z:GLF_READER_Z];         
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [queueByID_ release];
    [queueByKey_ release];
    [score_ release];
    [keyboard_ release];
    [noteGenerator_ release];
    [reader_ release];    
    [bubbles_ release];
    [sunbeams_ release];
    
    [super dealloc];
}

- (void) start
{
    keyboard_.isClickable = YES;
    [self schedule:@selector(loop:) interval:1.25f];
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
                    [self endSong];                         
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
    [score_ setObject:[NSNumber numberWithInteger:kNoteMissed] forKey:[NSNumber numberWithUnsignedInteger:note.numID]];       
    
    // This note is the last note in the song
    if (onLastNote_ && [queueByID_ count] == 0) {
        ignoreInput_ = YES;            
        [self endSong];     
    }        
}

- (void) removeNote
{
    NSUInteger numID = [[queueByID_ objectAtIndex:0] unsignedIntegerValue];
    [queueByID_ removeObjectAtIndex:0];
    [queueByKey_ removeObjectAtIndex:0];       
    [noteGenerator_ popNoteWithID:numID];
}

- (void) endSong
{
    scoreInfo_ = [Utility tallyScoreDictionary:score_ scoreInfo:scoreInfo_];   
    
    keyboard_.isKeyboardMuted = NO;
    keyboard_.isClickable = NO;
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:2.0f];
    CCActionInstant *done = [CCCallBlock actionWithBlock:^{
        [keyboard_ applause];
    }];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

@end
