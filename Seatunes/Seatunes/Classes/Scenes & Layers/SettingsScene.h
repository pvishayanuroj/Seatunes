//
//  SettingsScene.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "SliderDelegate.h"

enum {
    kSSBack,
    kSSResetTutorials,
    kSSResetScores
};

@class Slider;

@interface SettingsScene : CCScene <ButtonDelegate, SliderDelegate, UIAlertViewDelegate> {
    
    Slider *slider_;
    
    CCLabelBMFont *slowLabel_;
    
    CCLabelBMFont *normalLabel_;

    CCLabelBMFont *fastLabel_;
}

@end
