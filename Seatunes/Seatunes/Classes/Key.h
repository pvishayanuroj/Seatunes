//
//  Key.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KeyDelegate.h"

@interface Key : CCNode {
 
    CCSprite *sprite_;
    
    CCSprite *selected_;
    
    CCSprite *disabled_;
    
    KeyType keyType_;
    
    GLuint soundID_;
    
    id <KeyDelegate> delegate_;
    
    BOOL isClickable_;   
    
    BOOL isSelected_;
    
}

@property (nonatomic, assign) id <KeyDelegate> delegate;
@property (nonatomic, readonly) KeyType keyType;
@property (nonatomic, readonly) GLuint soundID;
@property (nonatomic, readonly) BOOL isSelected;

+ (id) key:(KeyType)keyType creature:(CreatureType)creature;

- (id) initKey:(KeyType)keyType creature:(CreatureType)creature;

- (BOOL) containsTouchLocation:(UITouch *)touch;

- (void) selectButton;

- (void) unselectButton;

- (void) disableButton;

- (void) selectButtonTimed:(CGFloat)time;

@end
