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

#import "THLEntities.h"
#import "THLUserEntity.h"
#import "THLGuestEntity.h"
#import "THLHostEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"
#import "THLPerkStoreItemEntity.h"
#import "THLPurchasedPerkItemEntity.h"

@implementation THLEntityMapper
- (void)mapBaseValuesFromModel:(PFObject *)model toEntity:(THLEntity *)entity {
	entity.updatedAt = model.updatedAt;
	entity.objectId = model.objectId;
}

- (THLEventEntity *)mapEvent:(THLEvent *)event {
    if ([event isKindOfClass:[THLEvent class]]) {
        THLEventEntity *entity = [THLEventEntity new];
        [self mapBaseValuesFromModel:event toEntity:entity];
        entity.date = event.date;
        entity.title = event.title;
        entity.imageURL = [NSURL URLWithString:event.promoImage.url];
        entity.info = event.promoInfo;
        entity.maleCover = event.maleCoverCharge;
        entity.femaleCover = event.femaleCoverCharge;
        entity.location = [self mapLocation:event.location];
        entity.creditsPayout = event.creditsPayout;
        entity.host = (THLHostEntity *)[self mapHost:event[@"host"]];
        entity.maleRatio = event.maleRatio;
        entity.femaleRatio = event.femaleRatio;
        return entity;
    } else {
        return nil;
    }
}

- (NSArray<THLEventEntity *> *)mapEvents:(NSArray *)events {
    WEAKSELF();
	return [events linq_select:^id(THLEvent *event) {
		return [WSELF mapEvent:event];
	}];
}

- (THLLocationEntity *)mapLocation:(THLLocation *)location {
    if ([location isKindOfClass:[THLLocation class]]) {
        THLLocationEntity *entity = [THLLocationEntity new];
        [self mapBaseValuesFromModel:location toEntity:entity];
        entity.name = location.name;
        entity.info = location.info;
        entity.address = location.address;
        entity.city = location.city;
        entity.stateCode = location.stateCode;
        entity.zipcode = location.zipcode;
        entity.neighborhood = location.neighborhood;
        entity.imageURL = [NSURL URLWithString:location.image.url];
        entity.latitude = location.coordinate.latitude;
        entity.longitude = location.coordinate.longitude;
        entity.musicTypes = location.musicTypes;
        entity.attireRequirement = location.attireRequirement;
        
	return entity;
    } else {
        return nil;
    }
}

- (NSArray<THLLocationEntity *> *)mapLocations:(NSArray *)locations {
    WEAKSELF();
	return [locations linq_select:^id(THLLocation *location) {
		return [WSELF mapLocation:location];
	}];
}

- (THLGuestEntity *)mapGuest:(THLUser *)user {
    if ([user isKindOfClass:[THLUser class]]) {
        THLGuestEntity *entity = [THLGuestEntity new];
        [self mapBaseValuesFromModel:user toEntity:entity];
        entity.firstName = user.firstName;
        entity.lastName = user.lastName;
        entity.phoneNumber = user.phoneNumber;
        entity.imageURL = [NSURL URLWithString:user.image.url];
        entity.sex = user.sex;
        entity.rating = user.rating;
        entity.credits = user.credits;
        return entity;
    } else {
        return nil;
    }
}

- (THLHostEntity *)mapHost:(THLUser *)user {
    if ([user isKindOfClass:[THLUser class]]) {
        THLHostEntity *entity = [THLHostEntity new];
        [self mapBaseValuesFromModel:user toEntity:entity];
        entity.firstName = user.firstName;
        entity.lastName = user.lastName;
        entity.phoneNumber = user.phoneNumber;
        entity.twilioNumber = user.twilioNumber;
        entity.imageURL = [NSURL URLWithString:user.image.url];
        entity.sex = user.sex;
        entity.rating = user.rating;
        return entity;
    } else {
        return nil;
    }
}

- (THLPerkStoreItemEntity *)mapPerkStoreItem:(THLPerkStoreItem *)perkStoreItem {
    if ([perkStoreItem isKindOfClass:[THLPerkStoreItem class]]) {
        THLPerkStoreItemEntity *entity = [THLPerkStoreItemEntity new];
        [self mapBaseValuesFromModel:perkStoreItem toEntity:entity];
        entity.name = perkStoreItem.name;
        entity.info = perkStoreItem.info;
        entity.credits = perkStoreItem.credits;
        entity.image = [NSURL URLWithString:perkStoreItem.image.url];
        return entity;
    } else {
        return nil;
    }
}

- (THLPurchasedPerkItemEntity *)mapPurchasedPerkItem:(THLPurchasedPerkItem *)purchasedPerkItem {
    if ([purchasedPerkItem isKindOfClass:[THLPurchasedPerkItem class]]) {
        THLPurchasedPerkItemEntity *entity = [THLPurchasedPerkItemEntity new];
        [self mapBaseValuesFromModel:purchasedPerkItem toEntity:entity];
        entity.guest = [self mapGuest:purchasedPerkItem[@"User"]];
        entity.perkStoreItem = [self mapPerkStoreItem:purchasedPerkItem[@"PerkStoreItem"]];
        entity.purchaseDate = purchasedPerkItem.purchaseDate;
        return entity;
    } else {
        return nil;
    }
}

- (THLGuestlistEntity *)mapGuestlist:(THLGuestlist *)guestlist {
    if ([guestlist isKindOfClass:[THLGuestlist class]]) {
        THLGuestlistEntity *entity = [THLGuestlistEntity new];
        [self mapBaseValuesFromModel:guestlist toEntity:entity];
        entity.reviewStatus = guestlist.reviewStatus;
        entity.owner = [self mapGuest:guestlist[@"Owner"]];
        entity.date = guestlist.date;
        entity.event = [self mapEvent:guestlist[@"event"]];
        return entity;
    } else {
        return nil;
    }
}

- (NSArray<THLGuestlistEntity *> *)mapGuestlists:(NSArray *)guestlists {
    WEAKSELF();
    return [guestlists linq_select:^id(THLGuestlist *guestlist) {
        return [WSELF mapGuestlist:guestlist];
    }];
}

- (THLGuestlistInviteEntity *)mapGuestlistInvite:(THLGuestlistInvite *)guestlistInvite {
    if ([guestlistInvite isKindOfClass:[THLGuestlistInvite class]]) {
        THLGuestlistInviteEntity *entity = [THLGuestlistInviteEntity new];
        [self mapBaseValuesFromModel:guestlistInvite toEntity:entity];
        entity.response = guestlistInvite.response;
        entity.checkInStatus = guestlistInvite.checkInStatus;
        entity.date = guestlistInvite.date;
        entity.guest = [self mapGuest:guestlistInvite[@"Guest"]];
        entity.guestlist = [self mapGuestlist:guestlistInvite[@"Guestlist"]];
        return entity;
    } else {
        return nil;
    }
}

- (NSArray<THLGuestlistInviteEntity *> *)mapGuestlistInvites:(NSArray *)guestlistInvites {
    WEAKSELF();
    return [guestlistInvites linq_select:^id(THLGuestlistInvite *guestlistInvite) {
        return [WSELF mapGuestlistInvite:guestlistInvite];
    }];
}

- (NSArray<THLPerkStoreItemEntity *> *)mapPerkStoreItems:(NSArray *)perkStoreItems {
    WEAKSELF();
    return [perkStoreItems linq_select:^id(THLPerkStoreItem *perkStoreItem) {
        return [WSELF mapPerkStoreItem:perkStoreItem];
    }];
}

- (NSArray<THLPurchasedPerkItemEntity*> *)mapPurchasedPerkItems:(NSArray *)purchasedPerkItems {
    WEAKSELF();
    return [purchasedPerkItems linq_select:^id(THLPurchasedPerkItem *purchasedPerkItem) {
        return [WSELF mapPurchasedPerkItem:purchasedPerkItem];
    }];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
