//
//  DataUtility.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/12/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "DataUtility.h"
#import "Utility.h"

@implementation DataUtility

+ (NSDictionary *) loadSongScores
{
    NSDictionary *scores = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"Song Scores"];
    
    if (scores == nil) {
        scores = [NSDictionary dictionary];
    }
    return scores;
}

+ (void) saveSongScore:(NSString *)songName score:(ScoreType)score
{
    NSMutableDictionary *scores = [NSMutableDictionary dictionaryWithDictionary:[self loadSongScores]];
    
    NSNumber *savedScore = [scores objectForKey:songName];
    
    // Only save score if it is greater than saved score or if saved score doesn't exist
    if (savedScore != nil) {
        if (score < [savedScore integerValue]) {
            return;
        }
    }
    
    [scores setObject:[NSNumber numberWithInteger:score] forKey:songName];
    [[NSUserDefaults standardUserDefaults] setObject:scores forKey:@"Song Scores"];        
}

+ (void) resetSongScores
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Song Scores"];
}

+ (NSArray *) loadUnlockedPacks
{
    NSArray *packs;
    
    // First check if all packs were unlocked
    BOOL allPacks = [[NSUserDefaults standardUserDefaults] boolForKey:@"All Packs"];
    if (allPacks) {
        packs = [Utility allPackNames];
    }
    else {
        
        NSArray *defaultPacks = [Utility defaultUnlockedPacks];
        NSArray *unlockedPacks = [[NSUserDefaults standardUserDefaults] arrayForKey:@"Unlocked Packs"];

        // If none exists
        if (packs == nil) {
            packs = [NSArray array];
        }
        
        NSMutableArray *combined = [NSMutableArray arrayWithArray:defaultPacks];
        [combined addObjectsFromArray:unlockedPacks];
        packs = combined;
    }
    
    return packs;
}

+ (void) unlockPack:(PackType)packType
{
    NSMutableArray *packs = [NSMutableArray arrayWithArray:[self loadUnlockedPacks]];
    
    [packs addObject:[NSNumber numberWithInteger:packType]];
    [[NSUserDefaults standardUserDefaults] setObject:packs forKey:@"Unlocked Packs"]; 
}

+ (void) unlockAllPacks
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"All Packs"];
}

@end
