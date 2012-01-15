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

@interface Key : CCNode <CCTargetedTouchDelegate> {
 
    CCSprite *sprite_;
    
    CCSprite *selected_;
    
    CCSprite *disabled_;
    
    KeyType keyType_;
    
    id <KeyDelegate> delegate_;
    
    BOOL isClickable_;    
    
}

@property (nonatomic, assign) id <KeyDelegate> delegate;
@property (nonatomic, readonly) KeyType keyType;

+ (id) key:(KeyType)keyType creature:(CreatureType)creature;

- (id) initKey:(KeyType)keyType creature:(CreatureType)creature;

- (void) selectButton;

- (void) unselectButton;

- (void) disableButton;

@end
