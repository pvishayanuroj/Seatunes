//
//  Slider.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/21/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "Slider.h"

@implementation Slider

@synthesize delegate = delegate_;

+ (id) slider:(CGPoint)position width:(CGFloat)width
{
    return [[[self alloc] initSlider:position width:width] autorelease];
}

- (id) initSlider:(CGPoint)position width:(CGFloat)width
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        slider_ = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, width, 10)] retain];
        [[[CCDirector sharedDirector] openGLView] addSubview:slider_];   
        
        if (IS_IPAD()) {
            slider_.center = ccp(position.x, IPAD_SCREEN_HEIGHT - position.y);
        }
        else {
            slider_.center = ccp(position.x, IPHONE_SCREEN_HEIGHT - position.y);
        }
        
        [slider_ addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [slider_ addTarget:self action:@selector(doneSliding:) forControlEvents:UIControlEventTouchUpInside];
        [slider_ addTarget:self action:@selector(doneSliding:) forControlEvents:UIControlEventTouchUpOutside];        
    }
    return self;
}

- (void) remove
{
    [slider_ removeFromSuperview];
    [slider_ release];
    slider_ = nil;
    
    [self removeFromParentAndCleanup:YES];
}

- (void) dealloc
{
    [super dealloc];
}

- (void) setSlider:(CGFloat)value
{
    [slider_ setValue:value animated:YES];
}

- (void) setSliderNoAnimation:(CGFloat)value
{
    [slider_ setValue:value animated:NO];
}

- (void) sliderAction:(UISlider *)slider 
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(sliderUpdated:)]) {
        [delegate_ sliderUpdated:[slider value]];
    }
}

- (void) doneSliding:(UISlider *)slider
{
    if (delegate_ && [delegate_ respondsToSelector:@selector(doneSliding:)]) {
        [delegate_ doneSliding:[slider value]];
    }    
}

@end
