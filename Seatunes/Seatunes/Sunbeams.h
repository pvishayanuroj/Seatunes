//
//  Sunbeams.h
//  Seatunes
//
//  Created by Patrick Vishayanuroj on 5/11/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Sunbeams : CCNode {
    
    NSMutableArray *sprites_;
    
    NSUInteger numbeams_;
}

+ (id) sunbeamsCycling:(NSUInteger)numbeams;

+ (id) sunbeamsStatic:(NSUInteger)numbeams;

- (id) initSunbeams:(NSUInteger)numbeams showAll:(BOOL)showAll;

- (void) scheduleCycle;

@end
