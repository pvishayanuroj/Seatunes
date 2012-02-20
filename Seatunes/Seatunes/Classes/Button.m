//
//  Button.m
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Button.h"

@implementation Button

@synthesize numID = numID_;
@synthesize delegate = delegate_;
@synthesize isClickable = isClickable_;
@synthesize isSelected = isSelected_;

#pragma mark - Object Lifecycle

+ (id) button:(NSUInteger)numID toggle:(BOOL)toggle
{
    return [[[self alloc] initButton:numID toggle:toggle] autorelease];
}

- (id) initButton:(NSUInteger)numID toggle:(BOOL)toggle
{
    if ((self = [super init])) {
        
        delegate_ = nil;        
        numID_ = numID;
        isSelected_ = NO;
        isClickable_ = YES;
        isToggleButton_ = toggle; 

    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Touch Handlers

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
    NSAssert(NO, @"Rect method must be implemented for child class");
    return CGRectMake(0, 0, 0, 0);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (isClickable_) {    
        if ([self containsTouchLocation:touch]) {
            // If not a toggle button, show the selection right away
            // Otherwise wait for end touch to select for toggle buttons
            if (!isToggleButton_) {
                [self selectButton];
            }
            isInvalidated_ = NO;
            return YES;
        }
    }
    return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isInvalidated_) {
        if ([self containsTouchLocation:touch])	{
            // Non-toggle buttons get unselected
            // Toggle buttons become selected
            if (!isToggleButton_) {
                [self selectButton];
            }
        }
        else {
            if (!isToggleButton_) {
                [self unselectButton];
            }        
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isInvalidated_) {
        if ([self containsTouchLocation:touch])	{
            // Non-toggle buttons get unselected
            // Toggle buttons become selected
            if (!isToggleButton_) {
                [self unselectButton];
            }
            else {
                [self selectButton];
            }
            
            if ([delegate_ respondsToSelector:@selector(buttonClicked:)]) {
                [delegate_ buttonClicked:self];
            }
        }
        else {
            [self unselectButton];
        }
    }
}

#pragma mark - Object Manipulators

- (void) invalidateTouch
{
    isInvalidated_ = YES;
}

- (void) selectButton
{
    isSelected_ = YES;
    
    if ([delegate_ respondsToSelector:@selector(buttonSelected:)]) {
        [delegate_ buttonSelected:self];
    }
}

- (void) unselectButton
{
    isSelected_ = NO;
    
    if ([delegate_ respondsToSelector:@selector(buttonUnselected:)]) {
        [delegate_ buttonUnselected:self];        
    }
}

@end


@implementation ImageButton

#pragma mark - Object Lifecycle

+ (id) imageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected
{
    return [[[self alloc] initImageButton:numID unselectedImage:unselected selectedImage:selected toggle:NO] autorelease];
}

+ (id) imageToggleButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected
{
    return [[[self alloc] initImageButton:numID unselectedImage:unselected selectedImage:selected toggle:YES] autorelease];    
}

- (id) initImageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected toggle:(BOOL)toggle
{
    if ((self = [super initButton:numID toggle:toggle])) {
        
        sprite_ = [[CCSprite spriteWithFile:unselected] retain];
        selected_ = [[CCSprite spriteWithFile:selected] retain];        
        
        sprite_.visible = !isSelected_;
        selected_.visible = isSelected_;        
        
        [self addChild:sprite_];
        [self addChild:selected_];        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [selected_ release];
    
    [super dealloc];
}

- (void) selectButton
{
    sprite_.visible = !isSelected_;
    selected_.visible = isSelected_;        
    
    [super selectButton];
}

- (void) unselectButton
{
    sprite_.visible = !isSelected_;
    selected_.visible = isSelected_;     
    
    [super unselectButton];    
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

@end


@implementation TextButton

#pragma mark - Object Lifecycle

+ (id) textButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initTextButton:numID text:text toggle:NO] autorelease];
}

+ (id) textToggleButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initTextButton:numID text:text toggle:YES] autorelease];
}

- (id) initTextButton:(NSUInteger)numID text:(NSString *)text toggle:(BOOL)toggle
{
    if ((self = [super initButton:numID toggle:toggle])) {
        
        text_ = [[CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize:32] retain];    
        [self addChild:text_];
    }
    return self;
}

- (void) dealloc
{
    [text_ release];
    
    [super dealloc];
}

- (void) selectButton
{
    text_.color = ccc3(255, 255, 255);
    
    [super selectButton];
}

- (void) unselectButton
{
    text_.color = ccc3(140, 140, 140); 
    
    [super unselectButton];        
}

- (CGRect) rect
{
	CGRect r = text_.textureRect;    
	return CGRectMake(text_.position.x - r.size.width / 2, text_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

@end

@implementation ScaledImageButton

static const CGFloat SIB_SCALE_FACTOR = 1.1f;

+ (id) scaledImageButton:(NSUInteger)numID image:(NSString *)image
{
    return [[[self alloc] initScaledImageButton:numID image:image scale:1.0f] autorelease];
}

+ (id) scaledImageButton:(NSUInteger)numID image:(NSString *)image scale:(CGFloat)scale
{
    return [[[self alloc] initScaledImageButton:numID image:image scale:scale] autorelease];
}

- (id) initScaledImageButton:(NSUInteger)numID image:(NSString *)image scale:(CGFloat)scale
{
    if ((self = [super initButton:numID toggle:NO])) {
        
        origScale_ = scale;
        sprite_ = [[CCSprite spriteWithFile:image] retain];        
        sprite_.scale = scale;
        [self addChild:sprite_];        
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

- (void) selectButton
{ 
    sprite_.scale = origScale_ * SIB_SCALE_FACTOR;    
    
    [super selectButton];
}

- (void) unselectButton
{
    sprite_.scale = origScale_;
    
    [super unselectButton];    
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

- (void) setImage:(NSString *)image
{
    [sprite_ removeFromParentAndCleanup:YES];
    [sprite_ release];
    
    sprite_ = [[CCSprite spriteWithFile:image] retain];
    [self addChild:sprite_];
    sprite_.scale = origScale_;
}


@end
