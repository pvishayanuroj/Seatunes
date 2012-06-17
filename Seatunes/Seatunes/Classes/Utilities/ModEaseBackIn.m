//
//  ModEaseBackIn.m
//  Seatunes
//
//  Created by Paul Vishayanuroj on 4/28/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import "ModEaseBackIn.h"


@implementation ModEaseBackIn

-(void) update: (ccTime) t
{
    ccTime overshoot = 0.8f;
    [other update: t * t * ((overshoot + 1) * t - overshoot)];
}

- (CCActionInterval*) reverse
{
	return [CCEaseBackOut actionWithAction: [other reverse]];
}

@end

