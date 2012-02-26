//
//  SeatunesIAPHelper.m
//  Seatunes
//
//  Created by Jantorn Jiambutr on 2/26/12.
//  Copyright (c) 2012 Paul Vishayanuroj. All rights reserved.
//

#import "SeatunesIAPHelper.h"
#import "DataUtility.h"

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
         
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (BOOL) allPacksPurchased
{
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:kAllPacks];
    return [self packPurchased:productIdentifier];
}

- (BOOL) packPurchased:(NSString *)packName
{
    NSString *productIdentifier = [[DataUtility manager] productIdentifierFromName:packName];
    return [self packPurchased:productIdentifier];
}

- (BOOL) productPurchased:(NSString *)productIdentifier
{
    return [purchasedProducts_ containsObject:productIdentifier];
}

@end
