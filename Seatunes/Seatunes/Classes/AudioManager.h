//
//  AudioManager.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "AudioManagerDelegate.h"
#import "CDAudioManager.h"

@class CDAudioManager;
@class SimpleAudioEngine;

@interface AudioManager : NSObject <CDLongAudioSourceDelegate> {
    
    /* For background music and narration */
    CDAudioManager *manager_;
    
    /* For sound effects */
    SimpleAudioEngine *sae_;
    
    /* Delegate object */
    id <AudioManagerDelegate> delegate_;
    
    /* Current speech type playing on CDAudioManager */
    SpeechType currentSpeech_;
    
    /* Current effect number */
    GLuint currentEffect_;
    
    /* State variable for pause */
    BOOL backgroundMusicWasPlaying_;
    
    /* State variable for pause */    
    BOOL narrationWasPlaying_;
}

@property (nonatomic, assign) id <AudioManagerDelegate> delegate;

+ (AudioManager *) audioManager;

+ (void) purgeAudioManager;

- (void) preloadEffects;

- (GLuint) playSound:(KeyType)key instrument:(InstrumentType)instrument;

- (GLuint) playSoundEffect:(SoundType)type;

- (GLuint) playSoundEffectFile:(NSString *)filename;

- (void) stopSound:(GLuint)effectNumber;

- (void) stopSound;

- (void) playNarration:(SpeechType)speechType path:(NSString *)path delegate:(id <AudioManagerDelegate>)delegate;

- (void) stopNarration;

- (void) preloadBackgroundMusic:(NSString *)path;

- (void) playBackgroundMusic:(NSString *)path;

- (void) stopBackgroundMusic;

- (void) pause;

- (void) resume;

@end
