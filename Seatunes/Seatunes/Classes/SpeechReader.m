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
    return [[[self alloc] initSpeechReader:nil prompt:NO] autorelease];
}

+ (id) speechReader:(NSArray *)speeches prompt:(BOOL)prompt
{
    return [[[self alloc] initSpeechReader:speeches prompt:prompt] autorelease];
}

- (id) initSpeechReader:(NSArray *)speeches prompt:(BOOL)prompt
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        data_ = nil;
        currentSpeechIndex_ = 0;
        isClickable_ = YES;
        prompt_ = prompt;
        
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

#pragma - Delegate Methods

- (void) narrationComplete:(SpeechType)speechType
{
    NSLog(@"narration complete");
    if (prompt_) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(bubbleComplete:)]) {
            [delegate_ bubbleComplete:speechType];
        }
    }
    else {
        [self nextDialogue];
    }
}

#pragma - Helper Methods

- (void) loadSingleDialogue:(SpeechType)speechType
{
    [self loadDialogue:[NSArray arrayWithObject:[NSNumber numberWithInteger:speechType]]];
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

- (void) playSecondaryDialogue:(SpeechType)speechType
{
    
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
        
        // Set the text
        [text_ setString:line];
        
        // Play the audio
        SpeechType speechType = [[speechTypes_ objectAtIndex:currentSpeechIndex_] integerValue];
        [[AudioManager audioManager] playNarration:speechType path:path delegate:self];
        
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

- (SpeechType) currentSpeech
{
    if (currentSpeechIndex_ > 0) {          
        return [[speechTypes_ objectAtIndex:(currentSpeechIndex_ - 1)] integerValue];
    }    
    return 0;
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
        if (delegate_ && [delegate_ respondsToSelector:@selector(bubbleClicked:)]) {
            if (currentSpeechIndex_ > 0) {
                [[AudioManager audioManager] stopNarration];                
                SpeechType currentSpeechType = [[speechTypes_ objectAtIndex:(currentSpeechIndex_ - 1)] integerValue];
                [delegate_ bubbleClicked:currentSpeechType];
            }
        }
    }
}


@end
