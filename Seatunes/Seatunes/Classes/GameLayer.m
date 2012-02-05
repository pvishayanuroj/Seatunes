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

const static CGFloat GL_INSTRUCTOR_X = 200.0f;
const static CGFloat GL_INSTRUCTOR_Y = 550.0f;
const static CGFloat GL_KEYBOARD_X = 100.0f;
const static CGFloat GL_KEYBOARD_Y = 100.0f;

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
        instructor_.position = ccp(GL_INSTRUCTOR_X, GL_INSTRUCTOR_Y);
        [self addChild:instructor_ z:-1];
        
        keyboard_ = [[Keyboard keyboard:kEightKey] retain];
        keyboard_.position = ccp(GL_KEYBOARD_X, GL_KEYBOARD_Y);
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

- (void) sectionComplete
{
    
}

- (void) songComplete
{
    
}


@end
