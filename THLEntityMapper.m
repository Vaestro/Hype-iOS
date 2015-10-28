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
#import "THLPromotion.h"
#import "THLGuestlist.h"
#import "THLGuestlistInvite.h"

#import "THLEntities.h"
#import "THLUserEntity.h"
#import "THLHostEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistEntity.h"
#import "THLGuestlistInviteEntity.h"

@implementation THLEntityMapper
- (void)mapBaseValuesFromModel:(PFObject *)model toEntity:(THLEntity *)entity {
	entity.updatedAt = model.updatedAt;
	entity.objectId = model.objectId;
}

- (THLEventEntity *)mapEvent:(THLEvent *)event {
	NSAssert([event isKindOfClass:[THLEvent class]], @"Must be of type THLEvent to map!");
	THLEventEntity *entity = [THLEventEntity new];
	[self mapBaseValuesFromModel:event toEntity:entity];
	entity.date = event.date;
	entity.title = event.title;
	entity.imageURL = [NSURL URLWithString:event.promoImage.url];
	entity.info = event.promoInfo;
	entity.maleCover = event.maleCoverCharge;
	entity.femaleCover = event.femaleCoverCharge;
	entity.location = [self mapLocation:event.location];
	return entity;
}

- (NSArray<THLEventEntity *> *)mapEvents:(NSArray *)events {
	return [events linq_select:^id(THLEvent *event) {
		return [self mapEvent:event];
	}];
}

- (THLLocationEntity *)mapLocation:(THLLocation *)location {
	NSAssert([location isKindOfClass:[THLLocation class]], @"Must be of type THLLocation to map!");
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
	return entity;
}

- (NSArray<THLLocationEntity *> *)mapLocations:(NSArray *)locations {
	return [locations linq_select:^id(THLLocation *location) {
		return [self mapLocation:location];
	}];
}

- (THLUserEntity *)mapUser:(THLUser *)user {
	THLUserEntity *entity;
	switch (user.type) {
		case THLUserTypeGuest: {
			return nil;
			break;
		}
		case THLUserTypeHost: {
			entity = [THLHostEntity new];
			break;
		}
		default: {
			break;
		}
	}

	[self mapBaseValuesFromModel:user toEntity:entity];
	entity.firstName = user.firstName;
	entity.lastName = user.lastName;
	entity.phoneNumber = user.phoneNumber;
	entity.imageURL = [NSURL URLWithString:user.image.url];
	entity.sex = user.sex;
	entity.rating = user.rating;
	return entity;
}

//- (THLUser *)unmapUser:(THLUserEntity *)userEntity {
//    NSAssert([userEntity isKindOfClass:[THLUser class]], @"Must be of type THLUser to map!");
//    THLUser *user = [THLUser new];
//    user.firstName = userEntity.firstName;
//    user.lastName = userEntity.lastName;
//    user.phoneNumber = userEntity.phoneNumber;
//    user.sex = userEntity.sex;
//    user.rating = userEntity.rating;
//    return user;
//}

- (NSArray *)mapUsers:(NSArray *)users {
	return [users linq_select:^id(THLUser *user) {
		return [self mapUser:user];
	}];
}

- (NSArray *)mapPromotions:(NSArray *)promotions {
	return [promotions linq_select:^id(THLPromotion *promotion) {
		return [self mapPromotion:promotion];
	}];
}


- (THLPromotionEntity *)mapPromotion:(THLPromotion *)promotion {
	THLPromotionEntity *entity = [THLPromotionEntity new];
	[self mapBaseValuesFromModel:promotion toEntity:entity];
	entity.time = promotion.time;
	entity.maleRatio = promotion.maleRatio;
	entity.femaleRatio = promotion.femaleRatio;
	entity.host = (THLHostEntity *)[self mapUser:promotion.host];
	entity.event = [self mapEvent:promotion.event];
    entity.eventId = promotion.eventId;
	return entity;
}

- (THLGuestlistEntity *)mapGuestlist:(THLGuestlist *)guestlist {
    THLGuestlistEntity *entity = [THLGuestlistEntity new];
    [self mapBaseValuesFromModel:guestlist toEntity:entity];
    entity.eventId = guestlist.eventId;
    entity.reviewStatus = guestlist.reviewStatus;
    entity.owner = (THLGuestEntity *)[self mapUser:guestlist.owner];
//TODO: Fix mapping guestlist's promotion
//    entity.promotion = [self mapPromotion:guestlist.promotion];
    return entity;
}

- (NSArray *)mapGuestlists:(NSArray *)guestlists {
    return [guestlists linq_select:^id(THLGuestlist *guestlist) {
        return [self mapGuestlist:guestlist];
    }];
}

- (THLGuestlistInviteEntity *)mapGuestlistInvite:(THLGuestlistInvite *)guestlistInvite {
    THLGuestlistInviteEntity *entity = [THLGuestlistInviteEntity new];
    [self mapBaseValuesFromModel:guestlistInvite toEntity:entity];
    entity.response = guestlistInvite.response;
    entity.guestlist = [self mapGuestlist:guestlistInvite.guestlist];
    entity.guest = (THLGuestEntity *)[self mapUser:guestlistInvite.recipient];
    return entity;
}

- (NSArray *)mapGuestlistInvites:(NSArray *)guestlistInvites {
    return [guestlistInvites linq_select:^id(THLGuestlistInvite *guestlistInvite) {
        return [self mapGuestlistInvite:guestlistInvite];
    }];
}

@end
