//
//  Processor.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 1/16/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Processor.h"
#import "Utility.h"

@implementation Processor

@synthesize delegate = delegate_;

+ (id) processor
{
    return [[[self alloc] initProcessor] autorelease];
}

- (id) initProcessor
{
    if ((self = [super init])) {
        
        noteIndex_ = 0;
        timerActive_ = NO;
        
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    
    [super dealloc];
}

- (void) loadSong:(NSString *)songName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *storedNotes = [[NSArray arrayWithArray:[data objectForKey:@"Notes"]] retain];
    notes_ = [[NSMutableArray arrayWithCapacity:[storedNotes count]] retain];   
    
    for (NSString *note in storedNotes) {
        NSNumber *key = [NSNumber numberWithInteger:[Utility keyEnumFromName:note]];
        [notes_ addObject:key];
    }
}

- (void) notePlayed:(KeyType)keyType
{
    if (waitingForNote_) {
        // If incorrect note played
        if (keyType != expectedNote_) {
            [delegate_ incorrectNotePlayed];
        }
        // Correct note played
        else {
            timerActive_ = NO;
            waitingForNote_ = NO;
            [self delayedForward:0.5f];
        }
    }
    else {
        
    }
}

- (void) delayedForward:(CGFloat)delayTime
{
    [self stopAllActions];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(forward)];
    [self runAction:[CCSequence actions:delay, method, nil]];
}

- (void) forward
{
    if (noteIndex_ < [notes_ count]) {
        KeyType note = [[notes_ objectAtIndex:noteIndex_] integerValue];
        noteIndex_++;
        
        if (note == kBlankNote) {
            [self delayedForward:1.0f];
        }
        else {
            [delegate_ instructorPlayNote:note];
            [self delayedReplay];
            waitingForNote_ = YES;
            timerActive_ = YES;
            expectedNote_ = note;
        }
    }
    else {
        [delegate_ songComplete];
    }
}

- (void) delayedReplay
{
    [self stopAllActions];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:10.0f];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(replay)];
    [self runAction:[CCSequence actions:delay, method, nil]];    
}

- (void) replay
{
    if (timerActive_) {
        [delegate_ instructorPlayNote:expectedNote_];
        [self delayedReplay];
    }
}

@end
