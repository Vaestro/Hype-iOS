//
//  THLParseMapperTestsHelper.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseMapperTestsHelper.h"

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
#import "Gizou.h"
#import "UIImage+GZImages.h"

float randomFloat(float Min, float Max){
	return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

@implementation THLParseMapperTestsHelper
- (THLParseEvent *)mockParseEvent {
	THLParseEvent *event = [THLParseEvent object];
	event.objectId = [GZWords word];
	event.date = [NSDate dateWithTimeIntervalSinceNow:arc4random()%1000];
	event.maleCoverCharge = arc4random()%40;
	event.femaleCoverCharge = arc4random()%10;
	event.title = [GZWords words:3+arc4random()%3];
	event.promoInfo = [GZWords paragraph];
//	NSData *promoImageData = UIImagePNGRepresentation([UIImage randomImage]);
//	event.promoImage = [PFFile fileWithData:promoImageData];
	event.location = [self mockParseLocation];
	return event;
}

- (THLParsePromotion *)mockParsePromotion {
	THLParsePromotion *promotion = [THLParsePromotion object];
	promotion.objectId = [GZWords word];
	promotion.time = [NSDate dateWithTimeIntervalSinceNow:arc4random()%1000];
	promotion.maleRatio = 1;
	promotion.femaleRatio = 3 + arc4random()%6;
	promotion.host = [self mockParseHostUser];
	promotion.event = [self mockParseEvent];
	return promotion;
}

- (THLParseUser *)mockParseUserOfType:(THLParseUserType)type {
	THLParseUser *user = [THLParseUser object];
	user.objectId = [GZWords word];
	user.type = type;
	user.fbEmail = [GZInternet email];
	user.fbBirthday = [NSDate dateWithTimeIntervalSinceNow:-arc4random()%10000000];
//	NSData *imageData = UIImagePNGRepresentation([UIImage randomImage]);
//	user.image = [PFFile fileWithData:imageData];
	user.firstName = [GZNames firstName];
	user.lastName = [GZNames lastName];
	user.phoneNumber = [GZPhoneNumbers phoneNumber];
	user.sex = arc4random()%THLParseUserSex_Count;
	user.rating = randomFloat(2, 5);
	return user;
}

- (THLParseUser *)mockParseGuestUser {
	return [self mockParseUserOfType:THLParseUserTypeGuest];
}

- (THLParseUser *)mockParseHostUser {
	return [self mockParseUserOfType:THLParseUserTypeHost];
}

- (THLParseUser *)mockParseAdminUser {
	return [self mockParseUserOfType:THLParseUserTypeAdmin];
}

- (THLParseLocation *)mockParseLocation {
	THLParseLocation *location = [THLParseLocation objectWithoutDataWithObjectId:[GZWords word]];
//	location.objectId = [GZWords word];
//	NSData *imageData = UIImagePNGRepresentation([UIImage randomImage]);
//	location.image = [PFFile fileWithData:imageData];
	location.name = [GZWords words:3+arc4random()%3];
	location.info = [GZWords paragraphs:1+arc4random()%3];
	location.address = [GZLocations streetAddress];
	location.city = [GZLocations city];
	location.stateCode = [GZLocations state];
	location.zipcode = [GZLocations zipCode];
	location.neighborhood = [GZWords word];
	PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:[GZLocations latitude] longitude:[GZLocations longitude]];
	location.coordinate = geoPoint;
	return location;
}

- (THLPromotion *)mockLocalPromotion {
	THLPromotion *promotion = [THLPromotion new];
	promotion.objectId = [GZWords word];
	promotion.time = [NSDate dateWithTimeIntervalSinceNow:arc4random()%10000];
	promotion.maleRatio = 1;
	promotion.femaleRatio = 2 + arc4random()%5;
	promotion.event = [self mockLocalEvent];
	promotion.host = [self mockLocalHost];
	return promotion;
}

- (THLUser *)mockLocalUser {
	THLUser *user = [THLUser new];
	user.objectId = [GZWords word];
	user.firstName = [GZNames firstName];
	user.lastName = [GZNames lastName];
	user.phoneNumber = [GZPhoneNumbers phoneNumber];
	user.imageURL = [GZInternet url];
	user.rating = randomFloat(2, 5);
	return user;
}

- (THLHost *)mockLocalHost {
	THLUser *mockUser = [self mockLocalUser];
	THLHost *host = [THLHost new];
	host.objectId = mockUser.objectId;
	host.firstName = mockUser.firstName;
	host.lastName = mockUser.lastName;
	host.phoneNumber = mockUser.phoneNumber;
	host.rating = mockUser.rating;
	return host;
}

- (THLGuest *)mockLocalGuest {
	THLUser *mockUser = [self mockLocalUser];
	THLGuest *guest = [THLGuest new];
	guest.objectId = mockUser.objectId;
	guest.firstName = mockUser.firstName;
	guest.lastName = mockUser.lastName;
	guest.phoneNumber = mockUser.phoneNumber;
	guest.rating = mockUser.rating;
	return guest;
}

- (THLEvent *)mockLocalEvent {
	THLEvent *event = [THLEvent new];
	event.objectId = [GZWords word];
	event.title = [GZWords words:4];
	event.promoImageURL = [GZInternet url];
	event.promoInfo = [GZWords paragraphs];
	event.maleCover = arc4random()%40;
	event.femaleCover = arc4random()%10;
	event.location = [self mockLocalLocation];
	event.date = [NSDate dateWithTimeIntervalSinceNow:arc4random()%10000];
	return event;
}

- (THLLocation *)mockLocalLocation {
	THLLocation *location = [THLLocation new];
	location.objectId = [GZWords word];
	location.imageURL = [GZInternet url];
	location.name = [GZWords words:2+arc4random()%3];
	location.info = [GZWords paragraphs];
	location.address = [GZLocations streetAddress];
	location.city = [GZLocations city];
	location.state = [GZLocations state];
	location.zipcode = [GZLocations zipCode];
	location.neighborhood = [GZWords word];
	location.latitude = [GZLocations latitude];
	location.longitude = [GZLocations longitude];
	return location;
}

- (BOOL)verifyParseEvent:(THLParseEvent *)parseEvent equalToLocalEvent:(THLEvent *)localEvent {
	if (![parseEvent.date isEqualToDate:localEvent.date]) {
		return NO;
	}

	if (parseEvent.maleCoverCharge != localEvent.maleCover) {
		return NO;
	}

	if (parseEvent.femaleCoverCharge != localEvent.femaleCover) {
		return NO;
	}

	if (![parseEvent.title isEqualToString:localEvent.title]) {
		return NO;
	}

	if (![parseEvent.promoInfo isEqualToString:localEvent.promoInfo]) {
		return NO;
	}

	if (![self verifyParseLocation:parseEvent.location equalToLocalLocation:localEvent.location]) {
		return NO;
	}

	return YES;
}

- (BOOL)verifyParseLocation:(THLParseLocation *)parseLocation equalToLocalLocation:(THLLocation *)localLocation {
	if (![parseLocation.name isEqualToString:localLocation.name]) {
		return NO;
	}

	if (![parseLocation.info isEqualToString:localLocation.info]) {
		return NO;
	}

	if (![parseLocation.address isEqualToString:localLocation.address]) {
		return NO;
	}

	if (![parseLocation.city isEqualToString:localLocation.city]) {
		return NO;
	}

	if (![parseLocation.stateCode isEqualToString:localLocation.state]) {
		return NO;
	}

	if (![parseLocation.zipcode isEqualToString:localLocation.zipcode]) {
		return NO;
	}

	if (![parseLocation.neighborhood isEqualToString:localLocation.neighborhood]) {
		return NO;
	}

	if (parseLocation.coordinate.latitude != localLocation.latitude ||
		parseLocation.coordinate.longitude != localLocation.longitude) {
		return NO;
	}

	return YES;
}


- (BOOL)verifyParsePromotion:(THLParsePromotion *)parsePromotion equalToLocalPromotion:(THLPromotion *)localPromotion {
	if (![parsePromotion.time isEqualToDate:localPromotion.time]) {
		return NO;
	}

	if (parsePromotion.maleRatio != localPromotion.maleRatio) {
		return NO;
	}

	if (parsePromotion.femaleRatio != localPromotion.femaleRatio) {
		return NO;
	}

	if (![self verifyParseUser:parsePromotion.host equalToLocalUser:localPromotion.host]) {
		return NO;
	}

	if (![self verifyParseEvent:parsePromotion.event equalToLocalEvent:localPromotion.event]) {
		return NO;
	}

	return YES;
}

- (BOOL)verifyParseUser:(THLParseUser *)parseUser equalToLocalUser:(THLUser *)localUser {
	switch (parseUser.type) {
		case THLParseUserTypeGuest: {
			if (![localUser isKindOfClass:[THLGuest class]]) {
				return NO;
			}
			break;
		}
		case THLParseUserTypeHost: {
			if (![localUser isKindOfClass:[THLHost class]]) {
				return NO;
			}
			break;
		}
		default: {
			break;
		}
	}

	if (![parseUser.firstName isEqualToString:localUser.firstName]) {
		return NO;
	}

	if (![parseUser.lastName isEqualToString:localUser.lastName]) {
		return NO;
	}

	if (![parseUser.phoneNumber isEqualToString:localUser.phoneNumber]) {
		return NO;
	}

	if (parseUser.rating != localUser.rating) {
		return NO;
	}

	return YES;
}


@end
