//
//  Button.h
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "ButtonDelegate.h"

@interface Button : CCNode <CCTargetedTouchDelegate> {
    
    /** Whether or not the button can be toggled */
    BOOL isToggleButton_;
    
    /** Whether or not the button was pressed */
    BOOL isSelected_;
    
    /** Whether or not it is active */
    BOOL isClickable_;    
    
    /** 
     * If this is set during a touch, the button is essentially "reset",
     * and the finger must be lifted before the button can function again
     */
    BOOL isInvalidated_;
    
    /** Delegate object */
    id <ButtonDelegate> delegate_;    
    
    NSUInteger numID_;    
    
}

@property (nonatomic, readonly) NSUInteger numID;
@property (nonatomic, assign) id <ButtonDelegate> delegate;
@property (nonatomic, assign) BOOL isClickable;
@property (nonatomic, readonly) BOOL isSelected;

+ (id) button:(NSUInteger)numID toggle:(BOOL)toggle;

- (id) initButton:(NSUInteger)numID toggle:(BOOL)toggle;

- (void) invalidateTouch;

- (CGRect) rect;

- (void) selectButton;

- (void) unselectButton;

@end


@interface ImageButton : Button {

    /** Button image */
    CCSprite *sprite_;
    
    /** Button selected image */
    CCSprite *selected_;
    
}

+ (id) imageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected;

+ (id) imageToggleButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected;

- (id) initImageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected toggle:(BOOL)toggle;

@end


@interface TextButton : Button {

    /** Button text */
    CCLabelTTF *text_;
    
}

+ (id) textButton:(NSUInteger)numID text:(NSString *)text;

+ (id) textToggleButton:(NSUInteger)numID text:(NSString *)text;

- (id) initTextButton:(NSUInteger)numID text:(NSString *)text toggle:(BOOL)toggle;

@end

@interface ScaledImageButton : Button {
    
    CCSprite *sprite_;
    
}

+ (id) scaledImageButton:(NSUInteger)numID image:(NSString *)image;

- (id) initScaledImageButton:(NSUInteger)numID image:(NSString *)image;

@end