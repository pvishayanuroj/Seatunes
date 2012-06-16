//
//  IAPDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 6/12/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol IAPDelegate <NSObject>

@optional

- (void) showLoading;

- (void) finishLoading;

@required

- (void) purchaseComplete;

@end

