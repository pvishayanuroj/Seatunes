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

+ (NSString *) instrumentNameFromEnum:(InstrumentType)instrument
{
    NSString *name = @"";
    
    switch (instrument) {
        case kPiano:
            name = @"Piano";
            break;            
        default:
            break;
    }
    
    return name;
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

@end
