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
#import "IAPDelegate.h"

enum {
    kSSBack,
    kSSResetTutorials,
    kSSResetScores,
    kSSRestore
};

@class Slider;
@class LoadingIndicator;
@class Button;

@interface SettingsScene : CCScene <ButtonDelegate, SliderDelegate, IAPDelegate, UIAlertViewDelegate> {
    
    Slider *slider_;
    
    CCLabelBMFont *slowLabel_;
    
    CCLabelBMFont *normalLabel_;

    CCLabelBMFont *fastLabel_;
    
    LoadingIndicator *loadingIndicator_;      
    
    Button *backButton_;
    
    Button *resetButton_;
    
    Button *restoreButton_;
}

@end
