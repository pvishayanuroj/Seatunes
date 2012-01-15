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
        [sae preloadEffect:@"C4-Piano.m4a"];
        [sae preloadEffect:@"D4-Piano.m4a"];
        [sae preloadEffect:@"E4-Piano.m4a"];
        [sae preloadEffect:@"F4-Piano.m4a"];
        [sae preloadEffect:@"G4-Piano.m4a"];
        [sae preloadEffect:@"A4-Piano.m4a"];
        [sae preloadEffect:@"B4-Piano.m4a"];
        [sae preloadEffect:@"C5-Piano.m4a"];        
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

- (void) playSound:(KeyType)key instrument:(InstrumentType)instrument
{
    NSString *keyName = [Utility keyNameFromEnum:key];
    NSString *instrumentName = [Utility instrumentNameFromEnum:instrument];
    NSString *name = [NSString stringWithFormat:@"%@-%@.m4a", keyName, instrumentName];
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    currentEffect_ = [engine playEffect:name];
}

- (void) playSound:(SoundType)type
{
    /*
    NSString *name;
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    
    switch (type) {   
        default:
            NSAssert(NO, @"Invalid effect type");
            break;
    }
     */

}

- (void) stopSound
{
    SimpleAudioEngine *engine = [SimpleAudioEngine sharedEngine];
    [engine stopEffect:currentEffect_];
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
