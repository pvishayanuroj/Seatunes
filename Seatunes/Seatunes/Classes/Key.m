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
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ %@ Key.png", creatureName, keyName];
        NSString *selectedName = [NSString stringWithFormat:@"%@ %@ Key Selected.png", creatureName, keyName];
        
        sprite_ = [[CCSprite spriteWithFile:spriteName] retain];
        selected_ = [[CCSprite spriteWithFile:selectedName] retain];
        //disabled_ = [[CCSprite spriteWithFile:disabledName] retain];     
        
        sprite_.scale = 0.5f;
        selected_.scale = 0.5f;        
        
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

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
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

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (isClickable_) {    
        if ([self containsTouchLocation:touch]) {
            [self selectButton];
            return YES;
        }
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (![self containsTouchLocation:touch]) {
        [self unselectButton];
    }    
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if ([self containsTouchLocation:touch])	{
        [self unselectButton];
    }
}

- (void) selectButton
{
    sprite_.visible = NO;
    selected_.visible = YES;
    
    [delegate_ keyPressed:self];    
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