//
//  GameLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLayer.h"
#import "Keyboard.h"
#import "AudioManager.h"
#import "Note.h"
#import "Instructor.h"
#import "Processor.h"
#import "GameLogicB.h"

@implementation GameLayer

+ (id) start
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        [AudioManager audioManager];
        
        instructor_ = [Instructor instructor:kWhaleInstructor];
        instructor_.position = ccp(150.0f, 550.0f);
        [self addChild:instructor_];
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.position = ccp(100, 100);
        [self addChild:keyboard_];
        
        GameLogicB *gameLogicB = [GameLogicB gameLogicB:@"Twinkle Twinkle"];
        [gameLogicB setInstructor:instructor_];
        [gameLogicB setKeyboard:keyboard_];
        [self addChild:gameLogicB];
        
        [gameLogicB start];
    }
    return self;
}

- (void) dealloc
{
    [instructor_ release];
    [keyboard_ release];
    [processor_ release];
    
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesBegan:touches];
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesMoved:touches];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [keyboard_ touchesEnded:touches];
}

- (void) addNote:(KeyType)keyType
{
    Note *note = [Note note:keyType];
    note.position = ccp(170.0f, 500.0f);
    [self addChild:note];
}

- (void) instructorPlayNote:(KeyType)keyType
{
    [instructor_ playNote:keyType];
}

- (void) incorrectNotePlayed
{
    [instructor_ showWrongNote];
}

- (void) sectionComplete
{
    
}

- (void) songComplete
{
    
}


@end
