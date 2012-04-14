//
//  Staff.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Staff.h"
#import "StaffNote.h"
#import "ParticleGenerator.h"

@implementation Staff

static const CGFloat ST_NOTE_PADDING = 12.65f;
static const CGFloat ST_NOTE_OFFSET_Y = 23.0f;
static const CGFloat ST_NOTE_FLIPPED_OFFSET_Y = 75.0f;
static const CGFloat ST_NOTE_OFFSET_X = 600.0f;
static const CGFloat ST_NOTE_X_BOUNDARY = -80.0f;
static const CGFloat ST_STATIC_NOTE_CENTER_OFFSET_X = 40.0f;
static const CGFloat ST_STATIC_NOTE_SPACE = 520.0f;

// Duration between notes being shown added and destroyed
static const CGFloat ST_SEQUENCE_ADD_INTERVAL = 0.75f;
static const CGFloat ST_SEQUENCE_DESTROY_INTERVAL = 0.75f;

// Duration for when staff is visible and invisible when blinking
static const CGFloat ST_BLINK_SHOW = 0.8f;
static const CGFloat ST_BLINK_HIDE = 0.35f;

@synthesize delegate = delegate_;

+ (id) staff
{
    return [[[self alloc] initStaff] autorelease];
}

- (id) initStaff
{
    if ((self = [super init])) {
     
        delegate_ = nil;
        action_ = nil;
        notes_ = [[NSMutableArray arrayWithCapacity:6] retain];
        
        staffBackground_ = [[CCSprite spriteWithFile:@"Staff Parchment.png"] retain];
        [self addChild:staffBackground_ z:-2];
         
        staffForeground_ = [[CCSprite spriteWithFile:@"Staff.png"] retain];
        [self addChild:staffForeground_ z:-1];
        
        [self schedule:@selector(loop) interval:1.0f/60.0f];
        
        //[self drawAllNotes];
    }
    return self;
}

- (void) dealloc
{
    [notes_ release];
    [staffBackground_ release];
    [staffForeground_ release];
    [action_ release];
    
    [super dealloc];
}

- (void) loop
{
    // For removal of objects
    NSMutableIndexSet *remove = [NSMutableIndexSet indexSet];    
    NSUInteger index = 0;    
    
    for (StaffNote *note in notes_) {

        if (note.position.x < ST_NOTE_X_BOUNDARY && note.position.y > -100) {
            [remove addIndex:index];
            [self staffNoteReturned:note];
            [note fadeDestroy];
        }
        index++;
    }
    
    // For the removal of cat bullets
    [notes_ removeObjectsAtIndexes:remove];    
}

- (void) blinkStaff:(BOOL)blink
{
    if (blink && action_ == nil) {
        
        CCActionInterval *hide = [CCFadeOut actionWithDuration:0.0f];
        CCActionInterval *hideDuration = [CCDelayTime actionWithDuration:ST_BLINK_SHOW];        
        CCActionInterval *show = [CCFadeIn actionWithDuration:0.0f];
        CCActionInterval *showDuration = [CCDelayTime actionWithDuration:ST_BLINK_SHOW];        

        CCActionInterval *blinkAction = [CCSequence actions:hide, hideDuration, show, showDuration, nil];
        action_ = [[CCRepeatForever actionWithAction:blinkAction] retain];
        [staffForeground_ runAction:action_];
    }
    else if (!blink && action_ != nil) {
        [action_ stop];
        [action_ release];
    }
}

- (void) disableLoop
{
    [self unschedule:@selector(loop)];
}

- (void) staffNoteReturned:(StaffNote *)note
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(staffNoteReturned:)]) {
        [delegate_ staffNoteReturned:note];
    }
}

- (void) addNotesInSequence:(NSArray *)notes
{
    // Guard against empty arrays
    if ([notes count] == 0) {
        return;
    }
    
    // Starting location and padding
    CGFloat xOffset = ST_STATIC_NOTE_CENTER_OFFSET_X - ST_STATIC_NOTE_SPACE * 0.5f;
    CGFloat xPadding = (ST_STATIC_NOTE_SPACE / (CGFloat)([notes count] + 1));
    
    NSMutableArray *actions = [NSMutableArray array];
    
    NSInteger index = 0;
    for (NSNumber *note in notes) {
        KeyType keyType = [note integerValue];
        CCActionInstant *add =[CCCallBlock actionWithBlock:^{
            CGFloat x = xOffset + xPadding * (index + 1);
            CGFloat y = [self calculateNoteY:keyType];
            CGPoint pos = ccp(x, y);
            StaffNote *note = [StaffNote staticStaffNote:keyType pos:pos numID:index];
            [notes_ addObject:note];
            [self addChild:note];
        }];
        
        CCActionInterval *delay = [CCDelayTime actionWithDuration:ST_SEQUENCE_ADD_INTERVAL];        
        
        [actions addObject:add];
        [actions addObject:delay];
        
        index++;
    }
    
    // Add notification upon finish
    CCCallFunc *done = [CCCallFunc actionWithTarget:self selector:@selector(doneAddingNotesInSequence)];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];
}

- (void) doneAddingNotesInSequence
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(notesInSequenceAdded)]) {
        [delegate_ notesInSequenceAdded];
    }
}
                        
- (void) destroyNotesInSequence
{
    NSMutableArray *actions = [NSMutableArray array];    
    
    for (StaffNote *note in notes_) {
        CCActionInstant *destroy = [CCCallFunc actionWithTarget:note selector:@selector(fadeDestroy)];
        CCActionInterval *delay = [CCDelayTime actionWithDuration:ST_SEQUENCE_DESTROY_INTERVAL];
        [actions addObject:destroy];
        [actions addObject:delay];
    }
    
    // Add notification upon finish
    CCCallFunc *done = [CCCallFunc actionWithTarget:self selector:@selector(doneDestroyingNotesInSequence)];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];    
    [notes_ removeAllObjects];
}

- (void) doneDestroyingNotesInSequence
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(notesInSequenceDestroyed)]) {
        [delegate_ notesInSequenceDestroyed];
    }
}

- (void) addMovingNote:(KeyType)keyType numID:(NSUInteger)numID
{
    CGPoint pos = ccp(-200, -275);
    StaffNote *note = [StaffNote staffNote:keyType pos:pos numID:numID];
    [notes_ addObject:note];
    [self addChild:note];    
}

- (void) addNote:(KeyType)keyType numID:(NSUInteger)numID
{
    
}

- (void) addStaticNote:(KeyType)keyType numID:(NSUInteger)numID
{
 
}

- (BOOL) isOldestNoteActive
{
    if ([notes_ count] > 0) {
        StaffNote *note = [notes_ objectAtIndex:0];
        return note.state == kStaffNoteActive;
    }
    return NO;
}

- (void) removeOldestNote
{
    if ([notes_ count] > 0) {
        [[notes_ objectAtIndex:0] jumpDestroy];
        [notes_ removeObjectAtIndex:0];        
    }
}

- (void) removeAllNotes
{
    for (StaffNote *note in notes_) {
        [note fadeDestroy];
    }

    [notes_ removeAllObjects];
}

- (void) drawAllNotes
{
    CGFloat x = -150;
    for (int i = 0; i < 8; ++i) {
        CGFloat y = [self calculateNoteY:i];
        
        CGPoint pos = ccp(x + i * 50, y);
        StaffNote *note = [StaffNote staticStaffNote:i pos:pos numID:0];
        [self addChild:note];
    }
}

- (CGFloat) calculateNoteY:(KeyType)key
{
    NSInteger idx = (NSInteger)key;
    CGFloat y = idx * ST_NOTE_PADDING - ST_NOTE_OFFSET_Y;
    if (idx > kA4) {
        y -= ST_NOTE_FLIPPED_OFFSET_Y;
    }
    return y;
}

#if DEBUG_SHOWSTAFFCURVES
- (void) draw
{
    /*
    glColor4f(1.0, 0, 0, 1.0);      
    glLineWidth(3.0f);
        
    CGPoint start = ccp(-200, -180);
    CGPoint c1 = ccp(start.x + 300, start.y - 125);
    CGPoint c2 = ccp(start.x + 450, start.y + 125);
    CGPoint end = ccp(start.x + 450, start.y + 300);
    //NSLog(@"%d: (%4.0f, %4.0f), (%4.0f, %4.0f), (%4.0f, %4.0f), (%4.0f, %4.0f)", i, CR_S_X[i], CR_S_Y[i], CR_C1_X[i], CR_C1_Y[i], CR_C2_X[i], CR_C2_Y[i], CR_E_X[i], CR_E_Y[i]);        
    
    ccDrawCircle(start, 3, 360, 64, NO);
    ccDrawCircle(c1, 3, 360, 64, NO);        
    ccDrawCircle(c2, 3, 360, 64, NO);
    ccDrawCubicBezier(start, c1, c2, end, 128);        
     */
}
#endif

@end
