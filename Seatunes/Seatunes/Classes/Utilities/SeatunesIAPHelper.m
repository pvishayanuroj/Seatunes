//
//  SeatunesIAPHelper.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SeatunesIAPHelper.h"
#import "DataUtility.h"
#import "Utility.h"

@implementation SeatunesIAPHelper

// For singleton
static SeatunesIAPHelper *manager_ = nil;

#pragma mark - Object Lifecycle

+ (SeatunesIAPHelper *) manager
{
    @synchronized (self) {
        if (manager_ == nil) {
            // Alloc eventually calls allocWithZone
            [[self alloc] init];
        }
    }
    return manager_;
}

// Override allocWithZone to avoid potential page thrashing
+ (id) allocWithZone:(NSZone *)zone
{
    @synchronized (self) {
        if (manager_ == nil) {
            manager_ = [super allocWithZone:zone];
            return manager_;
        }
    }
    return nil;
}

+ (void) purge
{
    [manager_ release];
    manager_ = nil;
}

- (id) init
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Kind of hacky, but assume that non-zero index means OK was pressed, in which case only the confirmation dialog has an OK button
    if (buttonIndex != 0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchaseNotification object:nil];       
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchasedFailed:) name:kProductPurchaseFailedNotification object:nil];    
        NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];        
        [super buyProductIdentifier:productIdentifier];  
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    /*
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];
    SKProduct *product = [products_ objectForKey:productIdentifier]; 
    NSLog(@"%@", productIdentifier);
    NSLog(@"%@", product);
    NSLog(@"%@ vs %@", alertView.title, product.localizedTitle);
    */
    //if (product && [alertView.title isEqualToString:product.localizedTitle]) {
    if (buttonIndex == 0) {
        if (delegate_ && [delegate_ respondsToSelector:@selector(finishLoading)]) {
            [delegate_ finishLoading];
        }
    }
}

#pragma mark - Helper Methods

- (BOOL) allPacksPurchased
{
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];
    return [self productIdentifierPurchased:productIdentifier];
}

- (BOOL) packPurchased:(NSString *)packName
{
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:packName];
    return [self productIdentifierPurchased:productIdentifier];
}

- (BOOL) productIdentifierPurchased:(NSString *)productIdentifier
{
    // Check if all packs purchased, if so, this means all products will return true
    if ([purchasedProducts_ containsObject:[[DataUtility manager] productIdentifierFromName:kAllPacks]]) {
        return YES;
    }
    
    return [purchasedProducts_ containsObject:productIdentifier];
}

- (void) showDialog:(NSString *)title text:(NSString *)text
{
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
    [message show];
}

- (void) showConfirmation:(SKProduct *)product
{
    NSNumberFormatter *formatter = [[[NSNumberFormatter alloc] init] autorelease];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:product.priceLocale];
    NSString *price = [formatter stringFromNumber:product.price];
    
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:product.localizedTitle message:product.localizedDescription delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:price, nil] autorelease];
    [message show];
}

- (void) showPurchaseSuccess
{
    NSString *text = [NSString stringWithFormat:@"You've unlocked all of the activities available in Seatunes! Have fun!"];
    UIAlertView *message = [[[UIAlertView alloc] initWithTitle:@"Thank You!" message:text delegate:self cancelButtonTitle:@"Awesome!" otherButtonTitles:nil] autorelease];
    [message show];    
}

#pragma mark - In-App Purchase Methods

- (void) buyProduct:(id <IAPDelegate>)delegate
{
    delegate_ = delegate;
    
    // Check for a connection
    if ([Utility hasInternetConnection]) {
        
        if (delegate_ && [delegate_ respondsToSelector:@selector(showLoading)]) {
            [delegate_ showLoading];
        }
        
        // Setup the notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded) name:kProductsLoadedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoadedFailed:) name:kProductsLoadedFailedNotification object:nil];            
        
        // Make the call to request the products first
        [self requestProducts];   
    }
    else {
        [self showDialog:@"Error" text:@"Internet connection required to make this purchase!"];
    }   
}

- (void) productsLoaded
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];
    SKProduct *product = [products_ objectForKey:productIdentifier];
    
    if (product) {
        [self showConfirmation:product];
    }
    else {
        if (delegate_ && [delegate_ respondsToSelector:@selector(finishLoading)]) {
            [delegate_ finishLoading];
        }        
        [self showDialog:@"Error" text:@"Oops! Could not connect to the server. Try again later!"];    
        delegate_ = nil; 
    }
}

- (void) productsLoadedFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];    
    
    if (delegate_ && [delegate_ respondsToSelector:@selector(finishLoading)]) {
        [delegate_ finishLoading];
    }
    
    NSString *errorText;
    NSInteger rc = [[notification object] integerValue];
    
    switch (rc) {
        case kIAPPurchasesLocked:
            errorText = @"Oops! Purchases are locked. Go ask your parents to unlock this! (Settings > General > Restrictions)";
            break;
        default:
            errorText = @"Oops! Could not connect to the server. Try again later!";
            break;
    }
    [self showDialog:@"Error" text:errorText];    
    delegate_ = nil;    
    
#if DEBUG_IAP
    NSLog(@"Error - Product loading failed, rc: %d", rc);
#endif
}

- (void) productPurchased:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];      
    
    if (delegate_) {        
        [delegate_ purchaseComplete];
        [self showPurchaseSuccess];
        
        if ([delegate_ respondsToSelector:@selector(finishLoading)]) {
            [delegate_ finishLoading];
        }        
    }
    
    delegate_ = nil;
    
#if DEBUG_IAP
    NSString *productIdentifier = [notification object];
    NSLog(@"Successfully bought %@", productIdentifier);
#endif
}

- (void) productPurchasedFailed:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
    
    if (delegate_ && [delegate_ respondsToSelector:@selector(finishLoading)]) {
        [delegate_ finishLoading];
    }
    
    NSInteger rc = [[notification object] integerValue];
    
    if (rc != kIAPUserCancelled) {
        [self showDialog:@"Error" text:@"Oops! Unable to make purchase. Try again later."];                
    }
    
    delegate_ = nil;    
}

@end
