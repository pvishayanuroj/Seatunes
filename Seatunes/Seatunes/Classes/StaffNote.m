//
//  StaffNote.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 3/6/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "StaffNote.h"


@implementation StaffNote

@synthesize delegate = delegate_;

static const CGFloat SN_LOWC_YOFFSET = -20.0f;
static const CGFloat SN_LINE_YOFFSET = -22.0f;
static const CGFloat SN_REST_YOFFSET = 0.0f;
static const CGFloat SN_NOTE_PADDING = 7.5f;
static const CGFloat SN_MOVE_X = -400.0f;

+ (id) staticStaffNote:(KeyType)keyType pos:(CGPoint)pos
{
    return [[[self alloc] initStaffNote:keyType pos:pos isStatic:YES] autorelease];
}

+ (id) staffNote:(KeyType)keyType pos:(CGPoint)pos
{
    return [[[self alloc] initStaffNote:keyType pos:pos isStatic:NO] autorelease];
}

- (id) initStaffNote:(KeyType)keyType pos:(CGPoint)pos isStatic:(BOOL)isStatic
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        line_ = nil;
        self.position = pos;
        
        if (keyType == kBlankNote) {
            sprite_ = [[CCSprite spriteWithFile:@"Quarter Rest.png"] retain];
            sprite_.position = ccp(0, SN_REST_YOFFSET);
        }
        else {
            sprite_ = [[CCSprite spriteWithFile:@"Quarter Note Black.png"] retain];
            
            if (keyType == kC4) {
                line_ = [[CCSprite spriteWithFile:@"Staff Line.png"] retain];
                line_.position = ccp(0, SN_LOWC_YOFFSET + SN_LINE_YOFFSET);
                line_.opacity = 0;
                [self addChild:line_];
            }
            if (keyType > kA4) {
                sprite_.rotation = 180.0f;
            }
            
            NSInteger idx = (NSInteger)keyType;
            sprite_.position = ccp(0, SN_LOWC_YOFFSET + SN_NOTE_PADDING * idx);
        }
        
        sprite_.opacity = 0;
        [self addChild:sprite_];
        
        if (!isStatic) {
            [self move];
        }
        [self appear];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [line_ release];
    
    [super dealloc];
}

- (void) move
{
    CCActionInterval *move = [CCMoveBy actionWithDuration:5.0f position:ccp(SN_MOVE_X, 0)];
    [self runAction:move];
}

- (void) appear
{
    CCActionInterval *fadeIn = [CCFadeIn actionWithDuration:0.5f];
    [sprite_ runAction:fadeIn];
    
    if (line_) {
        CCActionInterval *lineFadeIn = [CCFadeIn actionWithDuration:0.5f];
        [line_ runAction:lineFadeIn];        
    }
}

- (void) staffNoteDestroy
{
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:0.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [sprite_ runAction:[CCSequence actions:fadeOut, done, nil]];
    
    if (line_) {
        CCActionInterval *lineFadeOut = [CCFadeOut actionWithDuration:0.5f];        
        [line_ runAction:lineFadeOut];
    }    
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (void) staffNoteReturn
{
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:0.5f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(notifyStaffNoteReturn)];
    
    [sprite_ runAction:[CCSequence actions:fadeOut, done, nil]];
    
    if (line_) {
        CCActionInterval *lineFadeOut = [CCFadeOut actionWithDuration:0.5f];        
        [line_ runAction:lineFadeOut];
    }
}

- (void) notifyStaffNoteReturn
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(staffNoteReturned:)]) {
        [delegate_ staffNoteReturned:self];
    }
    
    [self removeFromParentAndCleanup:YES];
}

@end
