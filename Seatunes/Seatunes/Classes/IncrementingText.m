//
//  IncrementingText.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "IncrementingText.h"
#import "AudioManager.h"

@implementation IncrementingText

static const CGFloat IT_DURATION = 2.0f;

@synthesize unitID = unitID_;
@synthesize delegate = delegate_;

+ (id) incrementingText:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment incrementType:(IncrementType)incrementType
{
    return [[[self alloc] initIncrementingText:score font:font alignment:alignment start:YES show:YES incrementType:incrementType] autorelease];
}

+ (id) incrementingTextNoStart:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment incrementType:(IncrementType)incrementType
{
    return [[[self alloc] initIncrementingText:score font:font alignment:alignment start:NO show:YES incrementType:incrementType] autorelease];
}

+ (id) incrementingTextHidden:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment incrementType:(IncrementType)incrementType
{
    return [[[self alloc] initIncrementingText:score font:font alignment:alignment start:NO show:NO incrementType:incrementType] autorelease];
}

- (id) initIncrementingText:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment start:(BOOL)start show:(BOOL)show incrementType:(IncrementType)incrementType
{
    if ((self = [super init])) {
        
        score_ = 0;
        finalScore_ = score;
        timer_ = 0;        
        incrementType_ = incrementType;
        
        NSString *scoreString;
        
        switch (incrementType) {
            case kIncrementInteger:
                scoreString = [NSString stringWithFormat:@"%d", score_];
                break;
            case kIncrementPercentage:
                scoreString = [NSString stringWithFormat:@"%d%%", score_];
                break;
            case kIncrementTime:
                scoreString = [self convertToFormattedTime:score_]; 
                break;
            default:
                break;
        }
        
        scoreLabel_ = [[CCLabelBMFont labelWithString:scoreString fntFile:font] retain];        
        scoreLabel_.visible = show;        
        [self addChild:scoreLabel_];
        
        if (alignment == kRightAligned) {
            scoreLabel_.anchorPoint = CGPointMake(1.0f, 0.5f);
        }
        else if (alignment == kLeftAligned) {
            scoreLabel_.anchorPoint = CGPointMake(0.0f, 0.5f);
        }
        
        if (start) {
            [self schedule:@selector(update:) interval:1/60.0f];
            scoreLabel_.visible = YES;
        }
    }
    return self;
}

- (void) dealloc
{
    [scoreLabel_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    timer_ += dt;
    score_ = finalScore_ * (timer_ / IT_DURATION);
    
    if (score_ >= finalScore_) {
        score_ = finalScore_;
        if ([delegate_ respondsToSelector:@selector(incrementationDone:)]) {
            [delegate_ incrementationDone:self];
        }
        [self unschedule:@selector(update:)];
    }
    
    [[AudioManager audioManager] playSoundEffect:kDing];
    
    switch (incrementType_) {
        case kIncrementTime:
            [scoreLabel_ setString:[self convertToFormattedTime:score_]];
            break;
        case kIncrementInteger:
            [scoreLabel_ setString:[NSString stringWithFormat:@"%d", score_]];
            break;
        case kIncrementPercentage:
            [scoreLabel_ setString:[NSString stringWithFormat:@"%d%%", score_]];
            break;
        default:
            break;
    }
}

- (NSString *) convertToFormattedTime:(NSInteger)time
{
    NSInteger tenths = time % 10;
    NSInteger seconds = time / 10;
    NSInteger minutes = seconds / 60;
    
    NSString *string = [NSString stringWithFormat:@"%d:%02d.%d", minutes % 60, seconds % 60, tenths];
    return string;
}

- (void) startIncrementing
{
    scoreLabel_.visible = YES;
    [self schedule:@selector(update:) interval:1/60.0f];    
}

@end
