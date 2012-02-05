//
//  Key.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Key.h"
#import "Utility.h"

@implementation Key

@synthesize delegate = delegate_;
@synthesize keyType = keyType_;
@synthesize soundID = soundID_;

+ (id) key:(KeyType)keyType creature:(CreatureType)creature
{
    return [[[self alloc] initKey:keyType creature:creature] autorelease];
}

- (id) initKey:(KeyType)keyType creature:(CreatureType)creature
{
    if ((self = [super init])) {
        
        keyType_ = keyType;
        isClickable_ = YES;
        
        NSString *keyName = [Utility keyNameFromEnum:keyType];
        NSString *creatureName = [Utility creatureNameFromEnum:creature];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ %@.png", creatureName, keyName];
        NSString *selectedName = [NSString stringWithFormat:@"%@ %@ Selected.png", creatureName, keyName];
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        selected_ = [[CCSprite spriteWithSpriteFrameName:selectedName] retain];
        //disabled_ = [[CCSprite spriteWithSpriteFrameName:disabledName] retain];     
        
        sprite_.visible = YES;
        selected_.visible = NO;
        
        [self addChild:sprite_];
        [self addChild:selected_];
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [selected_ release];
    //[disabled_ release];
    
    [super dealloc];
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - (r.size.width * sprite_.scaleX) / 2, sprite_.position.y - 
                      (r.size.height *sprite_.scaleY ) / 2, r.size.width * sprite_.scaleX, r.size.height * sprite_.scaleY);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (void) selectButton
{
    sprite_.visible = NO;
    selected_.visible = YES;
    
    soundID_ = [delegate_ keyPressed:self];    
}

- (void) unselectButton
{
    selected_.visible = NO;
    sprite_.visible = YES;
    
    [delegate_ keyDepressed:self];
}

- (void) disableButton
{
    
}

@end