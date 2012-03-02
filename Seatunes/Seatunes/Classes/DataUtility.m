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

@synthesize allPackNames = allPackNames_;

// For singleton
static DataUtility *manager_ = nil;

#pragma mark - Object Lifecycle

+ (DataUtility *) manager
{
    @synchronized (self) {
        if (manager_ == nil) {
            // Alloc eventually calls allocWithZone
            [[self alloc] init];
        }
    }
    return manager_;
}

// Override allocWithZone to avoid potential page thrashing
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (manager_ == nil) {
            manager_ = [super allocWithZone:zone];
            return manager_;
        }
    }
    return nil;
}

+ (void) purge
{
    [manager_ release];
    manager_ = nil;
}

- (id) init
{
    if ((self = [super init])) {
        
        scores_ = nil;
        allPackNames_ = nil;
        packNames_ = nil;
        packIdentifiers_ = nil;
        defaultPacks_ = nil;
        
        [self loadPackInfo];
    }
    return self;
}

- (void) dealloc
{
    [scores_ release];
    [allPackNames_ release];
    [packNames_ release];
    [packIdentifiers_ release];
    [defaultPacks_ release];
    
    [super dealloc];
}

#pragma mark - Score Methods

- (NSMutableDictionary *) loadSongScores
{
    NSDictionary *loadedScores = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"Song Scores"];
        
    if (loadedScores == nil) {
        scores_ = [NSMutableDictionary dictionary];
    }
    else {
        scores_ = [NSMutableDictionary dictionaryWithDictionary:loadedScores];
    }
    
    [scores_ retain];
    
    return scores_;
}

- (void) saveSongScore:(NSString *)songName score:(ScoreType)score
{
    if (scores_ == nil) {
        [self loadSongScores];
    }
    
    NSNumber *savedScore = [scores_ objectForKey:songName];
    
    // Only save score if it is greater than saved score or if saved score doesn't exist
    if (savedScore != nil) {
        if (score < [savedScore integerValue]) {
            return;
        }
    }
    
    [scores_ setObject:[NSNumber numberWithInteger:score] forKey:songName];
    [[NSUserDefaults standardUserDefaults] setObject:scores_ forKey:@"Song Scores"];        
}

- (void) resetSongScores
{
    [scores_ release];
    scores_ = [[NSMutableDictionary dictionary] retain];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Song Scores"];
}

#pragma mark - Pack Methods

- (void) loadPackInfo
{
    // Load default packs
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Default Packs" ofType:@"plist"];
    defaultPacks_ = [[NSArray arrayWithContentsOfFile:path] retain];       
    
    // Load product identifiers
	path = [[NSBundle mainBundle] pathForResource:@"Product Identifiers" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:path];
    
    NSMutableDictionary *packNames = [NSMutableDictionary dictionary];
    NSMutableDictionary *packIdentifiers = [NSMutableDictionary dictionary];    
    NSMutableArray *orderedPackNames = [NSMutableArray array];
    
    for (NSDictionary *packInfo in data) {
        NSString *productName = [packInfo objectForKey:@"Product Name"];
        NSString *productIdentifier = [packInfo objectForKey:@"Product Identifier"];
        
        if (productName != nil && productIdentifier != nil) {
            [packNames setObject:productIdentifier forKey:productName];
            [packIdentifiers setObject:productName forKey:productIdentifier];
            [orderedPackNames addObject:productName];
        }
    }
    
    packNames_ = [packNames retain];
    packIdentifiers_ = [packIdentifiers retain];
    
    // Load all pack names
    // Start with default packs
    NSMutableArray *allPacks = [NSMutableArray arrayWithArray:defaultPacks_];
    
    // Then add each product pack, as long as it isn't already contained in the defaults pack
    // Also, do not include the "All Packs" product as a pack
    for (NSString *packName in orderedPackNames) {
        if (![allPacks containsObject:packName] && ![packName isEqualToString:kAllPacks]) {
            [allPacks addObject:packName];
        }
    }
    
    allPackNames_ = [allPacks retain];
}

- (NSArray *) allProductNames
{
    return [packNames_ allKeys];
}

- (NSArray *) allProductIdentifiers
{
    return [packIdentifiers_ allKeys];
}

- (NSString *) productIdentifierFromName:(NSString *)name
{
    NSString *productIdentifier = [packNames_ objectForKey:name];
    
    if (productIdentifier != nil) {
        return productIdentifier;
    }
    
    NSLog(@"Invalid product name: %@", name);
    return nil;
}

- (NSString *) nameFromProductIdentifier:(NSString *)productIdentifier
{
    NSString *name = [packIdentifiers_ objectForKey:productIdentifier];
    
    if (name != nil) {
        return name;
    }
    
    NSLog(@"Invalid product identifier: %@", productIdentifier);
    return nil;
}

- (NSArray *) loadSongNames:(NSString *)packName
{
	NSString *path = [[NSBundle mainBundle] pathForResource:packName ofType:@"plist"];
    NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSArray *songs = [NSArray arrayWithArray:[data objectForKey:@"Songs"]];
    
    return songs;
}

- (BOOL) isDefaultPack:(NSString *)packName
{
    return [defaultPacks_ containsObject:packName];
}

@end
