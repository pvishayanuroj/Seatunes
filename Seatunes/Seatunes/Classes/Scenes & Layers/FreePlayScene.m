//
//  FreePlayScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 3/24/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "FreePlayScene.h"
#import "FreePlayLayer.h"
#import "AudioManager.h"
#import "Apsalar.h"

@implementation FreePlayScene

- (id) init
{
    if ((self = [super init])) {
        
        FreePlayLayer *freePlayLayer = [FreePlayLayer node];
        [self addChild:freePlayLayer];    
        
        [[AudioManager audioManager] playSoundEffect:kPageFlip];    
        
#if ANALYTICS_ON
        [Apsalar event:@"Freeplay"];
#endif        
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
