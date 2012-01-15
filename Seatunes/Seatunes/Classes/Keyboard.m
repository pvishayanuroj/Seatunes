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
    [super dealloc];
}

- (void) placeEightKeys:(CreatureType)creature
{
    Key *k1 = [Key key:kC4 creature:creature];
    Key *k2 = [Key key:kD4 creature:creature];
    Key *k3 = [Key key:kE4 creature:creature];
    Key *k4 = [Key key:kF4 creature:creature];
    Key *k5 = [Key key:kG4 creature:creature];
    Key *k6 = [Key key:kA4 creature:creature];
    Key *k7 = [Key key:kB4 creature:creature];
    Key *k8 = [Key key:kC5 creature:creature];
    
    k1.delegate = self;
    k2.delegate = self;
    k3.delegate = self;
    k4.delegate = self;
    k5.delegate = self;
    k6.delegate = self;
    k7.delegate = self;
    k8.delegate = self;
    
    k1.position = ccp(0, 0);
    k2.position = ccp(80, 0);
    k3.position = ccp(160, 0);
    k4.position = ccp(240, 0);    
    k5.position = ccp(320, 0);    
    k6.position = ccp(400, 0);    
    k7.position = ccp(480, 0);    
    k8.position = ccp(560, 0);        
    
    [self addChild:k1];
    [self addChild:k2];
    [self addChild:k3];
    [self addChild:k4];
    [self addChild:k5];
    [self addChild:k6];
    [self addChild:k7];
    [self addChild:k8];    
}

- (void) keyPressed:(Key *)key
{
    [[AudioManager audioManager] playSound:key.keyType instrument:instrumentType_];
}

- (void) keyDepressed:(Key *)key
{
    [[AudioManager audioManager] stopSound];
}

@end
