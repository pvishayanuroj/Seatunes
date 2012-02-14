//
//  GameLogicC.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLogicC : CCNode {
    
    BOOL isFirstPlay_;    
    
}

+ (id) gameLogicC:(NSString *)songName;

- (id) initGameLogicC:(NSString *)songName;

@end
