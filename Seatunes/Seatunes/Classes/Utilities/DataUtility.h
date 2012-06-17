//
//  DataUtility.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/12/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface DataUtility : NSObject {
 
    NSMutableDictionary *scores_;
    
    NSArray *allPackNames_;
    
    /* Maps pack names to pack identifiers */
    NSDictionary *packNames_;
    
    /* Maps pack identifiers to pack names */
    NSDictionary *packIdentifiers_;
    
    NSArray *defaultPacks_;
    
    /* Songs which have no scores kept */
    NSSet *trainingSongs_;
    
	CCSpriteBatchNode *spriteSheet_;    
    
    BOOL backgroundMusicOn_;    
}

@property (nonatomic, assign) BOOL backgroundMusicOn;
@property (nonatomic, readonly) NSArray *allPackNames;

+ (DataUtility *) manager;

+ (void) purge;

- (NSMutableDictionary *) loadSongScores;

- (void) saveSongScore:(NSString *)songName difficulty:(DifficultyType)difficulty;

- (void) resetSongScores;

- (void) loadPackInfo;

- (NSArray *) allProductNames;

- (NSArray *) allProductIdentifiers;

- (NSString *) productIdentifierFromName:(NSString *)name;

- (NSString *) nameFromProductIdentifier:(NSString *)productIdentifier;

- (NSArray *) loadSongNames:(NSString *)packName;

- (void) loadTrainingSongs;

- (BOOL) isDefaultPack:(NSString *)packName;

- (BOOL) isTrainingSong:(NSString *)songName;

- (BOOL) isFirstPlay;

- (BOOL) isFirstPlayForDifficulty:(DifficultyType)difficulty;

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName;

@end
