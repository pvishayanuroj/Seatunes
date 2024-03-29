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
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];        
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
#if DEBUG_IAP
    NSLog(@"Requesting products with: %@", productIdentifiers_);
#endif
    
    // Check parental controls
    if ([SKPaymentQueue canMakePayments]) {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers_];
        request.delegate = self;
        [request start];        
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedFailedNotification object:[NSNumber numberWithInteger:kIAPPurchasesLocked]];        
    }
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *responseProducts = response.products;
    
    [products_ release];   
    products_ = [[NSMutableDictionary dictionaryWithCapacity:[responseProducts count]] retain];    
    for (SKProduct *product in responseProducts) {
        [products_ setObject:product forKey:product.productIdentifier];
    }
    
    if ([products_ count] == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedFailedNotification object:[NSNumber numberWithInteger:kIAPNoProductsReturned]];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:nil];
    }
}

- (void) request:(SKRequest *)request didFailWithError:(NSError *)error
{
#if DEBUG_IAP
    NSLog(@"Products Request Did Fail With Error: %@", error.localizedDescription);
#endif
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedFailedNotification object:[NSNumber numberWithInteger:kIAPNetworkError]];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:[NSNumber numberWithInteger:kIAPInvalidProduct]];            
            NSLog(@"BuyProductIdentifer: Invalid product identifier: %@", productIdentifier);
        }
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:[NSNumber numberWithInteger:kIAPProductsNotLoaded]];                    
        NSLog(@"Cannot call buyProductIdentifier without calling request products");
    }
}

- (void) restoreTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{  
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductRestoreFailedNotification object:[NSNumber numberWithInteger:kIAPTransactionFailed]];    
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    for (SKPaymentTransaction *transaction in queue.transactions) {
        
        [self restoreTransaction:transaction];          
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
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];        
    
    // If the error was caused by anything other than the user cancelling it themselves
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:[NSNumber numberWithInteger:kIAPTransactionFailed]];        
#if DEBUG_IAP
        NSLog(@"Transaction failed: %@", transaction.error.localizedDescription);        
#endif
    }
    // Else the user cancelled it
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:[NSNumber numberWithInteger:kIAPUserCancelled]];
        
#if DEBUG_IAP
        NSLog(@"User cancelled transaction");
#endif
    }
}

- (void) restoreTransaction:(SKPaymentTransaction *)transaction
{
    [self recordTransaction:transaction];
    [self provideContent:transaction.originalTransaction.payment.productIdentifier];    
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];    
}

@end
