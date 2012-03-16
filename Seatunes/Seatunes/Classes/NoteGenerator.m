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

static const CGFloat NG_CR1_S_X = 353.0f;
static const CGFloat NG_CR1_S_Y = 205.0f;
static const CGFloat NG_CR1_C1_X = 150.0f; 
static const CGFloat NG_CR1_C1_Y = 0.0f;
static const CGFloat NG_CR1_C2_X = 240.0f;
static const CGFloat NG_CR1_C2_Y = 100.0f;
static const CGFloat NG_CR1_E_X = 200.0f;
static const CGFloat NG_CR1_E_Y = 750.0f;

static const CGFloat NG_CR2_S_X = 353.0f;
static const CGFloat NG_CR2_S_Y = 205.0f;
static const CGFloat NG_CR2_C1_X = 180.0f; 
static const CGFloat NG_CR2_C1_Y = 0.0f;
static const CGFloat NG_CR2_C2_X = 270.0f;
static const CGFloat NG_CR2_C2_Y = 100.0f;
static const CGFloat NG_CR2_E_X = 250.0f;
static const CGFloat NG_CR2_E_Y = 750.0f;

// Leftmost coral
static const CGFloat NG_CR3_S_X = 10.0f;
static const CGFloat NG_CR3_S_Y = 210.0f;
static const CGFloat NG_CR3_C1_X = 170.0f; 
static const CGFloat NG_CR3_C1_Y = 150.0f;
static const CGFloat NG_CR3_C2_X = 170.0f;
static const CGFloat NG_CR3_C2_Y = 250.0f;
static const CGFloat NG_CR3_E_X = 170.0f;
static const CGFloat NG_CR3_E_Y = 1000.0f;

// Middle coral to the right
static const CGFloat NG_CR4_S_X = 480.0f;
static const CGFloat NG_CR4_S_Y = 200.0f;
static const CGFloat NG_CR4_C1_X = 150.0f; 
static const CGFloat NG_CR4_C1_Y = 150.0f;
static const CGFloat NG_CR4_C2_X = 150.0f;
static const CGFloat NG_CR4_C2_Y = 250.0f;
static const CGFloat NG_CR4_E_X = 150.0f;
static const CGFloat NG_CR4_E_Y = 1000.0f;

// Rightmost coral
static const CGFloat NG_CR5_S_X = 970.0f;
static const CGFloat NG_CR5_S_Y = 230.0f;
static const CGFloat NG_CR5_C1_X = -150.0f; 
static const CGFloat NG_CR5_C1_Y = 150.0f;
static const CGFloat NG_CR5_C2_X = -150.0f;
static const CGFloat NG_CR5_C2_Y = 250.0f;
static const CGFloat NG_CR5_E_X = -150.0f;
static const CGFloat NG_CR5_E_Y = 1000.0f;

// Middle coral to the left
static const CGFloat NG_CR6_S_X = 480.0f;
static const CGFloat NG_CR6_S_Y = 200.0f;
static const CGFloat NG_CR6_C1_X = -150.0f; 
static const CGFloat NG_CR6_C1_Y = 150.0f;
static const CGFloat NG_CR6_C2_X = -150.0f;
static const CGFloat NG_CR6_C2_Y = 250.0f;
static const CGFloat NG_CR6_E_X = -150.0f;
static const CGFloat NG_CR6_E_Y = 1000.0f;

static const CGFloat CR_S_X[6] = {NG_CR1_S_X, NG_CR2_S_X, NG_CR3_S_X, NG_CR4_S_X, NG_CR5_S_X, NG_CR6_S_X};
static const CGFloat CR_S_Y[6] = {NG_CR1_S_Y, NG_CR2_S_Y, NG_CR3_S_Y, NG_CR4_S_Y, NG_CR5_S_Y, NG_CR6_S_Y};
static const CGFloat CR_C1_X[6] = {NG_CR1_C1_X, NG_CR2_C1_X, NG_CR3_C1_X, NG_CR4_C1_X, NG_CR5_C1_X, NG_CR6_C1_X};
static const CGFloat CR_C1_Y[6] = {NG_CR1_C1_Y, NG_CR2_C1_Y, NG_CR3_C1_Y, NG_CR4_C1_Y, NG_CR5_C1_Y, NG_CR6_C1_Y};
static const CGFloat CR_C2_X[6] = {NG_CR1_C2_X, NG_CR2_C2_X, NG_CR3_C2_X, NG_CR4_C2_X, NG_CR5_C2_X, NG_CR6_C2_X};
static const CGFloat CR_C2_Y[6] = {NG_CR1_C2_Y, NG_CR2_C2_Y, NG_CR3_C2_Y, NG_CR4_C2_Y, NG_CR5_C2_Y, NG_CR6_C2_Y};
static const CGFloat CR_E_X[6] = {NG_CR1_E_X, NG_CR2_E_X, NG_CR3_E_X, NG_CR4_E_X, NG_CR5_E_X, NG_CR6_E_X};
static const CGFloat CR_E_Y[6] = {NG_CR1_E_Y, NG_CR2_E_Y, NG_CR3_E_Y, NG_CR4_E_Y, NG_CR5_E_Y, NG_CR6_E_Y};

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
        int idx = curveCounter_++ % 2 ? 0 : 1;
        ccBezierConfig curve;
        curve.controlPoint_1 = ccp(CR_C1_X[idx], CR_C1_Y[idx]);
        curve.controlPoint_2 = ccp(CR_C2_X[idx], CR_C2_Y[idx]);        
        curve.endPosition = ccp(CR_E_X[idx], CR_E_Y[idx]);
        CGPoint pos = ccp(CR_S_X[idx], CR_S_Y[idx]);
        [self addNote:keyType poppable:NO curve:curve pos:pos numID:numID];
    }
}

- (void) addFloorNote:(KeyType)keyType numID:(NSUInteger)numID
{
    if (keyType != kBlankNote) {
        
        int idx = arc4random() % 4 + 2;
        ccBezierConfig curve;
        curve.controlPoint_1 = ccp(CR_C1_X[idx], CR_C1_Y[idx]);
        curve.controlPoint_2 = ccp(CR_C2_X[idx], CR_C2_Y[idx]);        
        curve.endPosition = ccp(CR_E_X[idx], CR_E_Y[idx]);
        CGPoint pos = ccp(CR_S_X[idx], CR_S_Y[idx]);        

        [self addNote: keyType poppable:YES curve:curve pos:pos numID:numID];
    }
}

- (void) addNote:(KeyType)keyType poppable:(BOOL)poppable curve:(ccBezierConfig)curve pos:(CGPoint)pos numID:(NSUInteger)numID
{
    if (keyType != kBlankNote) {
        Note *note = [Note note:keyType curve:curve poppable:poppable numID:numID];
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

- (void) popNoteWithID:(NSUInteger)numID
{
    NSMutableIndexSet *toRemove = [NSMutableIndexSet indexSet];
    NSUInteger idx = 0;
    
    for (Note *note in notes_) {
        if (note.numID == numID) {
            [note destroy];
            [toRemove addIndex:idx];
            break;
        }
        idx++;
    }
    
    [notes_ removeObjectsAtIndexes:toRemove];
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

- (void) draw
{
#if DEBUG_SHOWMAPCURVES
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
    
    for (int i = 0; i < 6; i++) {

        CGPoint start = ccp(CR_S_X[i], CR_S_Y[i]);
        CGPoint c1 = ccp(start.x + CR_C1_X[i], start.y + CR_C1_Y[i]);
        CGPoint c2 = ccp(start.x + CR_C2_X[i], start.y + CR_C2_Y[i]);
        CGPoint end = ccp(start.x + CR_E_X[i], start.y + CR_E_Y[i]);
        //NSLog(@"%d: (%4.0f, %4.0f), (%4.0f, %4.0f), (%4.0f, %4.0f), (%4.0f, %4.0f)", i, CR_S_X[i], CR_S_Y[i], CR_C1_X[i], CR_C1_Y[i], CR_C2_X[i], CR_C2_Y[i], CR_E_X[i], CR_E_Y[i]);        
        
        ccDrawCircle(start, 3, 360, 64, NO);
        ccDrawCircle(c1, 3, 360, 64, NO);        
        ccDrawCircle(c2, 3, 360, 64, NO);
        ccDrawCubicBezier(start, c1, c2, end, 128);        
    }
#endif
}

@end
