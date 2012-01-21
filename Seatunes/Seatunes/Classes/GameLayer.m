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
        keyboard_.delegate = self;
        keyboard_.position = ccp(100, 100);
        [self addChild:keyboard_];
        
        NSMutableArray *test = [NSMutableArray arrayWithCapacity:10];
        [test addObject:[NSNumber numberWithInteger:kC4]];
        [test addObject:[NSNumber numberWithInteger:kC4]];
        [test addObject:[NSNumber numberWithInteger:kG4]];
        [test addObject:[NSNumber numberWithInteger:kG4]];
        [test addObject:[NSNumber numberWithInteger:kA4]];
        [test addObject:[NSNumber numberWithInteger:kA4]];
        [test addObject:[NSNumber numberWithInteger:kG4]];  
        [test addObject:[NSNumber numberWithInteger:kBlankNote]];  
        [test addObject:[NSNumber numberWithInteger:kF4]];
        [test addObject:[NSNumber numberWithInteger:kF4]];
        [test addObject:[NSNumber numberWithInteger:kE4]];
        [test addObject:[NSNumber numberWithInteger:kE4]];
        [test addObject:[NSNumber numberWithInteger:kD4]];
        [test addObject:[NSNumber numberWithInteger:kD4]];     
        [test addObject:[NSNumber numberWithInteger:kC4]];        
        //[keyboard_ playSequence:test];
        
        processor_ = [[Processor processor] retain];
        processor_.delegate = self;
        [processor_ loadSong:@"Twinkle Twinkle"];
        [processor_ forward];
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

- (void) keyboardKeyPressed:(KeyType)keyType
{
    [processor_ notePlayed:keyType];
}

- (void) instructorPlayNote:(KeyType)keyType
{
    [instructor_ playNote:keyType];
}

- (void) incorrectNotePlayed
{
    
}

- (void) sectionComplete
{
    
}

- (void) songComplete
{
    
}


@end
