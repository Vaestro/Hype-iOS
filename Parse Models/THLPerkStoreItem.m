//
//  THLPerkStoreItem.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/24/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreItem.h"

@implementation THLPerkStoreItem
@dynamic name;
@dynamic itemDescription;
@dynamic image;
@dynamic credits;


+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"PerkStoreItem";
}
@end
