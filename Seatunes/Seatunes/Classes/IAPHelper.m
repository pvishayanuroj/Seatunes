//
//  IAPHelper.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/25/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "IAPHelper.h"

@implementation IAPHelper

#pragma mark - Object Lifecycle

- (id) init
{
    if ((self = [super init])) {
        
        productIdentifiers_ = nil;
        products_ = nil;
        purchasedProducts_ = nil;   
    }
    
    return self;
}

- (void) dealloc
{
    [productIdentifiers_ release];
    [products_ release];
    [purchasedProducts_ release];
    
    [super dealloc];
}

- (void) loadProductIdentifiers:(NSSet *)productIdentifiers
{
    [productIdentifiers_ release];
    productIdentifiers_ = [productIdentifiers retain];
    
    NSMutableSet *purchasedProducts = [NSMutableSet set];
    
    for (NSString *productIdentifier in productIdentifiers_) {
        BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
        if (productPurchased) {
            [purchasedProducts addObject:productIdentifier];
        }
    }
    
    [purchasedProducts_ release];
    purchasedProducts_ = [purchasedProducts retain];
}

- (void) requestProducts
{
    NSLog(@"Requesting products with: %@", productIdentifiers_);
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers_];
    request.delegate = self;
    [request start];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *responseProducts = response.products;
    
    [products_ release];   
    products_ = [[NSMutableDictionary dictionaryWithCapacity:[responseProducts count]] retain];    
    for (SKProduct *product in responseProducts) {
        [products_ setObject:product forKey:product.productIdentifier];
    }
    
    NSLog(@"Got products: %@", products_);
    if ([products_ count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedFailedNotification object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:nil];
    }
}

- (void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request did fail: %@", error.localizedDescription);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedFailedNotification object:nil];
}

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void) buyProductIdentifier:(NSString *)productIdentifier
{
    if (products_ != nil) {
    
        SKProduct *product = [products_ objectForKey:productIdentifier];
        
        if (product != nil) {
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:nil];            
            NSLog(@"BuyProductIdentifer: Invalid product identifier: %@", productIdentifier);
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:nil];                    
        NSLog(@"Cannot call buyProductIdentifier without calling request products");
    }
}

- (void) recordTransaction:(SKPaymentTransaction *)transaction
{
    // Record on server side if needed
}

- (void) provideContent:(NSString *)productIdentifier
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [purchasedProducts_ addObject:productIdentifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseNotification object:productIdentifier];
}

- (void) completeTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.payment.productIdentifier];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void) failedTransaction:(SKPaymentTransaction *)transaction
{
    // Only show an error it was caused by anything OTHER than the user cancelling it themselves
    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction failed: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];    
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];    
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];    
}

@end
