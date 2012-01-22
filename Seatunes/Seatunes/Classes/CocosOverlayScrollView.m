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

-(void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
    {
        UITouch* touch = [[touches allObjects] objectAtIndex:0];
        CGPoint location = [touch locationInView: [touch view]];
        
        [self.nextResponder touchesBegan: touches withEvent:event];
        [[[CCDirector sharedDirector] openGLView] touchesBegan:touches withEvent:event];
    }
    
    [super touchesBegan: touches withEvent: event];
}

-(void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event
{
    if (!self.dragging)
    {
        [self.nextResponder touchesEnded: touches withEvent:event];
        [[[CCDirector sharedDirector] openGLView] touchesEnded:touches withEvent:event];
    }
    
    [super touchesEnded: touches withEvent: event];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    // TODO - Custom code for handling deceleration of the scroll view
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"scrollview did scroll");
    CGPoint dragPt = [scrollView contentOffset];
    
    CCScene* currentScene = [[CCDirector sharedDirector] runningScene];
    
    // Only take the top layer to modify but other layers could be retrieved as well
    //
    CCLayer* topLayer = (CCLayer *)[currentScene.children objectAtIndex:1];
    
    //dragPt = [[CCDirector sharedDirector] convertCoordinate:dragPt];
//    dragPt = [[CCDirector sharedDirector] convertToGL:dragPt];
    dragPt = [[CCDirector sharedDirector] convertToUI:dragPt];
    
    dragPt.y = dragPt.y * -1;
    dragPt.x = dragPt.x * -1;
    
    CGPoint newLayerPosition = CGPointMake(dragPt.x + (scrollView.contentSize.height * 0.5f), dragPt.y + (scrollView.contentSize.width * 0.5f));
    
    //NSLog(@"%4.2f, %4.2f", newLayerPosition.x, newLayerPosition.y);
    //[topLayer setPosition:newLayerPosition];
    topLayer.position = newLayerPosition;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    CGPoint dragPt = [scrollView contentOffset];
    
}
@end