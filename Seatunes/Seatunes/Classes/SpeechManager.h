//
//  SpeechManager.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/11/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>

@interface SpeechManager : NSObject {
    
    NSDictionary *speechText_;
    
}

+ (SpeechManager *) speechManager;

+ (void) purgeSpeechManager;

- (NSDictionary *) loadSpeechText;

- (NSArray *) textFromSpeechType:(SpeechType)speechType;

@end
