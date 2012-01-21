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

@end
