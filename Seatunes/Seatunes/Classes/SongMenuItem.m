//
//  SongMenuItem.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SongMenuItem.h"


@implementation SongMenuItem

+ (id) songMenuItem:(NSString *)songName
{
    return [[[self alloc] initSongMenuItem:songName] autorelease];
}

- (id) initSongMenuItem:(NSString *)songName
{
    if ((self = [super init])) {
        
        NSString *fontName = @"Arial";
        CGFloat fontSize = 12;
        CCLabelTTF *label = [CCLabelTTF labelWithString:songName fontName:fontName fontSize:fontSize];
        [self addChild:label];
        
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
