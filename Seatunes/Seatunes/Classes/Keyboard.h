//
//  Keyboard.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "KeyDelegate.h"
#import "KeyboardDelegate.h"

@class Key;

@interface Keyboard : CCNode <KeyDelegate> {
 
    InstrumentType instrumentType_;
    
    NSMutableDictionary *keys_;
    
    CFMutableDictionaryRef touches_;
    
    NSArray *sequence_;
    
    NSUInteger currentIndex_;
    
    Key *previousKey_;
    
    BOOL notePlayed_;
    
    BOOL isClickable_;
    
    id <KeyboardDelegate> delegate_;
    
}

@property (nonatomic, assign) id <KeyboardDelegate> delegate;

+ (id) keyboard:(KeyboardType)keyboardType;

- (id) initKeyboard:(KeyboardType)keyboardType;

- (void) placeEightKeys:(CreatureType)creature;

- (void) touchesBegan:(NSSet *)touches;

- (void) touchesMoved:(NSSet *)touches;

- (void) touchesEnded:(NSSet *)touches;

- (void) playSequence:(NSArray *)sequence;

- (void) depressNote;

@end
