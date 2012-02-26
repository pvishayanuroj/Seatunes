//
//  SeatunesIAPHelper.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface SeatunesIAPHelper : IAPHelper {
    
}

+ (SeatunesIAPHelper *) manager;

+ (void) purge;

- (BOOL) allPacksPurchased;

- (BOOL) packPurchased:(NSString *)packName;

- (BOOL) productPurchased:(NSString *)productIdentifier;

@end
