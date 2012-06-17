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
    
    CCLabelBMFont *label_;
    
}

+ (id) songMenuItem:(NSString *)songName scores:(NSDictionary *)scores songIndex:(NSUInteger)songIndex hasScore:(BOOL)hasScore locked:(BOOL)locked;

- (id) initSongMenuItem:(NSString *)songName scores:(NSDictionary *)scores songIndex:(NSUInteger)songIndex hasScore:(BOOL)hasScore locked:(BOOL)locked;

@end
