//
//  Note.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Note : CCNode {
    
    CCSprite *sprite_;
    
    
    
}

+ (id) note:(KeyType)keyType;

- (id) initNote:(KeyType)keyType;

- (void) floatAction;

- (void) blowAction;

@end
