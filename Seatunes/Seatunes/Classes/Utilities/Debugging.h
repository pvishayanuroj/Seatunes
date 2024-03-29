//
//  Debugging.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#define DEBUG_SHOWLOADEDANIMATIONS 0

#define DEBUG_SHOWDEALLOC 0

#define DEBUG_SHOWMAPCURVES 0

#define DEBUG_SHOWLIGHTBOUNDARY 0

#define DEBUG_SHOWTEXTBOUNDARY 0

#define DEBUG_IAP 1

#define IAP_ON 1

#define ANALYTICS_ON 1

#define DebugPoint(s, p) NSLog(@"%@: (%4.2f, %4.2f)", s, p.x, p.y)
#define DebugRect(s, r) NSLog(@"%@: (%4.2f, %4.2f, %4.2f, %4.2f)", s, r.origin.x, r.origin.y, r.size.width, r.size.height)