//
//  GameLogic.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/11/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogic.h"
#import "Keyboard.h"
#import "Instructor.h"
#import "NoteGenerator.h"
#import "SpeechReader.h"
#import "Utility.h"

@implementation GameLogic

static const CGFloat GL_BUBBLE_X = 630.0f;
static const CGFloat GL_BUBBLE_Y = 600.0f;

@synthesize delegate = delegate_;

+ (id) gameLogic
{
    NSAssert(NO, @"Constructor must be implemented in derived class");
    return nil;
}

- (id) initGameLogic:(DifficultyType)difficulty
{
    if ((self = [super init])) {
        
        NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty];
        isDifficultyFirstPlay_ = ![[NSUserDefaults standardUserDefaults] boolForKey:key];        
        isFirstPlay_ = ![[NSUserDefaults standardUserDefaults] boolForKey:kFirstPlay];
        
        delegate_ = nil;
        keyboard_ = nil;
        instructor_ = nil;      
        noteGenerator_ = nil;
        scoreInfo_.notesHit = 0;
        scoreInfo_.notesMissed = 0;      
        scoreInfo_.difficulty = difficulty;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) touchesBegan:(NSSet *)touches
{
    if (keyboard_) {
        [keyboard_ touchesBegan:touches];
    }
}

- (void) touchesMoved:(NSSet *)touches
{
    if (keyboard_) {
        [keyboard_ touchesMoved:touches];
    }
}

- (void) touchesEnded:(NSSet *)touches
{
    if (keyboard_) {
        [keyboard_ touchesEnded:touches];    
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
    reader.position = ccp(GL_BUBBLE_X, GL_BUBBLE_Y);
    [self addChild:reader];        
}

- (void) runDelayedEndSpeech
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:1.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(endSpeech)];
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) endSpeech
{
    //[self runSingleSpeech:kSongComplete tapRequired:NO];    
}

@end
