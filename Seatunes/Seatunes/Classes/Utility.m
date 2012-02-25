//
//  Utility.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Utility.h"


@implementation Utility

+ (NSString *) keyNameFromEnum:(KeyType)key
{
    NSString *name = @"";
    
    switch (key) {
        case kC4:
            name = @"C4";
            break;
        case kD4:
            name = @"D4";
            break;
        case kE4:
            name = @"E4";
            break;
        case kF4:
            name = @"F4";
            break;
        case kG4:
            name = @"G4";
            break;
        case kA4:
            name = @"A4";
            break;
        case kB4:
            name = @"B4";
            break;
        case kC5:
            name = @"C5";
            break;      
        default:
            break;
    }
    return name;
}

+ (KeyType) keyEnumFromName:(NSString *)name
{
    if ([name isEqualToString:@"C4"]) {
        return kC4;
    }
    else if ([name isEqualToString:@"D4"]) {
        return kD4;
    }
    else if ([name isEqualToString:@"E4"]) {
        return kE4;
    }
    else if ([name isEqualToString:@"F4"]) {
        return kF4;
    }
    else if ([name isEqualToString:@"G4"]) {
        return kG4;
    }
    else if ([name isEqualToString:@"A4"]) {
        return kA4;
    }
    else if ([name isEqualToString:@"B4"]) {
        return kB4;
    }
    else if ([name isEqualToString:@"C5"]) {
        return kC5;
    }
    else {
        return kBlankNote;
    }
}

+ (NSArray *) allKeyNames
{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:8];
    [keys addObject:[NSNumber numberWithInteger:kC4]];
    [keys addObject:[NSNumber numberWithInteger:kD4]];
    [keys addObject:[NSNumber numberWithInteger:kE4]];
    [keys addObject:[NSNumber numberWithInteger:kF4]];
    [keys addObject:[NSNumber numberWithInteger:kG4]];
    [keys addObject:[NSNumber numberWithInteger:kA4]];
    [keys addObject:[NSNumber numberWithInteger:kB4]];
    [keys addObject:[NSNumber numberWithInteger:kC5]];   
    return keys;
}

+ (NSString *) instrumentNameFromEnum:(InstrumentType)instrument
{
    NSString *name = @"";
    
    switch (instrument) {
        case kPiano:
            name = @"Piano";
            break;       
        case kFlute:
            name = @"PopFlute";
            break;
        case kLowStrings:
            name = @"LunarStrings";
            break;
        case kWarmPiano:
            name = @"Whirly";
            break;
        case kMetallic:
            name = @"Martian";
            break;
        default:
            break;
    }
    
    return name;
}

+ (NSArray *) allInstrumentNames
{
    NSMutableArray *instruments = [NSMutableArray arrayWithCapacity:8];
    [instruments addObject:[NSNumber numberWithInteger:kPiano]];
    [instruments addObject:[NSNumber numberWithInteger:kFlute]];
    [instruments addObject:[NSNumber numberWithInteger:kLowStrings]];
    [instruments addObject:[NSNumber numberWithInteger:kWarmPiano]];
    [instruments addObject:[NSNumber numberWithInteger:kMetallic]];
    return instruments;
}

+ (NSString *) creatureNameFromEnum:(CreatureType)creature
{
    NSString *name = @"";
    
    switch (creature) {
        case kSeaAnemone:
            name = @"Sea Anemone";
            break;            
        case kClam:
            name = @"Clam";
            break;
        default:
            break;
    }
    
    return name;
}

+ (NSString *) instructorNameFromEnum:(InstructorType)instructor
{
    NSString *name = @"";
    
    switch (instructor) {
        case kWhaleInstructor:
            name = @"Whale Instructor";
            break;            
        default:
            break;
    }
    
    return name;    
}

+ (NSString *) packNameFromEnum:(PackType)packType
{
    NSString *name = @"";
    
    switch (packType) {
        case kExercisePack:
            name = @"Exercise Pack";
            break;
        case kNurseryPack:
            name = @"Nursery Pack";
            break;
        case kAmericanClassicsPack:
            name = @"American Classics Pack";
            break;
        default:
            break;
    }
    
    return name;
}

+ (NSArray *) allPackNames
{
    NSMutableArray *packNames = [NSMutableArray arrayWithCapacity:8];
    [packNames addObject:[NSNumber numberWithInteger:kExercisePack]];
    [packNames addObject:[NSNumber numberWithInteger:kNurseryPack]];
    [packNames addObject:[NSNumber numberWithInteger:kAmericanClassicsPack]];
    return packNames;
}

+ (NSArray *) defaultUnlockedPacks
{
    NSMutableArray *packNames = [NSMutableArray arrayWithCapacity:8];
    [packNames addObject:[NSNumber numberWithInteger:kExercisePack]];
    return packNames;
}

+ (NSString *) difficultyPlayedKeyFromEnum:(DifficultyType)difficulty
{
    NSString *name = @"";
    
    switch (difficulty) {
        case kDifficultyEasy:
            name = @"Easy Played"; 
            break;
        case kDifficultyMedium:
            name = @"Medium Played";
            break;
        case kDifficultyHard:
            name = @"Hard Played";
            break;
        default:
            break;
    }
    
    return name;
}

+ (NSString *) soundFileFromEnum:(SoundType)soundType
{
    NSString *name = @"";
    
    switch (soundType) {
        case kApplause:
            name = @"Applause 2.caf";
            break;
        case kPageFlip:
            name = @"Page Flip.caf";
            break;
        case kMenuB0:
            name = @"Menu Sound B0.caf";
            break;
        case kMenuC1:
            name = @"Menu Sound C1.caf";
            break;
        case kMenuD1:
            name = @"Menu Sound D1.caf";
            break;
        case kMenuE1:
            name = @"Menu Sound E1.caf";
            break;
        case kMenuF1:
            name = @"Menu Sound F1.caf";
            break;            
        case kMenuG1:
            name = @"Menu Sound G1.caf";
            break; 
        case kMenuA1:
            name = @"Menu Sound A1.caf";
            break; 
        case kMenuB1:
            name = @"Menu Sound B1.caf";
            break; 
        case kMenuC2:
            name = @"Menu Sound C2.caf";
            break;             
        default:
            break;
    }
    
    return name;
}

+ (NSArray *) loadSectionedSong:(NSString *)songName
{
    NSMutableArray *sections = [NSMutableArray array];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *storedSections = [NSArray arrayWithArray:[data objectForKey:@"Notes"]];    
    
    for (NSArray *section in storedSections) {
        NSMutableArray *notes = [NSMutableArray array];
        for (NSString *note in section) {
            NSNumber *key = [NSNumber numberWithInteger:[Utility keyEnumFromName:note]];
            [notes addObject:key];            
        }
        [sections addObject:notes];
    }
    
    return sections;
}

+ (NSArray *) loadFlattenedSong:(NSString *)songName
{
    NSMutableArray *notes = [NSMutableArray array];    
    
	NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *storedSections = [[NSArray arrayWithArray:[data objectForKey:@"Notes"]] retain];
    
    for (NSArray *section in storedSections) {
        for (NSString *note in section) {
            NSNumber *key = [NSNumber numberWithInteger:[Utility keyEnumFromName:note]];
            [notes addObject:key];
        }            
    }
    
    return notes;
}

+ (NSUInteger) countNumNotes:(NSArray *)notes
{
    NSUInteger count = 0;
    for (NSNumber *note in notes) {
        if ([note integerValue] != kBlankNote) {
            count++;
        }
    }
    return count;
}

+ (NSUInteger) countNumNotesFromSections:(NSArray *)sections
{
    NSUInteger count = 0;
    for (NSArray *section in sections) {
        count += [Utility countNumNotes:section];
    }
    return count;
}

+ (NSMutableArray *) generateBoolArray:(BOOL)val size:(NSUInteger)size
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:size];
    for (NSUInteger i = 0; i < size; ++i) {
        [array addObject:[NSNumber numberWithBool:val]];
    }
    return array;
}

+ (NSUInteger) countNumBool:(BOOL)val array:(NSArray *)array
{
    NSUInteger count = 0;
    for (NSNumber *number in array) {
        if ([number boolValue] == val) {
            count++;
        }
    }
    return count;
}

@end
