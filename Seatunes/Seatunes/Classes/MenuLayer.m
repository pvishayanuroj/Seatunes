//
//  MenuLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MenuLayer.h"
#import "CocosOverlayViewController.h"
#import "MenuItem.h"

@implementation MenuLayer

+ (id) menuLayer:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize
{
    return [[[self alloc] initMenuLayer:menuFrame scrollSize:scrollSize] autorelease];
}

- (id) initMenuLayer:(CGRect)menuFrame scrollSize:(CGFloat)scrollSize
{
    if ((self = [super init])) {
        
        menuFrame_ = menuFrame;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CGFloat yOrigin = winSize.height - (menuFrame.origin.y + menuFrame.size.height);
        
        CGSize contentSize = CGSizeMake(menuFrame.size.width, scrollSize);
        CGRect frame = CGRectMake(menuFrame.origin.x, yOrigin, 
                                  menuFrame.size.width, menuFrame.size.height);        
        
        viewController_ = [[CocosOverlayViewController cocosOverlayViewController:self contentSize:contentSize frame:frame] retain];
        [[[CCDirector sharedDirector] openGLView] addSubview:viewController_.view];
        
        
        for ( int i = 0 ; i < 10; i++) {
            MenuItem *item = [MenuItem menuItem];
            item.position = ccp(100, i * 40);
            [self addChild:item];
            /*
            NSString *name;
            if (i % 2) {
                name = @"Bubble C4.png";
            }
            else {
                name = @"Bubble D4.png";
            }
            CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:name];
            sprite.position = ccp(100, i * 40);
            [self addChild:sprite];
             */
        }
    }
    return self;
}

- (void) dealloc
{
    [viewController_.view removeFromSuperview];
    [viewController_ release];
    
    [super dealloc];
}

- (void) visit
{
    glEnable(GL_SCISSOR_TEST);
    
    //glScissor(0, 60, 200, 220);
    glScissor(menuFrame_.origin.x, menuFrame_.origin.y, menuFrame_.size.width, menuFrame_.size.height);
    [super visit];
    
    glDisable(GL_SCISSOR_TEST);    
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touches began");
}


@end
