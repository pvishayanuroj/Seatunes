//
//  SpeechBubble.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SpeechBubble.h"

@implementation SpeechBubble

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (id) tapSpeechBubble:(SpeechBubbleDim)dim fullScreenTap:(BOOL)fullScreenTap
{
    return [[[self alloc] initSpeechBubble:dim bubbleType:kBubbleClick fullScreenTap:fullScreenTap time:0] autorelease];    
}

+ (id) timedSpeechBubble:(SpeechBubbleDim)dim fullScreenTap:(BOOL)fullScreenTap time:(CGFloat)time
{
    return [[[self alloc] initSpeechBubble:dim bubbleType:kBubbleTimed fullScreenTap:fullScreenTap time:time] autorelease];    
}

+ (id) timedClickSpeechBubble:(SpeechBubbleDim)dim fullScreenTap:(BOOL)fullScreenTap time:(CGFloat)time
{
    return [[[self alloc] initSpeechBubble:dim bubbleType:kBubbleTimedClick fullScreenTap:fullScreenTap time:time] autorelease];    
}

- (id) initSpeechBubble:(SpeechBubbleDim)dim bubbleType:(BubbleType)bubbleType fullScreenTap:(BOOL)fullScreenTap time:(CGFloat)time
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        maxChars_ = dim.numChars;
        maxRows_ = dim.numRows;
        rowHeight_ = dim.rowHeight;
        time_ = time;
        bubbleType_ = bubbleType;
        fullScreenTap_ = fullScreenTap;
        
        switch (bubbleType) {
            case kBubbleClick:
                isClickable_ = YES;
                break;
            default:
                isClickable_ = NO;
                break;
        }
        
        textContainer_ = [[NSMutableArray arrayWithCapacity:5] retain];
        
        sprite_ = [[CCSprite spriteWithFile:@"Speech Bubble.png"] retain];
        [self addChild:sprite_];
        
    }
    return self;    
}

- (void) dealloc
{
    [textContainer_ release];
    [sprite_ release];
    
    [super dealloc];
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
        if (fullScreenTap_) {
            return YES;
        }
        return [self containsTouchLocation:touch];
    }
    
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!fullScreenTap_) {
        if (![self containsTouchLocation:touch]) {
            return;
        }
    }

    [self destroyBubble];
}

#pragma mark - Helper Methods

- (void) destroyBubble
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(bubbleComplete:)]) {
        [delegate_ bubbleComplete:self];
    }
}

- (void) timerExpire
{
    switch (bubbleType_) {
        case kBubbleTimed:
            [self destroyBubble];
            break;
        case kBubbleTimedClick:
            isClickable_ = YES;
            break;
        default:
            break;
    }
}

- (NSString *) parseText:(NSString *)text
{
    NSUInteger charCount = 0;
    NSUInteger rowCount = 0;
    
    NSArray *components = [self separateWords:text];

    NSMutableArray *row = [NSMutableArray array];
    [textContainer_ addObject:row];    
    
    NSUInteger index = 0;
    for (NSString *word in components) {
        
        NSUInteger wordLength = [word length];
        // If word is longer than the allowed size per row, just add it, hopefully you'll notice
        if (wordLength > maxChars_) {
            
            NSLog(@"Error - The following word is larger than the allowed width of the speech bubble: %@", word);
            
        }
        else {
            
            // If word will make the row too long, start a new row
            if ((charCount + wordLength + 1) > maxChars_) {
                
                // If making a new row would exceed the allowed number of rows,
                // speech bubble is done
                if (++rowCount == maxRows_) {
                    // Add the ellipsis to the end
                    [row addObject:[NSString stringWithString:@"..."]];
                    
                    NSRange range = NSMakeRange(index, [components count] - index);
                    return [self flatten:[components subarrayWithRange:range]];
                }
                
                // Make a new row
                row = [NSMutableArray array];
                [textContainer_ addObject:row];
                charCount = 0;
            }

            // Add the word to the current row
            [row addObject:word];
            charCount += (wordLength + 1);
        }
        index++;
    }
    return [NSString string];
}

- (NSString *) setTextWithBMFont:(NSString*)string fntFile:(NSString*)fntFile
{
    NSString *remainder = [self parseText:string];
    
    NSUInteger rowNum = 0;
    for (NSArray *row in textContainer_) {
        
        NSString *text = [NSString string];        
        for (NSString *word in row) {
            text = [text stringByAppendingFormat:@"%@ ", word];
        }
        
        CCLabelBMFont *label = [CCLabelBMFont labelWithString:text fntFile:fntFile];
        label.position = ccp(-rowNum * rowHeight_, 0);
        label.anchorPoint = ccp(0, 0.5f);
        [self addChild:label];
        
        rowNum++;
    }    
    
    if (time_ > 0) {
        CCActionInterval *delay = [CCDelayTime actionWithDuration:time_];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(timerExpire)];
        [self runAction:[CCSequence actions:delay, done, nil]];
    }
    
    return remainder;
}

- (NSString *) setTextWithTTF:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size
{
    NSString *remainder = [self parseText:string];

    NSInteger rowNum = 0;
    for (NSArray *row in textContainer_) {
        
        NSString *text = [NSString string];        
        for (NSString *word in row) {
            text = [text stringByAppendingFormat:@"%@ ", word];
        }
        
        NSLog(@"Adding %@", text);        
        CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:name fontSize:size];
        label.position = ccp(0, -rowNum * rowHeight_);
        DebugPoint(@"pt", label.position);
        label.anchorPoint = ccp(0, 0.5f);
        label.color = ccc3(0, 0, 0);
        [self addChild:label];
        
        rowNum++;
    }       
    
    if (time_ > 0) {
        CCActionInterval *delay = [CCDelayTime actionWithDuration:time_];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(timerExpire)];
        [self runAction:[CCSequence actions:delay, done, nil]];
    }    
    
    return remainder;    
}

- (NSString *) flatten:(NSArray *)components
{
    NSString *text = [NSString string];
    for (NSString *word in components) {
        [text stringByAppendingString:word];
    }
    return text;
}

- (NSArray *) separateWords:(NSString *)text
{
    return [text componentsSeparatedByString:@" "];
}

@end
