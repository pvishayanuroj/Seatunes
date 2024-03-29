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
#import "KeyboardLetter.h"
#import "Utility.h"
#import "CCNode+PauseResume.h"
#import "ModEaseBackIn.h"

@implementation Keyboard

static const CGFloat KB_KEY_PADDING = 115.0f;
static const CGFloat KB_KEY_PADDING_M = 58.0f;
static const CGFloat KB_LETTER_MOVE_OUT_TIME = 1.5f;
static const CGFloat KB_LETTER_MOVE_IN_TIME = 0.75f;
static const CGFloat KB_LETTER_X = 1200.0f;
static const CGFloat KB_LETTER_Y = 90.0f;
static const CGFloat KB_LETTER_X_M = 562.5f;
static const CGFloat KB_LETTER_Y_M = 37.5f;

@synthesize isHelpMoving = isHelpMoving_;
@synthesize isKeyboardMuted = isKeyboardMuted_;
@synthesize isClickable = isClickable_;
@synthesize delegate = delegate_;

+ (id) keyboard:(KeyboardType)keyboardType
{
    return [[[self alloc] initKeyboard:keyboardType] autorelease];
}

- (id) initKeyboard:(KeyboardType)keyboardType
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        instrumentType_ = kPiano;
        CreatureType creature = kClam;
        isKeyboardMuted_ = NO;
        isClickable_ = YES;
        isMuted_ = NO;
        
        keys_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];    
        keyTimer_ = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
        touches_ = CFDictionaryCreateMutable(kCFAllocatorDefault, 24, nil, nil);
        sequence_ = nil;
        letters_ = nil;
        
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
    [keyTimer_ release];
    CFRelease(touches_);
    [sequence_ release];
    [letters_ release];
    
    [super dealloc];
}

- (void) placeEightKeys:(CreatureType)creature
{
    NSArray *keys = [Utility allKeyNames];

    NSInteger i = 0;
    for (NSNumber *keyName in keys) {
        KeyType keyType = [keyName integerValue];
        Key *key = [Key key:keyType creature:creature];    
        key.delegate = self;
        key.position = CHOOSE_REL_CCP(ccp(i * KB_KEY_PADDING, 0), ccp(i * KB_KEY_PADDING_M, 0));

        [self addChild:key];
        [keys_ setObject:key forKey:keyName];
        i++;
    }  
}

- (GLuint) keyPressed:(Key *)key
{
    double currentTime = CACurrentMediaTime();
    
    NSNumber *keyType = [NSNumber numberWithInteger:key.keyType];
    NSNumber *timestamp = [NSNumber numberWithDouble:currentTime];
    [keyTimer_ setObject:timestamp forKey:keyType];
    
    GLuint idNumber;
    if (!isKeyboardMuted_ && !isMuted_) {
        idNumber = [[AudioManager audioManager] playSound:key.keyType instrument:instrumentType_];
    }
    
    if ([delegate_ respondsToSelector:@selector(keyboardKeyPressed:)]) {
        [delegate_ keyboardKeyPressed:key.keyType];
    }
    
    return idNumber;
}

- (void) keyDepressed:(Key *)key
{
    double currentTime = CACurrentMediaTime();
    
    NSNumber *keyType = [NSNumber numberWithInteger:key.keyType];
    NSNumber *timestamp = [keyTimer_ objectForKey:keyType];
    
    double delta = currentTime - [timestamp doubleValue];

    [keyTimer_ removeObjectForKey:keyType];
    
    if (!isKeyboardMuted_) {
        if (!isMuted_) {
            [[AudioManager audioManager] stopSound:key.soundID];
        }
        else {
            isMuted_ = NO;
        }
    }
    
    if ([delegate_ respondsToSelector:@selector(keyboardKeyDepressed:time:)]) {
        [delegate_ keyboardKeyDepressed:key.keyType time:(CGFloat)delta];
    }
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
                if (isClickable_ && [key containsTouchLocation:touch]) {
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

- (void) playNote:(KeyType)keyType time:(CGFloat)time withSound:(BOOL)withSound
{
    isMuted_ = !withSound;
    
    NSNumber *keyName = [NSNumber numberWithInteger:keyType];
    Key *key = [keys_ objectForKey:keyName];
    if (key) {
        [key selectButtonTimed:time];
    }
}

- (void) applause
{
    //isKeyboardMuted_ = YES;
    [self schedule:@selector(applauseLoop) interval:0.05f];
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:5.0f];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(applauseComplete)];
    
    [self runAction:[CCSequence actions:delay, done, nil]];
}

- (void) applauseLoop
{
    // Choose random key
    NSInteger keyNumber = arc4random() % [keys_ count];
    Key *key = [keys_ objectForKey:[NSNumber numberWithInteger:keyNumber]];    
    
    if (key && !key.isSelected) {
        [key selectButtonTimed:0.25f];
    }
}

- (void) applauseComplete
{
    [self unschedule:@selector(applauseLoop)];
    
    if (delegate_ && [delegate_ respondsToSelector:@selector(applauseComplete)]) {
        [delegate_ applauseComplete];
    }
}

- (void) showLetters
{
    // If letters haven't been generated yet, create them
    if (letters_ == nil) {
        letters_ = [[NSMutableArray arrayWithCapacity:8] retain];
        NSArray *strings = [NSArray arrayWithObjects:@"C", @"D", @"E", @"F", @"G", @"A", @"B", @"C", nil];
        
        NSInteger count = 0;
        for (NSString *str in strings) {
            KeyboardLetter *letter = [KeyboardLetter keyboardLetter:str];
            letter.position = CHOOSE_REL_CCP(ccp(KB_LETTER_X + KB_KEY_PADDING * count, KB_LETTER_Y), ccp(KB_LETTER_X_M + KB_KEY_PADDING_M * count, KB_LETTER_Y_M));
            [letters_ addObject:letter];
            [self addChild:letter];
            count++;
        }
    }
    
    // Move each letter to assigned positions
    isHelpMoving_ = YES;
    NSInteger count = 0;
    NSMutableArray *actions = [NSMutableArray arrayWithCapacity:20];
    for (KeyboardLetter *keyboardLetter in letters_) {
        CGPoint pos = CHOOSE_REL_CCP(ccp(count * KB_KEY_PADDING, KB_LETTER_Y), ccp(count * KB_KEY_PADDING_M, KB_LETTER_Y_M));
        
        CCActionInstant *letterMove = [CCCallBlock actionWithBlock:^{
            [[AudioManager audioManager] playSoundEffect:kSwoosh3];
            CCActionInterval *move = [CCMoveTo actionWithDuration:KB_LETTER_MOVE_OUT_TIME position:pos];       
            CCActionInterval *ease = [CCEaseElasticOut actionWithAction:move period:0.8f];
            [keyboardLetter runAction:ease];
        }];
        CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1f];        
        
        [actions addObject:letterMove];
        [actions addObject:delay];
        count++;
    }

    // Let delegate know when move is complete
    CCActionInterval *delay = [CCDelayTime actionWithDuration:KB_LETTER_MOVE_OUT_TIME];
    CCActionInstant *done = [CCCallBlock actionWithBlock:^{
        isHelpMoving_ = NO;
        if (delegate_ && [delegate_ respondsToSelector:@selector(showLettersComplete)]) {
            [delegate_ showLettersComplete];
        }
    }];
    
    [actions addObject:delay];
    [actions addObject:done];
    
    [self runAction:[CCSequence actionsWithArray:actions]];
}

- (void) hideLetters
{
    if (letters_) {
        
        // Move each letter to assigned positions
        isHelpMoving_ = YES;        
        NSInteger count = 0;
        NSMutableArray *actions = [NSMutableArray arrayWithCapacity:30];        
        for (KeyboardLetter *keyboardLetter in [letters_ reverseObjectEnumerator]) {
            CGPoint pos = CHOOSE_REL_CCP(ccp(KB_LETTER_X + KB_KEY_PADDING * count, KB_LETTER_Y), ccp(KB_LETTER_X_M + KB_KEY_PADDING_M * count, KB_LETTER_Y_M));
            
            CCActionInstant *letterMove = [CCCallBlock actionWithBlock:^{             
                CCActionInterval *move = [CCMoveTo actionWithDuration:KB_LETTER_MOVE_IN_TIME position:pos];       
                CCActionInterval *ease = [ModEaseBackIn actionWithAction:move];                
                [keyboardLetter runAction:ease];
            }];
            CCActionInterval *delay = [CCDelayTime actionWithDuration:0.15f];      
            CCActionInstant *sound = [CCCallBlock actionWithBlock:^{
                [[AudioManager audioManager] playSoundEffect:kSwoosh2];   
            }];
            
            [actions addObject:letterMove];
            [actions addObject:delay];
            [actions addObject:sound];
            count++;            
        }
        
        // Let delegate know when move is complete
        CCActionInterval *delay = [CCDelayTime actionWithDuration:KB_LETTER_MOVE_IN_TIME];
        CCActionInstant *done = [CCCallBlock actionWithBlock:^{
            isHelpMoving_ = NO;
            if (delegate_ && [delegate_ respondsToSelector:@selector(hideLettersComplete)]) {
                [delegate_ hideLettersComplete];
            }
        }];
        
        [actions addObject:delay];
        [actions addObject:done];
        
        [self runAction:[CCSequence actionsWithArray:actions]];        
    }
}

- (void) pauseHierarchy
{
    prevClickableState_ = isClickable_;
    isClickable_ = NO;
    
    [super pauseHierarchy];
}

- (void) resumeHierarchy
{
    isClickable_ = prevClickableState_;
    
    [super resumeHierarchy];
}


@end
