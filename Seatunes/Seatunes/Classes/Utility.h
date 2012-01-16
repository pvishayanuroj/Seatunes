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

+ (NSString *) instrumentNameFromEnum:(InstrumentType)instrument;

+ (NSString *) creatureNameFromEnum:(CreatureType)creature;

+ (NSString *) instructorNameFromEnum:(InstructorType)creature;

@end
