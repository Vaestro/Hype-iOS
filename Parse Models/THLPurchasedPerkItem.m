//
//  THLPurchasedPerkItem.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPurchasedPerkItem.h"


@implementation THLPurchasedPerkItem
@dynamic user;
@dynamic perkStoreItem;
@dynamic purchaseDate;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PurchasedPerkItem";
}
@end
