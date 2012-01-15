//
//  GameScene.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene

- (id) init
{
    if ((self = [super init])) {
        
        GameLayer *gameLayer = [GameLayer start];
        [self addChild:gameLayer z:0];    
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
