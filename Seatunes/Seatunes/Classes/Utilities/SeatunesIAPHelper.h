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
#import "IAPDelegate.h"

@interface SeatunesIAPHelper : IAPHelper <UIAlertViewDelegate> {
    
    /* Delegate object */
    id <IAPDelegate> delegate_;    
    
}

+ (SeatunesIAPHelper *) manager;

+ (void) purge;

- (BOOL) allPacksPurchased;

- (BOOL) packPurchased:(NSString *)packName;

- (BOOL) productIdentifierPurchased:(NSString *)productIdentifier;

- (void) showDialog:(NSString *)title text:(NSString *)text;

- (void) buyProduct:(id <IAPDelegate>)delegate;

- (void) restoreProduct:(id <IAPDelegate>)delegate;

@end
