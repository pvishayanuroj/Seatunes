//
//  Badge.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Badge : CCNode {
    
    CCSprite *sprite_;
    
    CCParticleSystem *particles_;
    
}

+ (id) badge:(DifficultyType)difficultyType;

- (id) initBadge:(DifficultyType)difficultyType;

- (CCParticleSystem *) createPS;

@end
