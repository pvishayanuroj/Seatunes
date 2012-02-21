//
//  PackMenuItem.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ScrollingMenuItem.h"

@interface PackMenuItem : ScrollingMenuItem {
    
    CCSprite *sprite_;
    
}

+ (id) packenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked;

- (id) initPackMenuItem:(NSString *)packName packIndex:(NSUInteger)packIndex isLocked:(BOOL)isLocked;

@end
