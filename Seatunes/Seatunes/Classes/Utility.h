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

+ (NSString *) packNameFromEnum:(PackType)packType;

+ (NSArray *) allPackNames;

+ (NSArray *) loadSong:(NSString *)songName;

+ (NSArray *) loadFlattenedSong:(NSString *)songName;

@end
