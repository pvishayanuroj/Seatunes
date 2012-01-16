//
//  Keyboard.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Keyboard.h"
#import "AudioManager.h"
#import "Key.h"

@implementation Keyboard

@synthesize delegate = delegate_;

+ (id) keyboard:(KeyboardType)keyboardType
{
    return [[[self alloc] initKeyboard:keyboardType] autorelease];
}

- (id) initKeyboard:(KeyboardType)keyboardType
{
    if ((self = [super init])) {
        
        instrumentType_ = kPiano;
        CreatureType creature = kSeaAnemone;
        isClickable_ = YES;
        
        keys_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];     
        touches_ = CFDictionaryCreateMutable(kCFAllocatorDefault, 24, nil, nil);
        sequence_ = nil;
        previousKey_ = nil;
        
        switch (keyboardType) {
            case kEightKey:
                [self placeEightKeys:creature];        
                break;
            default:
                break;
        }
        
    }
    return self;
}

- (void) dealloc
{
    [keys_ release];
    CFRelease(touches_);
    [sequence_ release];
    
    [super dealloc];
}

- (void) placeEightKeys:(CreatureType)creature
{
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:8];
    [keys addObject:[NSNumber numberWithInteger:kC4]];
    [keys addObject:[NSNumber numberWithInteger:kD4]];
    [keys addObject:[NSNumber numberWithInteger:kE4]];
    [keys addObject:[NSNumber numberWithInteger:kF4]];
    [keys addObject:[NSNumber numberWithInteger:kG4]];
    [keys addObject:[NSNumber numberWithInteger:kA4]];
    [keys addObject:[NSNumber numberWithInteger:kB4]];
    [keys addObject:[NSNumber numberWithInteger:kC5]];    

    NSInteger i = 0;
    for (NSNumber *keyName in keys) {
        KeyType keyType = [keyName integerValue];
        Key *key = [Key key:keyType creature:creature];    
        key.delegate = self;
        key.position = ccp(i * 80, 0);
        [self addChild:key];
        [keys_ setObject:key forKey:keyName];
        i++;
    }  
}

- (void) keyPressed:(Key *)key
{
    [[AudioManager audioManager] playSound:key.keyType instrument:instrumentType_];
}

- (void) keyDepressed:(Key *)key
{
    [[AudioManager audioManager] stopSound];
}

- (void) touchesBegan:(NSSet *)touches
{
    if (!isClickable_) {
        return;
    }
    
    // For all touches received
    for (UITouch *touch in touches) {
        // Check if any key was pressed
        for (Key *key in [keys_ allValues]) {
            // If key was pressed, associate it with this touch and activate it
            if ([key containsTouchLocation:touch]) {
                // When storing the value, add 1 so that null is never stored
                CFDictionarySetValue(touches_, touch, key);
                [key selectButton];
                break;
            }
        }
    }
}

- (void) touchesMoved:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        const void *value = CFDictionaryGetValue(touches_, touch);
        
        // If this touch was on a key, check if it moved off of it
        if (value != nil) {
            Key *key = (Key *)value;
            
            // If touch has moved off the key, remove it from the dictionary
            if (![key containsTouchLocation:touch]) {
                CFDictionaryRemoveValue(touches_, touch);
                [key unselectButton];
            }
        }
        // Touch is moving in between keys, check if it got onto another key
        else {            
            for (Key *key in [keys_ allValues]) {
                if ([key containsTouchLocation:touch]) {
                    CFDictionarySetValue(touches_, touch, key);
                    [key selectButton];
                    break;
                }
            }            
        }
    }    
}

- (void) touchesEnded:(NSSet *)touches
{
    for (UITouch *touch in touches) {
        const void *value = CFDictionaryGetValue(touches_, touch);
        
        // If touch was on a key, signal the key that it ended
        if (value != nil) {
            Key *key = (Key *)value;
            [key unselectButton];
            CFDictionaryRemoveValue(touches_, touch);
        }
    }
}

- (void) playSequence:(NSArray *)sequence
{
    [self schedule:@selector(playNote) interval:0.5f];
    
    sequence_ = [sequence retain];
    currentIndex_ = 0;
}

- (void) playNote
{
    // Depress previously played key
    if (notePlayed_) {
        [self depressNote];
        return;
    }
    
    // If notes still remaining
    if (currentIndex_ < [sequence_ count]) {
        // Play the next key        
        NSNumber *keyName = [sequence_ objectAtIndex:currentIndex_++];
        Key *key = [keys_ objectForKey:keyName];
        // If an actual note is to be played (as opposed to a blank)
        if (key) {
            [key selectButton];
            previousKey_ = [key retain];
        }
        notePlayed_ = YES;
    }
    // Otherwise end of sequence, stop calling this function
    else {
        [self unschedule:@selector(playNote)];
        [sequence_ release];
        sequence_ = nil;
    }
}

- (void) depressNote
{
    // Only if an actual note was played last cycle
    if (previousKey_) {
        [previousKey_ unselectButton];
        [previousKey_ release];    
        previousKey_ = nil;
    }
    notePlayed_ = NO;
}

@end
