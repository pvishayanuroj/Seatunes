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

+ (NSString *) nameFromEnum:(KeyType)key;

+ (NSString *) alternateNameFromEnum:(KeyType)key;

+ (KeyType) keyEnumFromName:(NSString *)name;

+ (NSArray *) allKeyNames;

+ (NSString *) instrumentNameFromEnum:(InstrumentType)instrument;

+ (NSArray *) allInstrumentNames;

+ (NSString *) creatureNameFromEnum:(CreatureType)creature;

+ (NSString *) instructorNameFromEnum:(InstructorType)instructor;

+ (NSString *) difficultyPlayedKeyFromEnum:(DifficultyType)difficulty;

+ (NSString *) difficultyFromEnum:(DifficultyType)difficulty;

+ (NSString *) soundFileFromEnum:(SoundType)soundType;

+ (NSArray *) allSoundEffects;

+ (NSArray *) loadSectionedSong:(NSString *)songName;

+ (NSArray *) loadFlattenedSong:(NSString *)songName;

+ (NSUInteger) countNumNotes:(NSArray *)notes;

+ (NSUInteger) countNumNotesFromSections:(NSArray *)sections;
 
+ (NSMutableDictionary *) initializeScoreDictionary:(NSArray *)notes;

+ (ScoreInfo) tallyScoreDictionary:(NSDictionary *)dictionary;

+ (NSString *) songKey:(NSString *)songName difficulty:(DifficultyType)difficulty;

+ (CGFloat) getSlope:(CGPoint)a b:(CGPoint)b;

+ (BOOL) hasInternetConnection;

@end
