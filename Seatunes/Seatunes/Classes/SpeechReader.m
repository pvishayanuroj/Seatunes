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

@synthesize delegate = delegate_;

+ (id) speechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    return [[[self alloc] initSpeechReader:speeches tapRequired:tapRequired] autorelease];
}

- (id) initSpeechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:@"Speech Bubble Large.png"] retain];
        delegate_ = nil;
        currentSpeechIndex_ = 0;
        lastSpeechType_ = [[speeches lastObject] integerValue];
        isClickable_ = YES;
        tapRequired_ = tapRequired;
        
        data_ = [[[SpeechManager speechManager] textAndAudioFromSpeechTypes:speeches] retain];
        
        [self nextDialogue];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [data_ release];
    
    [super dealloc];
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
        
        Text *text = [Text text:line fntFile:@"Dialogue Font.fnt"];
        [text addFntFile:@"MenuFont.fnt" textType:kTextBold];
        [self addChild:text];
        
        [[AudioManager audioManager] stopSound:effectID_];
        effectID_ = [[AudioManager audioManager] playSoundEffectFile:path];
        
        currentSpeechIndex_++;
    }
    else {
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete:)]) {
            [delegate_ speechComplete:lastSpeechType_];
            [self removeFromParentAndCleanup:YES];
        }
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
        [self nextDialogue];
    }
}


@end
