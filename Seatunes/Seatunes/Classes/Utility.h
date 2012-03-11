//
//  Utility.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Utility : NSObject {
    
}

+ (NSString *) keyNameFromEnum:(KeyType)key;

+ (KeyType) keyEnumFromName:(NSString *)name;

+ (NSArray *) allKeyNames;

+ (NSString *) instrumentNameFromEnum:(InstrumentType)instrument;

+ (NSArray *) allInstrumentNames;

+ (NSString *) creatureNameFromEnum:(CreatureType)creature;

+ (NSString *) instructorNameFromEnum:(InstructorType)instructor;

+ (NSString *) difficultyPlayedKeyFromEnum:(DifficultyType)difficulty;

+ (NSString *) soundFileFromEnum:(SoundType)soundType;

+ (NSArray *) loadSectionedSong:(NSString *)songName;

+ (NSArray *) loadFlattenedSong:(NSString *)songName;

+ (NSUInteger) countNumNotes:(NSArray *)notes;

+ (NSUInteger) countNumNotesFromSections:(NSArray *)sections;

+ (NSMutableArray *) generateBoolArray:(BOOL)val size:(NSUInteger)size;

+ (NSUInteger) countNumBool:(BOOL)val array:(NSArray *)array;

+ (NSMutableDictionary *) generateBoolDictionary:(BOOL)val size:(NSUInteger)size;

+ (NSUInteger) countNumBoolInDictionary:(BOOL)val dictionary:(NSDictionary *)dictionary;

+ (BOOL) hasInternetConnection;

@end
