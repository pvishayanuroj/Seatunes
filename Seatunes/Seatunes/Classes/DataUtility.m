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
        
        [self animationLoader:@"sheet01_animations" spriteSheetName:@"sheet01"];        
        [self loadPackInfo];
        [self loadTrainingSongs];
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
    [trainingSongs_ release];
    [spriteSheet_ release];
    
    [super dealloc];
}

#pragma mark - Score Methods

- (NSMutableDictionary *) loadSongScores
{
    [scores_ release];
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

- (void) saveSongScore:(NSString *)songName difficulty:(DifficultyType)difficulty
{
    if (scores_ == nil) {
        [self loadSongScores];
    }
    
    NSString *difficultyName = [Utility difficultyFromEnum:difficulty];
    NSString *key = [NSString stringWithFormat:@"%@ %@", songName, difficultyName];
    NSNumber *songScore = [scores_ objectForKey:key];
    
    // If song hasn't been stored yet, set it as a key
    if (songScore == nil) {
        [scores_ setObject:[NSNumber numberWithBool:YES] forKey:key];
        [[NSUserDefaults standardUserDefaults] setObject:scores_ forKey:@"Song Scores"];          
    }      
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

- (void) loadTrainingSongs
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Training Songs" ofType:@"plist"];
    trainingSongs_ = [[NSSet setWithArray:[NSArray arrayWithContentsOfFile:path]] retain];
}

- (BOOL) isDefaultPack:(NSString *)packName
{
    return [defaultPacks_ containsObject:packName];
}

- (BOOL) isTrainingSong:(NSString *)songName
{
    return [trainingSongs_ containsObject:songName];
}

- (BOOL) isFirstPlay
{
    return ![[NSUserDefaults standardUserDefaults] boolForKey:kFirstPlay];
}

- (BOOL) isFirstPlayForDifficulty:(DifficultyType)difficulty
{
    NSString *key = [Utility difficultyPlayedKeyFromEnum:difficulty];
    return ![[NSUserDefaults standardUserDefaults] boolForKey:key];   
}
         
#pragma mark - Animations

- (void) animationLoader:(NSString *)unitListName spriteSheetName:(NSString *)spriteSheetName
{
	NSArray *unitAnimations;
	NSString *unitName;
	NSString *animationName;
	NSUInteger numFr;
	CGFloat delay;
	NSMutableArray *frames;
	CCAnimation *animation;
	
	// Load from the Units.plist file
	NSString *path = [[NSBundle mainBundle] pathForResource:unitListName ofType:@"plist"];
	NSArray *unit_array = [NSArray arrayWithContentsOfFile:path];	
	
	// Load the frames from the spritesheet into the shared cache
	CCSpriteFrameCache *cache = [CCSpriteFrameCache sharedSpriteFrameCache];
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"plist"];
	[cache addSpriteFramesWithFile:path];
	
	// Load the spritesheet and add it to the game scene
	path = [[NSBundle mainBundle] pathForResource:spriteSheetName ofType:@"png"];
    spriteSheet_ = [[CCSpriteBatchNode batchNodeWithFile:path] retain];
	
	// Go through all units in the plist (dictionary objects)
	for (id obj in unit_array) {
		
		unitName = [obj objectForKey:@"Name"]; 
		
		// Retrieve the array holding information for each animation
		unitAnimations = [NSArray arrayWithArray:[obj objectForKey:@"Animations"]];		
		
		// Go through all the different animations for this unit (different dictionaries)
		for (id unitAnimation in unitAnimations) {
			
			// Parse the animation specific information 
			animationName = [unitAnimation objectForKey:@"Name"];		
			animationName = [NSString stringWithFormat:@"%@ %@", unitName, animationName];
			numFr = [[unitAnimation objectForKey:@"Num Frames"] intValue];
			delay = [[unitAnimation objectForKey:@"Animate Delay"] floatValue];
			
			frames = [NSMutableArray arrayWithCapacity:6];
			
			// Store each frame in the array
			for (int i = 0; i < numFr; i++) {
				
				// Formulate the frame name based off the unit's name and the animation's name and add each frame
				// to the animation array
				NSString *frameName = [NSString stringWithFormat:@"%@ %02d.png", animationName, i+1];
				CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
				[frames addObject:frame];
			}
			
			// Create the animation object from the frames we just processed
			animation = [CCAnimation animationWithFrames:frames delay:delay];
			
#if DEBUG_SHOWLOADEDANIMATIONS
			NSLog(@"Loaded animation: %@", animationName);
#endif
			// Store the animation
			[[CCAnimationCache sharedAnimationCache] addAnimation:animation name:animationName];
			
		} // end for-loop of animations
	} // end for-loop of units
}

@end
