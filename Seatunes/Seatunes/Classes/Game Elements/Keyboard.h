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
    
    NSMutableDictionary *keyTimer_;
    
    CFMutableDictionaryRef touches_;
    
    NSArray *sequence_;
    
    NSMutableArray *letters_;
    
    NSUInteger currentIndex_;
    
    BOOL isKeyboardMuted_;
    
    BOOL notePlayed_;
    
    BOOL isClickable_;
    
    BOOL prevClickableState_;
    
    BOOL isMuted_;
    
    BOOL isHelpMoving_;
    
    id <KeyboardDelegate> delegate_;
    
}

@property (nonatomic, assign) BOOL isKeyboardMuted;
@property (nonatomic, assign) BOOL isClickable;
@property (nonatomic, readonly) BOOL isHelpMoving;
@property (nonatomic, assign) id <KeyboardDelegate> delegate;

+ (id) keyboard:(KeyboardType)keyboardType;

- (id) initKeyboard:(KeyboardType)keyboardType;

- (void) placeEightKeys:(CreatureType)creature;

- (void) touchesBegan:(NSSet *)touches;

- (void) touchesMoved:(NSSet *)touches;

- (void) touchesEnded:(NSSet *)touches;

- (void) playNote:(KeyType)keyType time:(CGFloat)time withSound:(BOOL)withSound;

- (void) applause;

- (void) showLetters;

- (void) hideLetters;

@end
