//
//  GameLogicE.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicE.h"
#import "Utility.h"
#import "DataUtility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "AudioManager.h"
#import "SpeechReader.h"
#import "Staff.h"
#import "StaffNote.h"
#import "GameScene.h"

@implementation GameLogicE

static const CGFloat GLE_INSTRUCTOR_X = 200.0f;
static const CGFloat GLE_INSTRUCTOR_Y = 350.0f;
static const CGFloat GLE_KEYBOARD_X = 100.0f;
static const CGFloat GLE_KEYBOARD_Y = 75.0f;
static const CGFloat GLE_STAFF_X = 512.0f;
static const CGFloat GLE_STAFF_Y = 600.0f;
static const CGFloat GLE_READER_OFFSET_X = 225.0f;
static const CGFloat GLE_READER_OFFSET_Y = 75.0f;

+ (id) gameLogicE:(NSString *)songName
{
    return [[[self alloc] initGameLogicE:songName] autorelease];
}

- (id) initGameLogicE:(NSString *)songName
{
    if ((self = [super initGameLogic:kDifficultyHard])) {
        
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
         
        NSMutableArray *dialogue = [NSMutableArray array];        
        
        // If first time playing entire game, play game introduction
        if ([[DataUtility manager] isFirstPlay]) {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechIntroduction]];
        }
        // Otherwise, play normal greeting
        else { 
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechGreetings]];
        }        
        
        // Check if hard difficulty has ever been played. If not, prompt to play tutorial
        if ([[DataUtility manager] isFirstPlayForDifficulty:kDifficultyMusicNoteTutorial]) {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechTutorialPrompt]];
        }
        else {
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechRandomSaying]];
            [dialogue addObject:[NSNumber numberWithInteger:kSpeechSongStart]];            
        }        
        
        reader_ = [[SpeechReader speechReader:dialogue prompt:NO] retain];
        reader_.delegate = self;
        reader_.position = ccp(GLE_INSTRUCTOR_X + GLE_READER_OFFSET_X, GLE_INSTRUCTOR_Y + GLE_READER_OFFSET_Y);
        [self addChild:reader_];             
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
    [reader_ release];
    
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

- (void) showPrompt
{
    NSString *title = @"Hey!";
    NSString *text = [NSString stringWithFormat:@"Take the music lesson?"];
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
    [message show];    
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
    
    if (speechType == kSpeechTutorialPrompt) {
        [self showPrompt];
    }
    else if (speechType == kSpeechSongStart) {
        reader_.visible = NO;        
        [self start];
    }
}
         
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Cancel
    if (buttonIndex == 0) {
        NSMutableArray *dialogue = [NSMutableArray arrayWithCapacity:1];
        [dialogue addObject:[NSNumber numberWithInteger:kSpeechSongStart]];      
        [reader_ loadDialogue:dialogue];        
    }
    // OK
    else if (buttonIndex == 1) {
        CCScene *scene = [GameScene startWithDifficulty:kDifficultyMusicNoteTutorial songName:@""];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionPageTurn transitionWithDuration:0.6f scene:scene]];          
    }
}

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
                        [self endSong];                         
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
        [self endSong];                              
    }       
}

- (void) endSong
{
    scoreInfo_.notesMissed = [Utility countNumBoolInDictionary:NO dictionary:notesHit_];
    scoreInfo_.notesHit = [notesHit_ count] - scoreInfo_.notesMissed;
    scoreInfo_.percentage = (NSUInteger)(ceil(scoreInfo_.notesHit / (scoreInfo_.notesHit + scoreInfo_.notesMissed)));    
    
    keyboard_.isKeyboardMuted = NO;    
    [keyboard_ applause];
}

- (void) applauseComplete
{
    [delegate_ songComplete:scoreInfo_];
}

- (void) showLettersComplete
{
    [delegate_ showKeyboardLettersComplete];
}

- (void) hideLettersComplete
{
    [delegate_ hideKeyboardLettersComplete];
}

@end
