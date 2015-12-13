//
//  THLPurchasedPerkItem.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Parse/Parse.h>
#import <Parse/PFObject+Subclass.h>
#import "THLPerkStoreItem.h"
#import "THLUser.h"

@interface THLPurchasedPerkItem : PFObject<PFSubclassing>
@property (nonatomic, retain) THLUser *user;
@property (nonatomic, retain) THLPerkStoreItem *perkStoreItem;
@property (nonatomic, retain) NSDate *purchaseDate;
@end
