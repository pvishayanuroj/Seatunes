//
//  SpeechReader.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/7/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SpeechReader.h"
#import "SpeechBubble.h"
#import "SpeechManager.h"
#import "AudioManager.h"

@implementation SpeechReader

static const NSUInteger SR_CHARS_PER_ROW = 35;
static const NSUInteger SR_NUM_ROWS = 6;
static const CGFloat SR_ROW_HEIGHT = 40.0f;
static const CGFloat SR_TEXT_OFFSET_X = -180.0f;
static const CGFloat SR_TEXT_OFFSET_Y = 80.0f;
const static CGFloat SR_DEFAULT_DURATION = 5.0f;

@synthesize delegate = delegate_;

+ (id) speechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    return [[[self alloc] initSpeechReader:speeches tapRequired:tapRequired] autorelease];
}

- (id) initSpeechReader:(NSArray *)speeches tapRequired:(BOOL)tapRequired
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        currentBubble_ = nil;
        currentSpeechIndex_ = 0;
        lastSpeechType_ = [[speeches lastObject] integerValue];
        
        tapRequired_ = tapRequired;
        
        speeches_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        for (NSNumber *speech in speeches) {
            SpeechType speechType = [speech integerValue];
            NSArray *textArray = [[SpeechManager speechManager] textFromSpeechType:speechType];
            for (NSDictionary *text in textArray) {
                [speeches_ addObject:text];
            }
        }
        
        [self createBubble];
    }
    return self;
}

- (void) dealloc
{
    [speeches_ release];
    
    [super dealloc];
}

- (void) createBubble
{
    SpeechBubbleDim bubbleDim;
    bubbleDim.numChars = SR_CHARS_PER_ROW;
    bubbleDim.numRows = SR_NUM_ROWS;
    bubbleDim.rowHeight = SR_ROW_HEIGHT;
    bubbleDim.textOffset = ccp(SR_TEXT_OFFSET_X, SR_TEXT_OFFSET_Y);
    
    // If text remaining
    if (currentSpeechIndex_ < [speeches_ count]) {
        
        SpeechBubble *speechBubble;
        NSDictionary *speech = [speeches_ objectAtIndex:currentSpeechIndex_];
        NSString *text = [speech objectForKey:@"Text"];
        NSString *file = [speech objectForKey:@"Path"];        
        NSNumber *duration = [speech objectForKey:@"Duration"];
        if (duration == nil) {
            duration = [NSNumber numberWithFloat:SR_DEFAULT_DURATION];
        }
        
        if (tapRequired_) {
            speechBubble = [SpeechBubble tapSpeechBubble:bubbleDim fullScreenTap:NO];
        }
        else {
            speechBubble = [SpeechBubble timedSpeechBubble:bubbleDim time:[duration floatValue]];
        }

        speechBubble.delegate = self;
        [speechBubble setTextWithBMFont:text fntFile:@"Dialogue Font.fnt"];
        [self addChild:speechBubble];
        
        [[AudioManager audioManager] stopSound:effectID_];
        NSLog(@"file: %@", file);
        effectID_ = [[AudioManager audioManager] playSoundEffectFile:file];
        
        currentSpeechIndex_++;
    }
    else {
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete:)]) {
            [delegate_ speechComplete:lastSpeechType_];
            [self removeFromParentAndCleanup:YES];
        }
    }
}

- (void) bubbleComplete:(SpeechBubble *)speechBubble
{
    [speechBubble removeFromParentAndCleanup:YES];
    [self createBubble];
}


@end
