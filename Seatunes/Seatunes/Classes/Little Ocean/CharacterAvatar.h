//
//  CharacterAvatar.h
//  Little Ocean
//
//  Created by Jamorn Horathai on 3/22/12.
//  Copyright 2012 Prototype Zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TouchableSprite.h"
#import "AudioManager.h"
#import "CharacterAvatarDelegate.h"

@interface CharacterAvatar : TouchableSprite {
    
    CCSprite *tank_;
    
    CCSprite *feet_;
    
    CCSprite *armLeft_;
    
    CCSprite *armRight_;
    
    CCSprite *body_;
    
    CCSprite *eyes_;
    
    CCSprite *faceMask_;
    
    CCSprite *pipe_;
    
    CCSprite *regulator_;
    
    CCSprite *head_;
    
    CCAction *talkWobbleAction_;
    
    CCAction *eyeBlinkAction_;
    
    id <CharacterAvatarDelegate> delegate_;
    
}

+ (id) characterAvatarWithTarget:(id<CharacterAvatarDelegate>)target;

- (id) initWithTarget:(id<CharacterAvatarDelegate>)target;

- (void) startTalking;
- (void) stopTalking;

- (void) startIdleAnimation;
- (void) startArmWavingAnimation;

@end
