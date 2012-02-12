//
//  GameLogicC.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/4/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "GameLogicC.h"


@implementation GameLogicC

+ (id) gameLogicC:(NSString *)songName
{
    return [[[self alloc] initGameLogicC:songName] autorelease];
}

- (id) initGameLogicC:(NSString *)songName
{
    if ((self = [super init])) {

    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

@end
