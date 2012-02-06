//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"


@implementation SongMenuItem

+ (id) songMenuItem:(NSString *)songName songIndex:(NSUInteger)songIndex
{
    return [[[self alloc] initSongMenuItem:songName songIndex:songIndex] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName songIndex:(NSUInteger)songIndex
{
    if ((self = [super initScrollingMenuItem:songIndex height:55])) {
        
        NSString *fontName = @"Arial";
        CGFloat fontSize = 28;
        CCLabelTTF *label = [CCLabelTTF labelWithString:songName fontName:fontName fontSize:fontSize];
        label.anchorPoint = ccp(0, 0.5f);
        label.position = ccp(100.0f, 0);
        [self addChild:label];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
