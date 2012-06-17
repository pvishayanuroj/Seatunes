//
//  SpeechManager.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/11/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>

#define kSpeechFileType @"mp3"

@interface SpeechManager : NSObject {
    
    NSMutableDictionary *speechText_;
    
}

+ (SpeechManager *) speechManager;

+ (void) purgeSpeechManager;

- (void) loadSpeechText:(NSString *)filename;

- (void) loadFlatSpeechText:(NSString *)filename;

- (NSArray *) textFromSpeechType:(SpeechType)speechType;

- (NSDictionary *) textAndAudioFromSpeechTypes:(NSArray *)speechTypes;

@end
