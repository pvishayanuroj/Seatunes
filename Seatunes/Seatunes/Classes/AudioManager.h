//
//  AudioManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@class CDSoundSource;

@interface AudioManager : NSObject {
    
    CDSoundSource *engineSound_;    
    
    BOOL backgroundMusicPlaying_;
    
    GLuint currentEffect_;
}

+ (AudioManager *) audioManager;

+ (void) purgeAudioManager;

- (void) playSound:(KeyType)key instrument:(InstrumentType)instrument;

- (void) playSound:(SoundType)type;

- (void) stopSound;

- (void) stopMusic;

- (void) pauseSound;

- (void) resumeSound;

@end
