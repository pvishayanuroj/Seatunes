//
//  NoteGenerator.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/5/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "NoteGenerator.h"
#import "Note.h"

@implementation NoteGenerator

static const CGFloat NG_INSTRUCTOR_X = 353.0f;
static const CGFloat NG_INSTRUCTOR_Y = 490.0f;

static const CGFloat NG_FLOOR1_X = 50.0f;
static const CGFloat NG_FLOOR1_Y = 150.0f;
static const CGFloat NG_FLOOR2_X = 500.0f;
static const CGFloat NG_FLOOR2_Y = 150.0f;
static const CGFloat NG_FLOOR3_X = 900.0f;
static const CGFloat NG_FLOOR3_Y = 150.0f;

@synthesize delegate = delegate_;

+ (id) noteGenerator
{
    return [[[self alloc] initNoteGenerator] autorelease];
}

- (id) initNoteGenerator
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        curveCounter_ = 0;        
        notes_ = [[NSMutableArray arrayWithCapacity:10] retain];
        
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    
    [super dealloc];
}

- (void) addInstructorNote:(KeyType)keyType numID:(NSUInteger)numID
{
    if (keyType != kBlankNote) {
        BubbleCurveType curveType = curveCounter_++ % 2 ? kBubbleCurve1 : kBubbleCurve2;        
        [self addNote:keyType poppable:NO curveType:curveType pos:ccp(NG_INSTRUCTOR_X, NG_INSTRUCTOR_Y) numID:numID];
    }
}

- (void) addFloorNote:(KeyType)keyType numID:(NSUInteger)numID
{
    if (keyType != kBlankNote) {
        
        CGPoint pos;
        switch (arc4random() % 3) {
            case 0:
                pos = ccp(NG_FLOOR1_X, NG_FLOOR1_Y);
                break;
            case 1:
                pos = ccp(NG_FLOOR2_X, NG_FLOOR2_Y);                
                break;
            case 2:
                pos = ccp(NG_FLOOR3_X, NG_FLOOR3_Y);                
                break;
        }
        [self addNote: keyType poppable:YES curveType:kBubbleCurve3 pos:pos numID:numID];
    }
}

- (void) addNote:(KeyType)keyType poppable:(BOOL)poppable curveType:(BubbleCurveType)curveType pos:(CGPoint)pos numID:(NSUInteger)numID
{
    if (keyType != kBlankNote) {
        Note *note = [Note note:keyType curveType:curveType poppable:poppable numID:numID];
        note.delegate = self;
        note.position = pos;
        [notes_ addObject:note];
        [self addChild:note z:-2];  
    }
}

- (void) popOldestNote
{
    if ([notes_ count] > 0) {   
        [[notes_ objectAtIndex:0] destroy];
        [notes_ removeObjectAtIndex:0];
    }
}

- (void) popNewestNote
{
    if ([notes_ count] > 0) {
        [[notes_ lastObject] destroy];
        [notes_ removeLastObject];
    }
}

#pragma mark - Delegate Methods

- (void) noteCrossedBoundary:(Note *)note
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(noteCrossedBoundary:)]) {
        [delegate_ noteCrossedBoundary:note];
    }
}

- (void) noteTouched:(Note *)note
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(noteTouched:)]) {
        [delegate_ noteTouched:note];
    }    
}

- (void) noteDestroyed:(Note *)note
{
    [notes_ removeObject:note];
}

@end
