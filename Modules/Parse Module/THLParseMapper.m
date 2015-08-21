//
//  THLParseMapper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseMapper.h"

//Remote Models
#import "THLParsePromotion.h"
#import "THLParseUser.h"
#import "THLParseEvent.h"
#import "THLParseLocation.h"

//Local Models
#import "THLPromotion.h"
#import "THLUser.h"
#import "THLHost.h"
#import "THLGuest.h"
#import "THLEvent.h"
#import "THLLocation.h"


@implementation THLParseMapper
#pragma mark - Mapping Parse -> Local
+ (THLEvent *)mapEvent:(THLParseEvent *)parseEvent {
	THLEvent *event = [THLEvent new];
	event.objectId = parseEvent.objectId;
	event.date = parseEvent.date;
	event.title = parseEvent.title;
	event.promoImageURL = parseEvent.promoImage.url;
	event.promoInfo = parseEvent.promoInfo;
	event.maleCover = parseEvent.maleCoverCharge;
	event.femaleCover = parseEvent.femaleCoverCharge;
	event.location = [self mapLocation:parseEvent.location];
	return event;
}

+ (THLPromotion *)mapPromotion:(THLParsePromotion *)parsePromotion {
	THLPromotion *promotion = [THLPromotion new];
	promotion.objectId = parsePromotion.objectId;
	promotion.time = parsePromotion.time;
	promotion.maleRatio = parsePromotion.maleRatio;
	promotion.femaleRatio = parsePromotion.femaleRatio;
	promotion.event = [self mapEvent:parsePromotion.event];
	promotion.host = (THLHost *)[self mapUser:parsePromotion.host];
	return promotion;
}

+ (THLUser *)mapUser:(THLParseUser *)parseUser {
	switch (parseUser.type) {
		case THLParseUserTypeGuest: return [self mapUserToGuest:parseUser];
		case THLParseUserTypeHost:	return [self mapUserToHost:parseUser];
		case THLParseUserTypeAdmin: return [self mapUserToGuest:parseUser];
		default: break;
	}

	return nil;
}

+ (THLGuest *)mapUserToGuest:(THLParseUser *)parseUser {
	NSAssert(parseUser.type == THLParseUserTypeGuest || THLParseUserTypeAdmin, @"User must be a guest (or admin acting as a guest)");
	THLGuest *guest = [THLGuest new];
	guest.objectId = parseUser.objectId;
	guest.firstName = parseUser.firstName;
	guest.lastName = parseUser.lastName;
	guest.phoneNumber = parseUser.phoneNumber;
	guest.rating = parseUser.rating;
	return guest;
}

+ (THLHost *)mapUserToHost:(THLParseUser *)parseUser {
	NSAssert(parseUser.type == THLParseUserTypeHost || THLParseUserTypeAdmin, @"User must be a guest (or admin acting as a guest)");
	THLHost *host = [THLHost new];
	host.objectId = parseUser.objectId;
	host.firstName = parseUser.firstName;
	host.lastName = parseUser.lastName;
	host.phoneNumber = parseUser.phoneNumber;
	host.rating = parseUser.rating;
	return host;
}

+ (THLLocation *)mapLocation:(THLParseLocation *)parseLocation {
	THLLocation *location = [THLLocation new];
	location.objectId = parseLocation.objectId;
//	location.imageURL = parseLocation.image.url;
	location.info = parseLocation.info;
	location.name = parseLocation.name;
	location.address = parseLocation.address;
	location.city = parseLocation.city;
	location.state = parseLocation.stateCode;
	location.zipcode = parseLocation.zipcode;
	location.neighborhood = parseLocation.neighborhood;
	location.latitude = parseLocation.coordinate.latitude;
	location.longitude = parseLocation.coordinate.longitude;
	return location;
}

#pragma mark - Unmapping Local -> Parse
+ (THLParseEvent *)unmapEvent:(THLEvent *)localEvent {
	THLParseEvent *event = [THLParseEvent object];
	event.objectId = localEvent.objectId;
	event.date = localEvent.date;
	event.maleCoverCharge = localEvent.maleCover;
	event.femaleCoverCharge = localEvent.femaleCover;
	event.title = localEvent.title;
	event.promoInfo = localEvent.promoInfo;
	event.location = [self unmapLocation:localEvent.location];
	return event;
}

+ (THLParsePromotion *)unmapPromotion:(THLPromotion *)localPromotion {
	THLParsePromotion *promotion = [THLParsePromotion object];
	promotion.objectId = localPromotion.objectId;
	promotion.maleRatio = localPromotion.maleRatio;
	promotion.femaleRatio = localPromotion.femaleRatio;
	promotion.time = localPromotion.time;
	promotion.host = [self unmapUser:localPromotion.host];
	promotion.event = [self unmapEvent:localPromotion.event];
	return promotion;
}

+ (THLParseUser *)unmapUser:(THLUser *)localUser {
	THLParseUser *user = [THLParseUser object];
	user.objectId = localUser.objectId;
	user.firstName = localUser.firstName;
	user.lastName = localUser.lastName;
	user.phoneNumber = localUser.phoneNumber;
	user.rating = localUser.rating;

	if ([localUser isKindOfClass:[THLGuest class]]) {
		user.type = THLParseUserTypeGuest;
	} else if ([localUser isKindOfClass:[THLHost class]]) {
		user.type = THLParseUserTypeHost;
	}
	
	return user;
}

+ (THLParseLocation *)unmapLocation:(THLLocation *)localLocation {
	THLParseLocation *location = [THLParseLocation object];
	location.objectId = localLocation.objectId;
	location.name = localLocation.name;
	location.info = localLocation.info;
	location.address = localLocation.address;
	location.city = localLocation.city;
	location.stateCode = localLocation.state;
	location.zipcode = localLocation.zipcode;
	location.neighborhood = localLocation.neighborhood;
	location.coordinate = [PFGeoPoint geoPointWithLatitude:localLocation.latitude longitude:localLocation.longitude];
	return location;
}

@end
