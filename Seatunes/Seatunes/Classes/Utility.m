//
//  Utility.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

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

+ (NSString *) nameFromEnum:(KeyType)key
{
    NSString *name = @"";
    
    switch (key) {
        case kC4:
            name = @"C";
            break;
        case kD4:
            name = @"D";
            break;
        case kE4:
            name = @"E";
            break;
        case kF4:
            name = @"F";
            break;
        case kG4:
            name = @"G";
            break;
        case kA4:
            name = @"A";
            break;
        case kB4:
            name = @"B";
            break;
        case kC5:
            name = @"C";
            break;      
        default:
            break;
    }
    return name;    
}

+ (NSString *) alternateNameFromEnum:(KeyType)key
{
    NSString *name = @"";
    
    switch (key) {
        case kC4:
            name = @"C";
            break;
        case kD4:
            name = @"D";
            break;
        case kE4:
            name = @"Every";
            break;
        case kF4:
            name = @"F";
            break;
        case kG4:
            name = @"Good";
            break;
        case kA4:
            name = @"A";
            break;
        case kB4:
            name = @"Boy";
            break;
        case kC5:
            name = @"C";
            break;      
        case kD5:
            name = @"Does";
            break; 
        case kE5:
            name = @"E";
            break;  
        case kF5:
            name = @"Fine";
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
        case kMuted:
            name = @"Muted";
            break;
        case kMenu:
            name = @"Menu";
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
    [instruments addObject:[NSNumber numberWithInteger:kMuted]];
    [instruments addObject:[NSNumber numberWithInteger:kMenu]];    
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

+ (NSString *) difficultyPlayedKeyFromEnum:(DifficultyType)difficulty
{
    return [NSString stringWithFormat:@"%@ Played", [self difficultyFromEnum:difficulty]];    
}

+ (NSString *) difficultyFromEnum:(DifficultyType)difficulty
{
    NSString *name = @"";
    
    switch (difficulty) {
        case kDifficultyEasy:
            name = @"Easy"; 
            break;
        case kDifficultyMedium:
            name = @"Medium";
            break;
        case kDifficultyHard:
            name = @"Hard";
            break;
        case kDifficultyMusicNoteTutorial:
            name = @"Music Note Tutorial";
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
        case kClamHit:
            name = @"Clam Hit.m4a";
            break;
        case kDing:
            name = @"Ding.mp3";
            break;
        case kSuccess:
            name = @"Success.mp3";
            break;
        case kThud:
            name = @"Thud.mp3";
            break;
        case kWahWah:
            name = @"Wah Wah.mp3";
            break;    
        case kBubblePop:
            name = @"Bubble Pop.mp3";
            break;
        case kSwoosh1:
            name = @"Swoosh 1.mp3";
            break;
        case kSwoosh2:
            name = @"Swoosh 2.mp3";
            break;
        case kSwoosh3:
            name = @"Swoosh 3.mp3";
            break;            
        default:
            break;
    }
    
    return name;
}

+ (NSArray *) allSoundEffects
{
    NSMutableArray *sounds = [NSMutableArray arrayWithCapacity:12];
    [sounds addObject:[NSNumber numberWithInteger:kApplause]];
    [sounds addObject:[NSNumber numberWithInteger:kPageFlip]];
    [sounds addObject:[NSNumber numberWithInteger:kClamHit]];
    [sounds addObject:[NSNumber numberWithInteger:kDing]];
    [sounds addObject:[NSNumber numberWithInteger:kSuccess]];    
    [sounds addObject:[NSNumber numberWithInteger:kThud]];
    [sounds addObject:[NSNumber numberWithInteger:kWahWah]];       
    [sounds addObject:[NSNumber numberWithInteger:kBubblePop]];    
    [sounds addObject:[NSNumber numberWithInteger:kSwoosh1]];    
    [sounds addObject:[NSNumber numberWithInteger:kSwoosh2]];   
    [sounds addObject:[NSNumber numberWithInteger:kSwoosh3]];       
    
    return sounds;
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

+ (NSMutableDictionary *) initializeScoreDictionary:(NSArray *)notes
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[notes count]];
    
    NSUInteger i = 0;
    for (NSNumber *note in notes) {    
        
        switch ([note integerValue]) {
            case kBlankNote:
                [dict setObject:[NSNumber numberWithInteger:kNoteBlank] forKey:[NSNumber numberWithUnsignedInteger:i]];
                break;
            default:
                [dict setObject:[NSNumber numberWithInteger:kNoteHit] forKey:[NSNumber numberWithUnsignedInteger:i]];
                break;
        }
        i++;
    }
    
    return dict;
}

+ (ScoreInfo) tallyScoreDictionary:(NSDictionary *)dictionary scoreInfo:(ScoreInfo)scoreInfo
{
    scoreInfo.notesHit = 0;
    scoreInfo.notesMissed = 0;
    
    for (NSNumber *number in [dictionary allValues]) {
        switch ([number integerValue]) {
            case kNoteHit:
                scoreInfo.notesHit++;
                break;
            case kNoteMissed:
                scoreInfo.notesMissed++;
                break;
            default:
                break;
        }
    }
    
    scoreInfo.percentage = round(100.0f * (CGFloat)scoreInfo.notesHit / (CGFloat)(scoreInfo.notesHit + scoreInfo.notesMissed));    
    
    return scoreInfo;
}

+ (NSString *) songKey:(NSString *)songName difficulty:(DifficultyType)difficulty
{
    NSString *difficultyName = [self difficultyFromEnum:difficulty];
    NSString *key = [NSString stringWithFormat:@"%@ %@", songName, difficultyName];    
    return key;
}

+ (CGFloat) getSlope:(CGPoint)a b:(CGPoint)b
{
    return (a.y - b.y) / (a.x - b.x);
}

+ (BOOL) hasInternetConnection
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    
    return [reachability currentReachabilityStatus] != NotReachable;
}

@end
