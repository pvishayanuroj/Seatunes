//
//  DataUtility.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/12/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>

@interface DataUtility : NSObject {
    
}

+ (NSDictionary *) loadSongScores;

+ (void) saveSongScore:(NSString *)songName score:(ScoreType)score;

+ (void) resetSongScores;

+ (NSArray *) loadUnlockedPacks;

+ (void) unlockPack:(PackType)packType;

+ (void) unlockAllPacks;

@end
