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
 
    NSMutableDictionary *scores_;
    
    NSArray *allPackNames_;
    
    /* Maps pack names to pack identifiers */
    NSDictionary *packNames_;
    
    /* Maps pack identifiers to pack names */
    NSDictionary *packIdentifiers_;
    
    NSArray *defaultPacks_;
}

@property (nonatomic, readonly) NSArray *allPackNames;

+ (DataUtility *) manager;

+ (void) purge;

- (NSMutableDictionary *) loadSongScores;

- (void) saveSongScore:(NSString *)songName score:(ScoreType)score;

- (void) resetSongScores;

- (void) loadPackInfo;

- (NSArray *) allProductNames;

- (NSArray *) allProductIdentifiers;

- (NSString *) productIdentifierFromName:(NSString *)name;

- (NSString *) nameFromProductIdentifier:(NSString *)productIdentifier;

- (NSArray *) loadSongNames:(NSString *)packName;

- (BOOL) isDefaultPack:(NSString *)packName;

@end
