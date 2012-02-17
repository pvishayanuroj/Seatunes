//
//  SpeechManager.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/11/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SpeechManager.h"

// For singleton
static SpeechManager *_speechManager = nil;

@implementation SpeechManager

#pragma mark - Object Lifecycle

+ (SpeechManager *) speechManager
{
    @synchronized(self) {
        if (!_speechManager) {
            _speechManager = [[self alloc] init];
        }
    }
	
	return _speechManager;
}

+ (id) alloc
{
	NSAssert(_speechManager == nil, @"Attempted to allocate a second instance of a Speech Manager singleton.");
	return [super alloc];
}

+ (void) purgeSpeechManager
{
	[_speechManager release];
	_speechManager = nil;
}

- (id) init
{
	if ((self = [super init])) {
    
        speechText_ = [[self loadSpeechText] retain];
        
	}
	return self;
}

- (void) dealloc
{		    
    [speechText_ release];
    
	[super dealloc];
}

- (NSDictionary *) loadSpeechText
{
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Speech" ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    return data;
}

- (NSString *) keyFromSpeechType:(SpeechType)speechType
{
    NSString *key = @"";
    
    switch (speechType) {
        case kEasyInstructions:
            key = @"Easy Instructions";
            break;
        case kEasyInstructions2:
            key = @"Easy Instructions 2";            
            break;
        case kMediumInstructions:
            key = @"Medium Instructions";
            break;
        case kHardInstructions:
            key = @"Hard Instructions";
            break;
        case kSongStart:
            key = @"Song Start";
            break;
        case kWrongNote:
            key = @"Wrong Note";
            break;
        case kEasyWrongNote:
            key = @"Easy Wrong Note";
            break;
        case kEasyCorrectNote:
            key = @"Easy Correct Note";
            break;
        case kEasyReplay:
            key = @"Easy Replay";
            break;
        case kMediumReplay:
            key = @"Medium Replay";
            break;
        case kHardReplay:
            key = @"Hard Replay";
            break;
        case kNextSection:
            key = @"Next Section";
            break;
        case kHardPlay:
            key = @"Hard Play";
            break;
        default:
            break;
    }
    return key;
}

- (NSArray *) textFromSpeechType:(SpeechType)speechType
{
    NSArray *text;
    NSString *key = [self keyFromSpeechType:speechType];
    NSArray *textChoices = [speechText_ objectForKey:key];
    
    if (textChoices) {
        
        // Make a random selection
        NSUInteger numChoices = [textChoices count];
        NSInteger choice = arc4random() % numChoices;
        text = [textChoices objectAtIndex:choice];
        
    }
    else {
        NSAssert(NO, @"Speech text not found");
    }
    
    return text;
}

@end
