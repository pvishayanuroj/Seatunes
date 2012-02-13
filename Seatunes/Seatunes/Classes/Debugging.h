//
//  Debugging.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/16/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#define DEBUG_SHOWLOADEDANIMATIONS 1

#define DEBUG_SHOWDEALLOC 0

#define DEBUG_SHOWMAPCURVES 0

#define NT_CURVE1_C1_X 150  
#define NT_CURVE1_C1_Y 0
#define NT_CURVE1_C2_X 240
#define NT_CURVE1_C2_Y 100
#define NT_CURVE1_END_X 200
#define NT_CURVE1_END_Y 500

#define NT_CURVE2_C1_X 180  
#define NT_CURVE2_C1_Y 0
#define NT_CURVE2_C2_X 270
#define NT_CURVE2_C2_Y 100
#define NT_CURVE2_END_X 250
#define NT_CURVE2_END_Y 500

#define DebugPoint(s, p) NSLog(@"%@: (%4.2f, %4.2f)", s, p.x, p.y)
#define DebugRect(s, r) NSLog(@"%@: (%4.2f, %4.2f, %4.2f, %4.2f)", s, r.origin.x, r.origin.y, r.size.width, r.size.height)