//
//  THLEntityMapper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEntityMapper.h"
#import "NSArray+LinqExtensions.h"

#import "THLLocalModels.h"
#import "THLUser.h"
#import "THLGuestlist.h"
#import "THLGuestlistInvite.h"
#import "THLPerkStoreItem.h"
#import "THLPurchasedPerkItem.h"

#import "THLUserEntity.h"
#import "THLGuestEntity.h"

@implementation THLEntityMapper
- (void)mapBaseValuesFromModel:(PFObject *)model toEntity:(THLEntity *)entity
{
	entity.updatedAt = model.updatedAt;
	entity.objectId = model.objectId;
}


- (THLGuestEntity *)mapGuest:(THLUser *)user
{
    if ([user isKindOfClass:[THLUser class]]) {
        THLGuestEntity *entity = [THLGuestEntity new];
        [self mapBaseValuesFromModel:user toEntity:entity];
        entity.firstName = user.firstName;
        entity.lastName = user.lastName;
        entity.phoneNumber = user.phoneNumber;
        entity.imageURL = [NSURL URLWithString:user.image.url];
        entity.sex = user.sex;
        entity.credits = user.credits;
        return entity;
    } else {
        return nil;
    }
}

@end
