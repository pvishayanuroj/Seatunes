//
//  SongMenuItem.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingMenuItem.h"

@interface SongMenuItem : ScrollingMenuItem {
    
    
    
}

+ (id) songMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex;

- (id) initSongMenuItem:(NSString *)songName songScore:(ScoreType)songScore songIndex:(NSUInteger)songIndex;

@end
