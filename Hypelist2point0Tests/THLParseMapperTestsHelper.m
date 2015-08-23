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

@implementation THLParseMapperTestsHelper
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
