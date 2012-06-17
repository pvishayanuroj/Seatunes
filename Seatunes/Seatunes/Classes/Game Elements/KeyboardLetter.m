//
//  KeyboardLetter.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/14/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "KeyboardLetter.h"


@implementation KeyboardLetter

const static CGFloat KL_PARCHMENT_SCALE = 0.8f;
const static CGFloat KL_LABEL_SCALE = 1.2f;

+ (id) keyboardLetter:(NSString *)letter
{
    return [[[self alloc] initKeyboardLetter:letter] autorelease];
}

- (id) initKeyboardLetter:(NSString *)letter
{
    if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:@"Letter Parchment.png"] retain];
        sprite_.scale = KL_PARCHMENT_SCALE;
        label_ = [[CCLabelBMFont labelWithString:letter fntFile:@"Dialogue Font.fnt"] retain];
        label_.scale = KL_LABEL_SCALE;
        
        [self addChild:sprite_];
        [self addChild:label_];
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [label_ release];
    
    [super dealloc];
}

@end
