//
//  CocosOverlayViewController.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class CocosOverlayScrollView;

@interface CocosOverlayViewController : UIViewController {
 
    CocosOverlayScrollView *scrollView_;
    
    CCNode *node_;
    
    CGSize contentSize_;
    
    CGRect frame_;

}

@property (nonatomic, readonly) CocosOverlayScrollView *scrollView;

+ (id) cocosOverlayViewController:(CCNode *)node contentSize:(CGSize)contentSize frame:(CGRect)frame;

- (id) init:(CCNode *)node contentSize:(CGSize)contentSize frame:(CGRect)frame;

- (void) setClickable:(BOOL)clickable;

@end
