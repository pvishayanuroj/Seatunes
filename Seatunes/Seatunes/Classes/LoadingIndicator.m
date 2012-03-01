//
//  LoadingIndicator.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "LoadingIndicator.h"


@implementation LoadingIndicator

static const CGFloat LI_BOX_Y = -15.0f;
static const CGFloat LI_TEXT_Y = -40.0f;

+ (id) loadingIndicator
{
    return [[[self alloc] initLoadingIndicator:@"Loading"] autorelease];
}

+ (id) loadingIndicator:(NSString *)text
{
    return [[[self alloc] initLoadingIndicator:text] autorelease];
}

- (id) initLoadingIndicator:(NSString *)text
{
    if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        CGPoint midpoint = ccp(size.width / 2, size.height / 2);
        self.position = midpoint;
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"Loading Indicator Background.png"];
        sprite.position = ccp(0, LI_BOX_Y);
        [self addChild:sprite];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:text fontName:@"Helvetica" fontSize:14.0f];
        label.position = ccp(0, LI_TEXT_Y);
        [self addChild:label];
        
        activityIndicator_ = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] retain];
        activityIndicator_.center = midpoint;
        [[[CCDirector sharedDirector] openGLView] addSubview:activityIndicator_];    
        
        [activityIndicator_ startAnimating];        
        
    }
    return self;
}

- (void) remove
{
    [activityIndicator_ removeFromSuperview];
    [activityIndicator_ release];
    activityIndicator_ = nil;
    
    [self removeFromParentAndCleanup:YES];
}

- (void) dealloc
{
    [super dealloc];
}

@end
