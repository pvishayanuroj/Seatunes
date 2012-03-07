//
//  Staff.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Staff.h"
#import "StaffNote.h"

@implementation Staff

static const CGFloat ST_NOTE_OFFSET_X = 250.0f;
static const CGFloat ST_NOTE_X_BOUNDARY = -80.0f;

@synthesize delegate = delegate_;

+ (id) staff
{
    return [[[self alloc] initStaff] autorelease];
}

- (id) initStaff
{
    if ((self = [super init])) {
     
        delegate_ = nil;
        notes_ = [[NSMutableArray arrayWithCapacity:6] retain];
        
        CCSprite *frame = [CCSprite spriteWithFile:@"Staff Frame.png"];
        CCSprite *staff = [CCSprite spriteWithFile:@"Staff.png"];
        [self addChild:frame];
        [self addChild:staff];
        
        [self schedule:@selector(loop) interval:1.0f/60.0f];
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    
    [super dealloc];
}

- (void) loop
{
    // For removal of objects
    NSMutableIndexSet *remove = [NSMutableIndexSet indexSet];    
    NSUInteger index = 0;    
    
    for (StaffNote *note in notes_) {

        if (note.position.x < ST_NOTE_X_BOUNDARY) {
            [remove addIndex:index];
            [note disappear];
        }
        index++;
    }
    
    // For the removal of cat bullets
    [notes_ removeObjectsAtIndexes:remove];    
}

- (void) addNote:(KeyType)keyType
{
    StaffNote *note = [StaffNote staffNote:keyType pos:ccp(ST_NOTE_OFFSET_X, 0)];
    [notes_ addObject:note];
    [self addChild:note];
}

- (void) removeOldestNote
{
    
}

- (void) removeAllNotes
{
    
}

@end
