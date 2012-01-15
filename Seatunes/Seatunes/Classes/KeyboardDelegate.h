//
//  KeyboardDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/15/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol KeyboardDelegate <NSObject>

- (void) keyboardKeyPressed:(KeyType)keyType;

@end
