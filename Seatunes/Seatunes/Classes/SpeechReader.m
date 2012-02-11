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

@implementation SpeechReader

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
        
        tapRequired_ = tapRequired;
        
        speeches_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        for (NSNumber *speech in speeches) {
            SpeechType speechType = [speech integerValue];
            NSArray *textArray = [[SpeechManager speechManager] textFromSpeechType:speechType];
            for (NSString *text in textArray) {
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
    bubbleDim.numChars = 40;
    bubbleDim.numRows = 6;
    bubbleDim.rowHeight = 40.0f;
    
    // If text remaining
    if (currentSpeechIndex_ < [speeches_ count]) {
        
        SpeechBubble *speechBubble;
        
        // If the last text
        if (currentSpeechIndex_ == [speeches_ count] - 1) {
            if (tapRequired_) {
                speechBubble = [SpeechBubble timedClickSpeechBubble:bubbleDim fullScreenTap:YES time:5.0f];            
            }
            else {
                speechBubble = [SpeechBubble timedSpeechBubble:bubbleDim fullScreenTap:YES time:5.0f];
            }
        }
        // Not the last text
        else {
            speechBubble = [SpeechBubble timedSpeechBubble:bubbleDim fullScreenTap:YES time:5.0f];
        }
        
        NSString *text = [speeches_ objectAtIndex:currentSpeechIndex_];
        speechBubble.delegate = self;
        [speechBubble setTextWithTTF:text fontName:@"Arial" fontSize:16];
        [self addChild:speechBubble];
        currentSpeechIndex_++;
    }
    else {
        if (delegate_ && [delegate_ respondsToSelector:@selector(speechComplete)]) {
            [delegate_ speechComplete];
        }
    }
}

- (void) bubbleComplete:(SpeechBubble *)speechBubble
{
    [speechBubble removeFromParentAndCleanup:YES];
    [self createBubble];
}


@end
