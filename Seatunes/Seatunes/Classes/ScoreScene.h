//
//  ScoreScene.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 4/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreScene : CCScene {
    
}

+ (id) scoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

- (id) initScoreScene:(ScoreInfo)scoreInfo songName:(NSString *)songName nextSong:(NSString *)nextSong;

@end
