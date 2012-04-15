//
//  KeyboardLetter.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/14/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "KeyboardLetter.h"


@implementation KeyboardLetter

+ (id) keyboardLetter:(NSString *)letter
{
    return [[[self alloc] initKeyboardLetter:letter] autorelease];
}

- (id) initKeyboardLetter:(NSString *)letter
{
    if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithFile:@"Letter Parchment.png"] retain];
        label_ = [[CCLabelBMFont labelWithString:letter fntFile:@"Dialogue Font.fnt"] retain];
        
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
