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
static const CGFloat SR_BUBBLE_OFFSET_Y = -65.0f;
static const CGFloat SR_BUBBLE_OFFSET_X_M = 105.0f;
static const CGFloat SR_BUBBLE_OFFSET_Y_M = -30.0f;
static const CGFloat SR_DEFAULT_WAIT_TIME = 5.0f;

@synthesize isClickable = isClickable_;
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
        internalClickFlag_ = NO;
        prompt_ = prompt;
                
        sprite_ = [[CCSprite spriteWithFile:@"Speech Bubble Large.png"] retain];        
        if (IS_IPAD()) {
            sprite_.position = ccp(SR_BUBBLE_OFFSET_X, SR_BUBBLE_OFFSET_Y);
        }
        else {
            sprite_.position = ccp(SR_BUBBLE_OFFSET_X_M, SR_BUBBLE_OFFSET_Y_M);            
        }
        sprite_.visible = NO;
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
#if DEBUG_SHOWDEALLOC
    NSLog(@"Speech Reader dealloc'd");
#endif
    
    [[AudioManager audioManager] stopNarration];       
    
    [sprite_ release];
    [data_ release];
    
    [super dealloc];
}

#pragma - Delegate Methods

- (void) narrationComplete:(SpeechType)speechType
{
    internalClickFlag_ = NO;   
    
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
    
        [data_ release];
        lastSpeechType_ = [[speeches lastObject] integerValue];            
        data_ = [[[SpeechManager speechManager] textAndAudioFromSpeechTypes:speeches] retain];
        currentSpeechIndex_ = 0;
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
    NSArray *types = [data_ objectForKey:@"Types"];
    
    // If text remaining
    if (currentSpeechIndex_ < [lines count]) {
        
        internalClickFlag_ = YES;
        sprite_.visible = YES;
        
        NSString *line = [lines objectAtIndex:currentSpeechIndex_];
        NSString *path =  [paths objectAtIndex:currentSpeechIndex_];
        SpeechType speechType = [[types objectAtIndex:currentSpeechIndex_] integerValue];
        
        // Set the text
        [text_ setString:line];
        
        // Play the audio
        CCActionInterval *delay = [CCDelayTime actionWithDuration:1.0f];
        CCActionInstant *audio = [CCCallBlock actionWithBlock:^{
            [[AudioManager audioManager] playNarration:speechType path:path delegate:self];
        }];
        CCActionInstant *notify = [CCCallBlock actionWithBlock:^{
            if (delegate_ && [delegate_ respondsToSelector:@selector(narrationStarting:)]) {
                [delegate_ narrationStarting:speechType];
            }
        }];        
        [self runAction:[CCSequence actions:delay, audio, notify, nil]];

        
        currentSpeechType_ = speechType;
        currentSpeechIndex_++;
    }
    // No text remaining
    else {
        internalClickFlag_ = NO;        
        
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete:)]) {
            [delegate_ speechComplete:lastSpeechType_];
        }
    }
}

- (SpeechType) currentSpeech
{
    return currentSpeechType_;
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
    if (isClickable_ && internalClickFlag_) {
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
        
        internalClickFlag_ = NO;     
        [self stopAllActions];
        [[AudioManager audioManager] stopNarration];   
        
        // Check delegate wants to be notified about clicks
        if (delegate_ && [delegate_ respondsToSelector:@selector(bubbleClicked:)]) {          
            [delegate_ bubbleClicked:currentSpeechType_];
        }
        // Otherwise, just automatically go on to the next dialogue
        else {
            if (delegate_ && [delegate_ respondsToSelector:@selector(narrationStopped:)]) {          
                [delegate_ narrationStopped:currentSpeechType_];
            }            
            [self nextDialogue];
        }
    }
}


@end
