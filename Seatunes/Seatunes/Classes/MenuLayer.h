//
//  MenuLayer.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CocosOverlayViewController;

@interface MenuLayer : CCLayer {
 
    CocosOverlayViewController *viewController_;
 
    CGRect menuFrame_;
    
}

+ (id) menuLayer:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

- (id) initMenuLayer:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize;

@end
