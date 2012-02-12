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

@implementation GameLogic

+ (id) gameLogic
{
    return [[[self alloc] initGameLogic] autorelease];
}

- (id) initGameLogic
{
    if ((self = [super init])) {
        
        keyboard_ = nil;
        instructor_ = nil;        
        
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

@end
