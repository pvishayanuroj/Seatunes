//
//  AudioManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AudioManager.h"
#import "CDAudioManager.h"
#import "SimpleAudioEngine.h"
#import "CocosDenshion.h"
#import "Utility.h"

// For singleton
static AudioManager *_audioManager = nil;

@implementation AudioManager

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (AudioManager *) audioManager
{
	if (!_audioManager)
		_audioManager = [[self alloc] init];
	
	return _audioManager;
}

+ (id) alloc
{
	NSAssert(_audioManager == nil, @"Attempted to allocate a second instance of a Audio Manager singleton.");
	return [super alloc];
}

+ (void) purgeAudioManager
{
	[_audioManager release];
	_audioManager = nil;
}

- (id) init
{
	if ((self = [super init])) {

        delegate_ = nil;        
        manager_ = [[CDAudioManager sharedManager] retain];
        sae_ = [[SimpleAudioEngine sharedEngine] retain];
        
        [self preloadEffects];
        [self preloadMusic];
	}
	return self;
}

- (void) dealloc
{	
    [manager_ release];
    [sae_ release];
    
	[super dealloc];
}

#pragma mark - Delegate Methods

- (void) cdAudioSourceDidFinishPlaying:(CDLongAudioSource *)audioSource
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(narrationComplete:)]) {
        [delegate_ narrationComplete:currentSpeech_];
    }
}

#pragma mark - Initialization Methods

- (void) preloadEffects
{   
    NSArray *keyNames = [Utility allKeyNames];
    NSArray *instrumentNames = [Utility allInstrumentNames];
    
    for (NSNumber *key in keyNames) {
        NSString *keyName = [Utility keyNameFromEnum:[key integerValue]];
        for (NSNumber *instrument in instrumentNames) {
            NSString *instrumentName = [Utility instructorNameFromEnum:[instrument integerValue]];
            NSString *path = [NSString stringWithFormat:@"%@-%@.m4a", keyName, instrumentName];
            [sae_ preloadEffect:path];
        }
    }       
    
    NSArray *soundEffects = [Utility allSoundEffects];
    
    for (NSNumber *effect in soundEffects) {
        NSString *path = [Utility soundFileFromEnum:[effect integerValue]];
        [sae_ preloadEffect:path];
    }
}

- (void) preloadMusic
{
    NSArray *musicNames = [Utility allMusic];
    
    for (NSNumber *music in musicNames) {
        [self preloadBackgroundMusic:[music integerValue]];
    }
}

#pragma mark - Sound Effect Methods

- (GLuint) playSound:(KeyType)key instrument:(InstrumentType)instrument
{
    NSString *keyName = [Utility keyNameFromEnum:key];
    NSString *instrumentName = [Utility instrumentNameFromEnum:instrument];
    NSString *name = [NSString stringWithFormat:@"%@-%@.m4a", keyName, instrumentName];  
    currentEffect_ = [sae_ playEffect:name];
    return currentEffect_;
}

- (GLuint) playSoundEffect:(SoundType)type
{
    NSString *name = [Utility soundFileFromEnum:type];
    currentEffect_ = [sae_ playEffect:name];
    return currentEffect_;
}

- (GLuint) playSoundEffectFile:(NSString *)filename
{
    currentEffect_ = [sae_ playEffect:filename];
    return currentEffect_;
}

- (void) stopSound
{
    [sae_ stopEffect:currentEffect_];
}

- (void) stopSound:(GLuint)effectNumber
{
    [sae_ stopEffect:effectNumber];
}

#pragma mark - Narration Methods

- (void) playNarration:(SpeechType)speechType path:(NSString *)path delegate:(id <AudioManagerDelegate>)delegate;
{
    CDLongAudioSource *narration = [manager_ audioSourceLoad:path channel:kASC_Right];
    
    if ([narration isPlaying]) {
        [narration stop];
    }    
    
    self.delegate = delegate;
    currentSpeech_ = speechType;
    narration.delegate = self;
    [narration play];
}

- (void) stopNarration
{
    CDLongAudioSource *narration = [manager_ audioSourceForChannel:kASC_Right];
    if ([narration isPlaying]) {
        [narration stop];
    }
}

#pragma mark - Background Music Methods

- (void) preloadBackgroundMusic:(MusicType)musicType
{
    NSString *path = [Utility musicFileFromEnum:musicType];
    [sae_ preloadBackgroundMusic:path];
}

- (void) playBackgroundMusic:(MusicType)musicType
{
    if (![sae_ isBackgroundMusicPlaying]) {
        NSString *path = [Utility musicFileFromEnum:musicType];
        [sae_ playBackgroundMusic:path];
    }
}

- (void) pauseBackgroundMusic
{
    [sae_ pauseBackgroundMusic];
}

- (void) resumeBackgroundMusic
{
    [sae_ resumeBackgroundMusic];
}

- (void) stopBackgroundMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (BOOL) isBackgroundMusicPlaying
{
    return [sae_ isBackgroundMusicPlaying];
}

- (void) pause
{
    // Pause narration
    CDLongAudioSource *narration = [manager_ audioSourceForChannel:kASC_Right];
 
    narrationWasPlaying_ = [narration isPlaying];
    if (narrationWasPlaying_) {
        [narration pause];
    }
    
    // Pause background music
    backgroundMusicWasPlaying_ = [sae_ isBackgroundMusicPlaying];
    if (backgroundMusicWasPlaying_) {
        [sae_ stopBackgroundMusic];
    }
    
    // Stop all sound effects
    [manager_.soundEngine stopAllSounds];
}

- (void) resume
{
    // Resume background music
    if (backgroundMusicWasPlaying_) {
        [sae_ resumeBackgroundMusic];
    }
    
    // Resume narration
    CDLongAudioSource *narration = [manager_ audioSourceForChannel:kASC_Right];    
    if (narrationWasPlaying_) {
        [narration resume];
    }
}

@end
