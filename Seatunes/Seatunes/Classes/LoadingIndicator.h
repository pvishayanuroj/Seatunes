//
//  LoadingIndicator.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/29/12.
//  Copyright 2012 Paul Vishayanuroj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingIndicator : CCNode {
    
    UIActivityIndicatorView *activityIndicator_;   
}

+ (id) loadingIndicator;

+ (id) loadingIndicator:(NSString *)text;

- (id) initLoadingIndicator:(NSString *)text;

- (void) remove;

@end
