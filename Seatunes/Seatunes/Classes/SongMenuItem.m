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
    if ((self = [super initScrollingMenuItem:songIndex height:50])) {
        
        NSString *fontName = @"Arial";
        CGFloat fontSize = 16;
        CCLabelTTF *label = [CCLabelTTF labelWithString:songName fontName:fontName fontSize:fontSize];
        label.position = ccp(100, 0);
        [self addChild:label];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
