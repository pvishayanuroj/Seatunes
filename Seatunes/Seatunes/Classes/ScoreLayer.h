//
//  ScoreLayer.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/19/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "ScoreLayerDelegate.h"

@interface ScoreLayer : CCLayer <ButtonDelegate> {
    
    id <ScoreLayerDelegate> delegate_;
    
}

@property (nonatomic, assign) id <ScoreLayerDelegate> delegate;

+ (id) scoreLayer:(ScoreInfo)scoreInfo;

- (id) initScoreLayer:(ScoreInfo)scoreInfo;

@end
