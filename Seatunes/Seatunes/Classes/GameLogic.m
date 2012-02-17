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
#import "SpeechReader.h"

@implementation GameLogic

static const CGFloat GL_BUBBLE_X = 620.0f;
static const CGFloat GL_BUBBLE_Y = 500.0f;

@synthesize delegate = delegate_;

+ (id) gameLogic
{
    return [[[self alloc] initGameLogic] autorelease];
}

- (id) initGameLogic
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        keyboard_ = nil;
        instructor_ = nil;      
        scoreInfo_.notesHit = 0;
        scoreInfo_.notesMissed = 0;        
        scoreInfo_.score = kScoreZeroStar;
        
    }
    return self;
}

- (void) dealloc
{
    [keyboard_ release];
    [instructor_ release];
    
    [super dealloc];
}

- (void) setKeyboard:(Keyboard *)keyboard
{
    keyboard_ = [keyboard retain];
    keyboard_.delegate = self;
    keyboard_.isClickable = NO;
}

- (void) setInstructor:(Instructor *)instructor
{
    instructor_ = [instructor retain];
    instructor_.delegate = self;
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

@end
