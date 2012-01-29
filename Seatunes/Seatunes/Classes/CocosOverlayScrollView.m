//
//  CocosOverlayScrollView.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CocosOverlayScrollView.h"
#import "cocos2d.h"

@implementation CocosOverlayScrollView

@synthesize node = node_;

+ (id) cocosOverlayScrollView
{
    return [[[self alloc] initCocosOverlayScrollView] autorelease];
}

- (id) initCocosOverlayScrollView
{
    if ((self = [self initWithFrame:[UIScreen mainScreen].applicationFrame])) {
     
        firstScroll_ = YES;
    
    }
    return self;
}

- (void) dealloc
{
    [node_ release];
    
    [super dealloc];
}

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging) {
        [[[CCDirector sharedDirector] openGLView] touchesBegan:touches withEvent:event];
    }
    
    [super touchesBegan: touches withEvent: event];
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging) {
        [[[CCDirector sharedDirector] openGLView] touchesEnded:touches withEvent:event];
    }
    
    [super touchesEnded: touches withEvent: event];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (firstScroll_) {
        originalPos_ = node_.position;
        firstScroll_ = NO;
    }
    CGPoint dragPt = [scrollView contentOffset];
    
    dragPt = [[CCDirector sharedDirector] convertToGL:dragPt];
    dragPt.y = dragPt.y * -1;

    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGFloat newY = dragPt.y + winSize.height + originalPos_.y;
    
    //NSLog(@"OrigY: %4.2f, Prev pt: %4.2f, new pt: %4.2f", originalPos_.y, node_.position.y, newY);
    node_.position = CGPointMake(node_.position.x, newY);
}

@end