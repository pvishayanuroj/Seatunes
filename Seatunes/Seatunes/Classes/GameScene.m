//
//  GameScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "MenuLayer.h"

@implementation GameScene

- (id) init
{
    if ((self = [super init])) {
        
        [self animationLoader:@"sheet01_animations" spriteSheetName:@"sheet01"];
        
        GameLayer *gameLayer = [GameLayer start];
        
        //[self addChild:gameLayer z:0];    
        
        // 60, 320 = -60, 320
        // 200, 100 = 20, 100
        // 320 - (a + b)
        CGRect menuFrame = CGRectMake(0, 0, 200, 320);
        //CGRect menuFrame = CGRectMake(0, 100, 200, 200);
        CGFloat scrollSize = 1000;
        MenuLayer *menuLayer = [MenuLayer menuLayer:menuFrame scrollSize:scrollSize];
        menuLayer.position = ccp(0, 0);
        [self addChild:menuLayer z:0];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

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
	CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:path];
    [self addChild:spriteSheet];
	
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
