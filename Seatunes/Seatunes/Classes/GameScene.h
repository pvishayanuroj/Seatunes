//
//  GameScene.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCScene {
    
}

+ (id) startWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex;

- (id) initWithDifficulty:(DifficultyType)difficulty songName:(NSString *)songName packIndex:(NSUInteger)packIndex;

@end
