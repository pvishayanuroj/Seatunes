//
//  SpeechReader.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/7/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SpeechReader.h"
#import "SpeechManager.h"
#import "AudioManager.h"
#import "Text.h"

@implementation SpeechReader

static const CGFloat SR_BUBBLE_OFFSET_X = 210.0f;
static const CGFloat SR_BUBBLE_OFFSET_Y = -50.0f;
static const CGFloat SR_DEFAULT_WAIT_TIME = 5.0f;

@synthesize delegate = delegate_;

+ (id) speechReader
{
    return [[[self alloc] initSpeechReader:nil tapRequired:NO] autorelease];
}

+ (id) speechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    return [[[self alloc] initSpeechReader:speeches tapRequired:tapRequired] autorelease];
}

- (id) initSpeechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        data_ = nil;
        currentSpeechIndex_ = 0;
        isClickable_ = YES;
        tapRequired_ = tapRequired;
        
        if (speeches) {
            speechTypes_ = [speeches retain];
        }
        else {
            speechTypes_ = nil;
        }
                
        sprite_ = [[CCSprite spriteWithFile:@"Speech Bubble Large.png"] retain];        
        sprite_.position = ccp(SR_BUBBLE_OFFSET_X, SR_BUBBLE_OFFSET_Y);
        [self addChild:sprite_];
        
        text_ = [[Text text:@"" fntFile:@"Dialogue Font.fnt"] retain];
        [text_ addFntFile:@"MenuFont.fnt" textType:kTextBold];
        [self addChild:text_];        
        
        [self loadDialogue:speeches];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [data_ release];
    [speechTypes_ release];
    
    [super dealloc];
}

- (void) loadDialogue:(NSArray *)speeches
{
    if (speeches != nil) {
    
        [speechTypes_ release];
        [data_ release];
        speechTypes_ = [speeches retain];
        lastSpeechType_ = [[speeches lastObject] integerValue];            
        data_ = [[[SpeechManager speechManager] textAndAudioFromSpeechTypes:speeches] retain];
        [self nextDialogue];    
    }
}

- (void) nextDialogue
{
    // Get references to the text and audio path arrays
    NSArray *lines = [data_ objectForKey:@"Text"];
    NSArray *paths = [data_ objectForKey:@"Audio"];    
    
    // If text remaining
    if (currentSpeechIndex_ < [lines count]) {
        
        NSString *line = [lines objectAtIndex:currentSpeechIndex_];
        NSString *path =  [paths objectAtIndex:currentSpeechIndex_];
        
        [text_ setString:line];
        
        [[AudioManager audioManager] stopSound:effectID_];
        effectID_ = [[AudioManager audioManager] playSoundEffectFile:path];
        
        currentSpeechIndex_++;
    }
    // No text remaining
    else {
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete:)]) {
            [delegate_ speechComplete:lastSpeechType_];
        }
    }
}

- (void) dialogueComplete
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete:)]) {
        [delegate_ speechComplete:lastSpeechType_];
    }
}

#pragma mark - Touch Handlers

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (isClickable_) {
        return [self containsTouchLocation:touch];
    }
    
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch]) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechClicked:)]) {
            if (currentSpeechIndex_ > 0) {
                SpeechType currentSpeechType = [[speechTypes_ objectAtIndex:(currentSpeechIndex_ - 1)] integerValue];
                [delegate_ speechClicked:currentSpeechType];
            }
        }
    }
}


@end
