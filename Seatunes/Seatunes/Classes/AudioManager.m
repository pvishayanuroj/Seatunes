//
//  AudioManager.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "AudioManager.h"
#import "SimpleAudioEngine.h"
#import "Utility.h"

// For singleton
static AudioManager *_audioManager = nil;

@implementation AudioManager

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
        
        SimpleAudioEngine *sae = [SimpleAudioEngine sharedEngine];
        
        NSArray *keyNames = [Utility allKeyNames];
        NSArray *instrumentNames = [Utility allInstrumentNames];
        
        for (NSNumber *key in keyNames) {
            NSString *keyName = [Utility keyNameFromEnum:[key integerValue]];
            for (NSNumber *instrument in instrumentNames) {
                NSString *instrumentName = [Utility instructorNameFromEnum:[instrument integerValue]];
                NSString *fileName = [NSString stringWithFormat:@"%@-%@.m4a", keyName, instrumentName];
                [sae preloadEffect:fileName];
            }
        }     
        backgroundMusicPlaying_ = NO;
	}
	return self;
}

- (void) dealloc
{	
    [engineSound_ release];
    
	[super dealloc];
}

#pragma mark - Sound Methods

- (GLuint) playSound:(KeyType)key instrument:(InstrumentType)instrument
{
    NSString *keyName = [Utility keyNameFromEnum:key];
    NSString *instrumentName = [Utility instrumentNameFromEnum:instrument];
    NSString *name = [NSString stringWithFormat:@"%@-%@.m4a", keyName, instrumentName];
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];  
    currentEffect_ = [engine playEffect:name];
    return currentEffect_;
}

- (void) playSoundEffect:(SoundType)type
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    NSString *name = [Utility soundFileFromEnum:type];
    [engine playEffect:name];
}

- (GLuint) playSoundEffectFile:(NSString *)filename
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    return [engine playEffect:filename];
}

- (void) stopSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    [engine stopEffect:currentEffect_];
}

- (void) stopSound:(GLuint)effectNumber
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];    
    [engine stopEffect:effectNumber];
}

- (void) stopMusic
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void) pauseSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];

    [engine pauseBackgroundMusic];
}

- (void) resumeSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];    
    
    if (backgroundMusicPlaying_) {
        [engine resumeBackgroundMusic];
    }
}

@end
