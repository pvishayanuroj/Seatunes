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
        
        sectionIndex_ = 0;
        noteIndex_ = 0;
        
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
    
    NSArray *sections = [[NSArray arrayWithArray:[data objectForKey:@"Notes"]] retain];
    notes_ = [[NSMutableArray arrayWithCapacity:[sections count]] retain];   
    
    // For each section
    for (NSArray *section in sections) {
        NSMutableArray *parsedSection = [NSMutableArray arrayWithCapacity:[section count]];
        for (NSString *note in section) {
            NSNumber *key = [NSNumber numberWithInteger:[Utility keyEnumFromName:note]];
            [parsedSection addObject:key];
        }
        [notes_ addObject:parsedSection];
    }
    
    NSLog(@"%@", notes_);
}

- (void) notePlayed:(KeyType)keyType
{
    if (waitingForNote_) {
        NSLog(@"expected note: %d, keyType: %d", expectedNote_, keyType);
        if (keyType != expectedNote_) {
            [delegate_ incorrectNotePlayed];
        }
        else {
            waitingForNote_ = NO;
            [self forward];
        }
    }
    else {
        
    }
}

- (void) forward
{
    NSArray *section = [notes_ objectAtIndex:sectionIndex_];
    if (noteIndex_ >= [section count]) {
        if (sectionIndex_ >= [notes_ count]) {
            [delegate_ songComplete];
        }
        else {
            noteIndex_ = 0;
            sectionIndex_++;
            [delegate_ sectionComplete];
        }
    }
    else {
        KeyType note = [[[notes_ objectAtIndex:sectionIndex_] objectAtIndex:noteIndex_] integerValue];
        noteIndex_++;
        [delegate_ instructorPlayNote:note];
        waitingForNote_ = YES;
        expectedNote_ = note;
    }
}

@end
