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

@synthesize staff = staff_;
@synthesize keyboard = keyboard_;
@synthesize delegate = delegate_;

+ (id) gameLogic
{
    NSAssert(NO, @"Constructor must be implemented in derived class");
    return nil;
}

- (id) initGameLogic:(DifficultyType)difficulty
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        keyboard_ = nil;
        instructor_ = nil;      
        noteGenerator_ = nil;
        staff_ = nil;
        scoreInfo_.notesHit = 0;
        scoreInfo_.notesMissed = 0;      
        scoreInfo_.difficulty = difficulty;
        scoreInfo_.helpUsed = NO;
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

@end
