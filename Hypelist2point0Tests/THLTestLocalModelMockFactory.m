//
//  THLTestLocalModelMockFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTestLocalModelMockFactory.h"
#import "Gizou.h"
#import "UIImage+GZImages.h"

#import "THLPromotion.h"
#import "THLUser.h"
#import "THLHost.h"
#import "THLGuest.h"
#import "THLEvent.h"
#import "THLLocation.h"
#import "BFKit.h"

@implementation THLTestLocalModelMockFactory
- (THLPromotion *)mockLocalPromotion {
	THLPromotion *promotion = [THLPromotion new];
	promotion.objectId = [self randomObjectId];
	promotion.time = [NSDate dateWithTimeIntervalSinceNow:arc4random()%10000];
	promotion.maleRatio = 1;
	promotion.femaleRatio = 2 + arc4random()%5;
	promotion.event = [self mockLocalEvent];
	promotion.host = [self mockLocalHost];
	return promotion;
}

- (THLUser *)mockLocalUser {
	THLUser *user = [THLUser new];
	user.objectId = [self randomObjectId];
	user.firstName = [GZNames firstName];
	user.lastName = [GZNames lastName];
	user.phoneNumber = [GZPhoneNumbers phoneNumber];
	user.imageURL = [NSURL URLWithString:[GZInternet url]];
	user.rating = [NSNumber randomIntBetweenMin:2 andMax:5];
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
	event.objectId = [self randomObjectId];
	event.title = [GZWords words:4];
	event.promoImageURL = [NSURL URLWithString:[GZInternet url]];
	event.promoInfo = [GZWords paragraphs];
	event.maleCover = arc4random()%40;
	event.femaleCover = arc4random()%10;
	event.location = [self mockLocalLocation];
	event.date = [NSDate dateWithTimeIntervalSinceNow:arc4random()%10000];
	return event;
}

- (THLLocation *)mockLocalLocation {
	THLLocation *location = [THLLocation new];
	location.objectId = [self randomObjectId];
	location.imageURL = [NSURL URLWithString:[GZInternet url]];
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

- (NSString *)randomObjectId {
	NSMutableArray *letters = [NSMutableArray new];
	for (int i = 0; i < 10; i++) {
		[letters addObject:[self randomLetter]];
	}
	return [letters componentsJoinedByString:@""];
}

- (NSString *)randomLetter {
	return [NSString stringWithFormat:@"%c", arc4random_uniform(26) + 'a'];
}

+ (NSArray *)mockLocalPromotions:(NSInteger)count {
	THLTestLocalModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockLocalPromotion]];
	}
	return items;
}

+ (NSArray *)mockLocalHosts:(NSInteger)count {
	THLTestLocalModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockLocalHost]];
	}
	return items;
}

+ (NSArray *)mockLocalGuests:(NSInteger)count {
	THLTestLocalModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockLocalGuest]];
	}
	return items;
}

+ (NSArray *)mockLocalEvents:(NSInteger)count {
	THLTestLocalModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockLocalEvent]];
	}
	return items;
}

+ (NSArray *)mockLocalLocations:(NSInteger)count {
	THLTestLocalModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockLocalLocation]];
	}
	return items;
}

@end
