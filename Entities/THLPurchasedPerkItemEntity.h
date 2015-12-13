//
//  THLPurchasedPerkItemEntity.h
//  TheHypelist
//
//  Created by Daniel Aksenov on 12/12/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "THLPerkStoreItemEntity.h"
#import "THLGuestEntity.h"


@interface THLPurchasedPerkItemEntity : THLEntity
@property (nonatomic, copy) NSDate *purchaseDate;
@property (nonatomic, strong) THLPerkStoreItemEntity *perkStoreItem;
@property (nonatomic, strong) THLGuestEntity *guest;
@end
