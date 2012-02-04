//
//  GameLogicB.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicB.h"
#import "Utility.h"
#import "Keyboard.h"
#import "Instructor.h"

@implementation GameLogicB

+ (id) gameLogicB:(NSString *)songName
{
    return [[[self alloc] initGameLogicB:songName] autorelease];
}

- (id) initGameLogicB:(NSString *)songName
{
    if ((self = [super init])) {
        
        keyboard_ = nil;
        instructor_ = nil;
        noteIndex_ = 0;
        notes_ = [[Utility loadFlattenedSong:songName] retain];
        queue_ = [[NSMutableArray arrayWithCapacity:5] retain];
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [queue_ release];
    [keyboard_ release];
    [instructor_ release];
    
    [super dealloc];
}

- (void) setKeyboard:(Keyboard *)keyboard
{
    keyboard_ = [keyboard retain];
    keyboard.delegate = self;
}

- (void) setInstructor:(Instructor *)instructor
{
    instructor_ = [instructor retain];
}

- (void) start
{
    [self schedule:@selector(loop:) interval:1.5f];
}

- (void) loop:(ccTime)dt
{
    if ([notes_ count] > noteIndex_) {
        
        NSNumber *key = [notes_ objectAtIndex:noteIndex_++];
        
        KeyType keyType = [key integerValue];
        
        if (keyType != kBlankNote) {
            [queue_ addObject:key];
            if ([queue_ count] > 3) {
                [self lossEvent];
            }
        }
        
        [instructor_ playNote:keyType];        
    }
}

- (void) keyboardKeyDepressed:(KeyType)keyType time:(CGFloat)time
{
    NSNumber *key = [NSNumber numberWithInteger:keyType];
    
    if ([queue_ count] > 0) {
    
        NSNumber *correctNote = [queue_ objectAtIndex:0];
        
        // Correct note played
        if ([key isEqualToNumber:correctNote]) {
            [queue_ removeObjectAtIndex:0];
        }
        // Incorrect note played
        else {
            NSLog(@"WRONG");
        }
    }
    // Else no pending notes
    else {
        NSLog(@"WRONG");        
    }
    
}

- (void) lossEvent
{
    [self unschedule:@selector(loop:)];
    NSLog(@"LOSS");
}


@end
