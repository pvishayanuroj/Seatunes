//
//  AppDelegate.h
//  Seatunes
//
//  Created by Paul Vishayanuroj on 1/14/12.
//  Copyright Paul Vishayanuroj 2012. All rights reserved.
//

#import "CommonHeaders.h"
#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
