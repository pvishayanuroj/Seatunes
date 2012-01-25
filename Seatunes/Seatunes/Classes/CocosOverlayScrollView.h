//
//  CocosOverlayScrollView.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CocosOverlayScrollView : UIScrollView <UIScrollViewDelegate> {
    
    CCNode *node_;
    
    CGPoint originalPos_;
    
    BOOL firstScroll_;
}

@property (nonatomic, retain) CCNode *node;

+ (id) cocosOverlayScrollView;

- (id) initCocosOverlayScrollView;

@end
