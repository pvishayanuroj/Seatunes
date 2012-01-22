//
//  MenuLayer.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/22/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "MenuLayer.h"
#import "SWTableView.h"
#import "SWTableViewCell.h"
#import "CocosOverlayViewController.h"

@interface MyCell : SWTableViewCell 
{
    
}
@end

@implementation MyCell

- (id)init
{
    if(! (self = [super init]) )
        return nil;
    
    NSLog(@"nothing to see here");
    
    return self;
}

@end

@implementation MenuLayer

+ (id) menuLayer
{
    return [[[self alloc] init] autorelease];
}

- (id) init
{
    if ((self = [super init])) {
        
        self.isTouchEnabled = YES;
        
        CocosOverlayViewController *c = [CocosOverlayViewController alloc];
        [[[CCDirector sharedDirector] openGLView] addSubview:c.view];
        
        for ( int i = 0 ; i < 6; i++) {
        CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"Bubble C4.png"];
        sprite.position = ccp(100, i * 40);
        [self addChild:sprite];
        }
        
        /*
        CGSize size = CGSizeMake(100, 200);
        
        table_ = [[SWTableView viewWithDataSource:self size:size] retain];
        table_.delegate = self;
        table_.direction = SWScrollViewDirectionVertical;
        [self addChild:table_];     
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        table_.position = ccp(s.width * 0.1f, s.height * 0.2f);
        
        [table_ reloadData];    
        */
    }
    return self;
}

- (void) dealloc
{
    //[table_ release];
    
    [super dealloc];
}

/*
- (void) table:(SWTableView *)table cellTouched:(SWTableViewCell *)cell
{
    NSLog(@"cell touched at index: %i", cell.idx);    
}

- (CGSize) cellSizeForTable:(SWTableView *)table
{
   return CGSizeMake(100, 44);    
}

- (SWTableViewCell *) table:(SWTableView *)table cellAtIndex:(NSUInteger)idx
{
    SWTableViewCell *cell;
    NSString *spriteName;
    CCSprite *sprite;
    
    cell       = [table dequeueCell];
    spriteName = [NSString stringWithFormat:@"Bubble C4.png"];
    sprite     = [CCSprite spriteWithSpriteFrameName:spriteName];
    sprite.anchorPoint = CGPointZero;
    
    if (!cell) 
    {
        cell = [[MyCell new] autorelease];
    }
    else // remove the cell's previously added children
    {
        [cell.children removeAllObjects];
    }
    [cell addChild:sprite];
    
    NSLog(@"num kids = %d", [[cell children] count]);
    
    return cell;    
}

- (NSUInteger) numberOfCellsInTableView:(SWTableView *)table 
{
    return 38;
}
 */

@end
