//
//  IAPHelper.h
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/25/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface IAPHelper : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    
    NSSet *productIdentifiers_;
    
    NSMutableDictionary *products_;
    
    NSMutableSet *purchasedProducts_;
    
}

- (void) loadProductIdentifiers:(NSSet *)productIdentifiers;

- (void) requestProducts;

- (void) buyProductIdentifier:(NSString *)productIdentifier;

- (void) recordTransaction:(SKPaymentTransaction *)transaction;

- (void) provideContent:(NSString *)productIdentifier;

- (void) completeTransaction:(SKPaymentTransaction *)transaction;

- (void) failedTransaction:(SKPaymentTransaction *)transaction;

- (void) restoreTransaction:(SKPaymentTransaction *)transaction;

@end
