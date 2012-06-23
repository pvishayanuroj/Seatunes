//
//  StarfishButton.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/20/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Button.h"
#import "ButtonDelegate.h"

@interface StarfishButton : Button {

    CCSprite *sprite_;
    
    CCLabelBMFont *label_;
    
    BOOL isSpinning_;
    
}

+ (id) starfishButton:(NSUInteger)numID text:(NSString *)text;

+ (id) starfishButtonUnselected:(NSUInteger)numID text:(NSString *)text;

+ (id) starfishButtonBlue:(NSUInteger)numID text:(NSString *)text;

- (id) initStarfishButton:(NSUInteger)numID text:(NSString *)text image:(NSString *)image fnt:(NSString *)fnt textScale:(CGFloat)textScale;

- (void) startSpin;

@end
