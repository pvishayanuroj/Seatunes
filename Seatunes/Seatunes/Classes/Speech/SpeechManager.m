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
    
        speechText_ = [[NSMutableDictionary dictionaryWithCapacity:100] retain];
        [self loadSpeechText:@"Speech"];
        [self loadFlatSpeechText:@"Music Tutorial"];
        
	}
	return self;
}

- (void) dealloc
{		    
    [speechText_ release];
    
	[super dealloc];
}

- (void) loadSpeechText:(NSString *)filename
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];

    for (NSString *key in data) {
        
        NSAssert([speechText_ objectForKey:key] == nil, @"Duplicate key: %@ in speech text file: %@", key, filename);

        [speechText_ setObject:[data objectForKey:key] forKey:key];
    }
}
         
- (void) loadFlatSpeechText:(NSString *)filename
{
	NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    for (NSString *key in data) {
        
        NSAssert([speechText_ objectForKey:key] == nil, @"Duplicate key: %@ in speech text file: %@", key, filename);
        
        NSMutableArray *choiceArray = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray *textArray = [NSMutableArray arrayWithCapacity:1];
        
        [textArray addObject:[data objectForKey:key]];
        [choiceArray addObject:textArray];
        [speechText_ setObject:choiceArray forKey:key];
    }
}

- (NSString *) keyFromSpeechType:(SpeechType)speechType
{
    NSString *key = @"";
    
    switch (speechType) {
        case kSpeechIntroduction:
            key = @"Introduction";
            break;
        case kSpeechEasyTutorial:
            key = @"Easy Tutorial";
            break;
        case kSpeechMediumTutorial:
            key = @"Medium Tutorial";
            break;
        case kSpeechGreetings:
            key = @"Greetings";
            break;
        case kSpeechSongStart:
            key = @"Song Start";            
            break;
        case kSpeechScolding:
            key = @"Scolding";            
            break;
        case kSpeechSongCompleteGood:
            key = @"Song Complete Good";            
            break;
        case kSpeechSongCompleteBad:
            key = @"Song Complete Bad";
            break;
        case kSpeechRandomSaying:
            key = @"Random Saying";
            break;
        case kSpeechScoreExplanation:
            key = @"Score Explanation";
            break;
        case kSpeechBubbleBadge:
            key = @"Bubble Badge";            
            break;
        case kSpeechClamBadge:
            key = @"Clam Badge";
            break;
        case kSpeechNoteBadge:
            key = @"Note Badge";
            break;
        case kSpeechTutorialPrompt:
            key = @"Tutorial Prompt";
            break;
        case kTutorialIntroduction:
            key = @"Tutorial Introduction";
            break;
        case kTutorialIntroduction2:
            key = @"Tutorial Introduction 2";
            break;            
        case kTutorialStaff:
            key = @"Tutorial Staff";
            break;
        case kTutorialNotes:
            key = @"Tutorial Notes";
            break;
        case kTutorialNotes2:
            key = @"Tutorial Notes 2";
            break;
        case kTutorialLetters:
            key = @"Tutorial Letters";
            break;
        case kTutorialLearnC:
            key = @"Tutorial Learn C";
            break;
        case kTutorialPlayC:
            key = @"Tutorial Play C";
            break;
        case kTutorialPlayDE:
            key = @"Tutorial Play DE";
            break;
        case kTutorialPlayFG:
            key = @"Tutorial Play FG";
            break;
        case kTutorialPlayABC:
            key = @"Tutorial Play ABC";
            break;
        case kTutorialMnemonic:
            key = @"Tutorial Mnemonic";
            break;
        case kTutorialEvery:
            key = @"Tutorial Every";
            break;
        case kTutorialGood:
            key = @"Tutorial Good";
            break;
        case kTutorialBoy:
            key = @"Tutorial Boy";
            break;
        case kTutorialFace:
            key = @"Tutorial Face";
            break;
        case kTutorialF:
            key = @"Tutorial F";
            break;
        case kTutorialA:
            key = @"Tutorial A";
            break;
        case kTutorialC:
            key = @"Tutorial C";
            break;
        case kTutorialComplete:
            key = @"Tutorial Complete";
            break;
        case kLOIntro:
            key = @"seatunes-sam";            
            break;
        case kLORandom1:
            key = @"colorful-ocean-awaits";            
            break;
        case kLORandom2:
            key = @"discover-new-animals";            
            break;
        case kLORandom3:
            key = @"follow-me";            
            break;
        case kLORandom4:
            key = @"so-much-fun";            
            break;
        case kLORandom5:
            key = @"time-for-exploration";            
            break;
        default:
            break;
    }
    return key;
}

- (NSDictionary *) textAndAudioFromSpeechTypes:(NSArray *)speechTypes
{
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithCapacity:2];
    NSMutableArray *text = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *audio = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *types = [NSMutableArray arrayWithCapacity:10];

    // For all speech types
    for (NSNumber *speech in speechTypes) {

        // Get the choices for this speech type
        SpeechType speechType = [speech integerValue];
        NSString *key = [self keyFromSpeechType:speechType];
        NSArray *choices = [speechText_ objectForKey:key];
        
        // Make a random selection
        NSUInteger numChoices = [choices count];
        NSInteger choice = arc4random() % numChoices;
        NSArray *lines = [choices objectAtIndex:choice];        
        
        // For each line, store the text and determine the audio file path
        NSInteger lineNum = 0;
        for (NSString *line in lines) {
            
            NSString *path = [NSString stringWithFormat:@"%@ %02d-%02d.%@", key, choice, lineNum, kSpeechFileType];
            [text addObject:line];
            [audio addObject:path];
            [types addObject:speech];
            
            lineNum++;
        }   
    }
    
    [data setObject:text forKey:@"Text"];
    [data setObject:audio forKey:@"Audio"];
    [data setObject:types forKey:@"Types"];             
    
    return data;
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
