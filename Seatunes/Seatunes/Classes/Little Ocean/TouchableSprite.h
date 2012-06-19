//
//  TouchableSprite.h
//  Little Ocean
//
//  Created by Jamorn Horathai on 1/23/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TouchableSprite : CCSprite <CCTargetedTouchDelegate> {
    
    BOOL isEnabled_;
    NSInteger touchPriority_;
    BOOL swallowsTouches_;
    
}

@property (nonatomic) BOOL isEnabled;

- (id) initWithFile:(NSString *)filename touchPriority:(NSInteger)touchPriority swallowsTouches:(BOOL)swallowsTouches;

- (BOOL) containsTouchLocation:(UITouch *)touch;

@end