//
//  MusicNoteTutorial.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/31/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MusicNoteTutorial.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "Staff.h"
#import "Note.h"
#import "SpeechReader.h"
#import "AudioManager.h"

@implementation MusicNoteTutorial

static const CGFloat MNT_INSTRUCTOR_X = 200.0f;
static const CGFloat MNT_INSTRUCTOR_Y = 350.0f;
static const CGFloat MNT_KEYBOARD_X = 100.0f;
static const CGFloat MNT_KEYBOARD_Y = 80.0f;
static const CGFloat MNT_STAFF_X = 512.0f;
static const CGFloat MNT_STAFF_Y = 600.0f;
static const CGFloat MNT_READER_OFFSET_X = 225.0f;
static const CGFloat MNT_READER_OFFSET_Y = 75.0f;

static const CGFloat MNT_NOTE_ADD_DESTROY_DELAY = 1.5f;
static const CGFloat MNT_LETTER_SHOW_DELAY = 1.5f;

+ (id) musicNoteTutorial
{
    return [[[self alloc] initMusicNoteTutorial] autorelease];
}

- (id) initMusicNoteTutorial
{
    if ((self = [super initGameLogic:kDifficultyMedium])) {
        
        notes_ = [[NSMutableArray arrayWithCapacity:8] retain];

        CCSprite *background = [CCSprite spriteWithFile:@"Ocean Background.png"];
        background.anchorPoint = CGPointZero;
        [self addChild:background];            
        
        staff_ = [[Staff staff] retain]; 
        staff_.delegate = self;
        staff_.position = ccp(MNT_STAFF_X, MNT_STAFF_Y);
        [staff_ disableLoop];
        [self addChild:staff_];              
        
        CCSprite *coralBackground = [CCSprite spriteWithFile:@"Coral Foreground.png"];
        coralBackground.anchorPoint = CGPointZero;
        [self addChild:coralBackground];        
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(MNT_INSTRUCTOR_X, MNT_INSTRUCTOR_Y);
        [self addChild:instructor_];            
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.delegate = self;
        keyboard_.isClickable = NO;        
        keyboard_.position = ccp(MNT_KEYBOARD_X, MNT_KEYBOARD_Y);
        [self addChild:keyboard_];        
        
        dialogue_ = [[self addDialogue] retain];
        
        reader_ = [[SpeechReader speechReader:dialogue_ prompt:YES] retain];
        reader_.delegate = self;
        reader_.position = ccp(MNT_INSTRUCTOR_X + MNT_READER_OFFSET_X, MNT_INSTRUCTOR_Y + MNT_READER_OFFSET_Y);
        [self addChild:reader_];          
    } 
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [keyboard_ release];
    [dialogue_ release];
    [reader_ release];
    
    [super dealloc];
}

#pragma mark - Initialization Methods

- (NSArray *) addDialogue
{
    NSMutableArray *dialogue = [NSMutableArray arrayWithCapacity:20];
    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialIntroduction]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialStaff]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialNotes]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialNotes2]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialLetters]];    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialLearnC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayDE]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayFG]];    
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialPlayABC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialMnemonic]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialEvery]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialGood]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialBoy]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialFace]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialF]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialA]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialC]];
    [dialogue addObject:[NSNumber numberWithInteger:kTutorialComplete]];
    
    return dialogue;
}

#pragma mark - Delegate Methods

- (void) bubbleComplete:(SpeechType)speechType
{
    [self eventComplete:speechType];
}

- (void) bubbleClicked:(SpeechType)speechType
{
    [self eventComplete:speechType];    
}

- (void) notesInSequenceAdded
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:MNT_NOTE_ADD_DESTROY_DELAY];
    CCActionInstant *destroy = [CCCallFunc actionWithTarget:staff_ selector:@selector(destroyNotesInSequence)];
    [self runAction:[CCSequence actions:delay, destroy, nil]];
}

- (void) notesInSequenceDestroyed
{
    switch (reader_.currentSpeech) {
        // Lined notes 
        case kTutorialNotes:
            [reader_ nextDialogue];
            break;
        case kTutorialNotes2:
            [reader_ nextDialogue];
            break;
        default:
            break;
    }

    reader_.isClickable = YES;
}

- (void) showLettersComplete
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:MNT_LETTER_SHOW_DELAY];    
    CCActionInstant *next = [CCCallBlock actionWithBlock:^{
        [reader_ nextDialogue];
    }];
    
    [self runAction:[CCSequence actions:delay, next, nil]];
}

- (void) keyboardKeyPressed:(KeyType)keyType
{
    NSLog(@"Keyboard clicked");
    
    if ([notes_ count] > 0) {
        
        // Check if correct note played
        KeyType correctNote = [[notes_ objectAtIndex:0] integerValue];
        if (correctNote == keyType) {
            [notes_ removeObjectAtIndex:0];
            [staff_ removeOldestNote];
            
            // Exceptions where we can continue to the next dialogue without having
            // played all queued notes
            if (reader_.currentSpeech == kTutorialEvery ||
                reader_.currentSpeech == kTutorialGood ||
                reader_.currentSpeech == kTutorialF ||
                reader_.currentSpeech == kTutorialA) {
                NSLog(@"case 1");
                keyboard_.isClickable = NO;             
                [reader_ nextDialogue];    
            }
            else if (reader_.currentSpeech == kTutorialBoy ||
                     reader_.currentSpeech == kTutorialC) {
                NSLog(@"case 2");                
                [staff_ removeAllNotes];
                keyboard_.isClickable = NO;              
                [reader_ nextDialogue];                
            }
            // If this is the last note
            else if ([notes_ count] == 0) {
                NSLog(@"case 3");                                
                keyboard_.isClickable = NO;
                [reader_ nextDialogue];
            }
        }
        // Else incorrect note played
        else {
            
        }
    }
}

#pragma mark - Helper Methods

- (void) blinkStaff
{
    CCActionInstant *start = [CCCallBlock actionWithBlock:^{
        [staff_ blinkStaff:YES];
    }];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:3.0f];
    
    CCActionInstant *stop = [CCCallBlock actionWithBlock:^{
        [staff_ blinkStaff:NO];
    }];    
    
    CCActionInstant *done = [CCCallBlock actionWithBlock:^{
        [self eventComplete:reader_.currentSpeech];
    }];
    
    [self runAction:[CCSequence actions:start, delay, stop, done, nil]];
}

- (void) showLineNotes
{
    reader_.isClickable = NO;
    
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:5];
    [notes addObject:[NSNumber numberWithInteger:kE4]];
    [notes addObject:[NSNumber numberWithInteger:kG4]];    
    [notes addObject:[NSNumber numberWithInteger:kB4]];
    [notes addObject:[NSNumber numberWithInteger:kD5]];
    [notes addObject:[NSNumber numberWithInteger:kF5]];    
    [staff_ addNotesInSequence:notes];
}

- (void) showSpaceNotes
{
    reader_.isClickable = NO;  
    
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:5];
    [notes addObject:[NSNumber numberWithInteger:kD4]];
    [notes addObject:[NSNumber numberWithInteger:kF4]];    
    [notes addObject:[NSNumber numberWithInteger:kA4]];
    [notes addObject:[NSNumber numberWithInteger:kC5]];
    [notes addObject:[NSNumber numberWithInteger:kE5]];    
    [staff_ addNotesInSequence:notes];    
}

- (void) showKeyboardLetters
{
    [keyboard_ showLetters];
}

- (void) showFirstSet
{
    reader_.isClickable = NO;
    
    [notes_ addObject:[NSNumber numberWithInteger:kC4]];  
    [staff_ addNotes:notes_];
}

- (void) showSecondSet
{
    reader_.isClickable = NO;
    
    [notes_ addObject:[NSNumber numberWithInteger:kD4]];  
    [notes_ addObject:[NSNumber numberWithInteger:kE4]];      
    [staff_ addNotes:notes_];    
}

- (void) showThirdSet
{
    reader_.isClickable = NO; 
    
    [notes_ addObject:[NSNumber numberWithInteger:kF4]];  
    [notes_ addObject:[NSNumber numberWithInteger:kG4]];      
    [staff_ addNotes:notes_];    
}

- (void) showFourthSet
{
    reader_.isClickable = NO;  
    
    [notes_ addObject:[NSNumber numberWithInteger:kA4]];  
    [notes_ addObject:[NSNumber numberWithInteger:kB4]];  
    [notes_ addObject:[NSNumber numberWithInteger:kC5]];      
    [staff_ addNotes:notes_];
}

- (void) showLineNotesWithText
{
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:5];
    [notes addObject:[NSNumber numberWithInteger:kE4]];  
    [notes addObject:[NSNumber numberWithInteger:kG4]];  
    [notes addObject:[NSNumber numberWithInteger:kB4]];      
    
    [notes_ addObjectsFromArray:notes];
    
    [notes addObject:[NSNumber numberWithInteger:kD5]];      
    [notes addObject:[NSNumber numberWithInteger:kF5]];   
    
    [staff_ addNotes:notes];
    [staff_ showAlternateNoteNames];
    [reader_ nextDialogue];
}

- (void) showSpaceNotesWithText
{
    NSMutableArray *notes = [NSMutableArray arrayWithCapacity:4];    
    [notes addObject:[NSNumber numberWithInteger:kF4]];  
    [notes addObject:[NSNumber numberWithInteger:kA4]];  
    [notes addObject:[NSNumber numberWithInteger:kC5]];      
    
    [notes_ addObjectsFromArray:notes];    
    
    [notes_ addObject:[NSNumber numberWithInteger:kE5]];      
    
    [staff_ addNotes:notes];
    [staff_ showAlternateNoteNames];   
    [reader_ nextDialogue];    
}

- (void) eventComplete:(SpeechType)speechType
{
    switch (speechType) {
        case kTutorialIntroduction:
            [staff_ blinkStaff:YES];
            [reader_ nextDialogue];
            break;
        case kTutorialStaff:
            [staff_ blinkStaff:NO];
            [reader_ nextDialogue];
            break;
        case kTutorialNotes:
            [self showLineNotes];            
            break;
        case kTutorialNotes2:
            [self showSpaceNotes];             
            break;
        case kTutorialLetters:
            [self showKeyboardLetters];
            break;
        case kTutorialLearnC:
            [self showFirstSet];
            [reader_ nextDialogue];
            break;
        case kTutorialPlayC:
            keyboard_.isClickable = YES;
            break;
        case kTutorialPlayDE:
            [self showSecondSet];          
            keyboard_.isClickable = YES;
            break;
        case kTutorialPlayFG:
            [self showThirdSet];
            keyboard_.isClickable = YES;
            break;
        case kTutorialPlayABC:
            [self showFourthSet];
            keyboard_.isClickable = YES;
            break;
        case kTutorialMnemonic:
            [self showLineNotesWithText];
            break;
        case kTutorialEvery:
            keyboard_.isClickable = YES;            
            break;
        case kTutorialGood:
            keyboard_.isClickable = YES;            
            break;
        case kTutorialBoy:
            keyboard_.isClickable = YES;    
            break;
        case kTutorialFace:
            [self showSpaceNotesWithText];
            break;
        case kTutorialF:
            keyboard_.isClickable = YES;            
            break;
        case kTutorialA:
            keyboard_.isClickable = YES;            
            break;
        case kTutorialC:
            keyboard_.isClickable = YES;                     
            break;
        case kTutorialComplete:
            [delegate_ exerciseComplete];
            break;            
        default:
            break;
    }      
}

@end
