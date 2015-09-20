//
//  THLTestParseModelMockFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/22/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLTestParseModelMockFactory.h"
#import "Gizou.h"
#import "UIImage+GZImages.h"

#import "THLParsePromotion.h"
#import "THLParseUser.h"
#import "THLParseEvent.h"
#import "THLParseLocation.h"
#import "BFKit.h"

@implementation THLTestParseModelMockFactory
- (THLParseEvent *)mockParseEvent {
	THLParseEvent *event = [THLParseEvent object];
	event.objectId = [self randomObjectId];
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
	promotion.objectId = [self randomObjectId];
	promotion.time = [NSDate dateWithTimeIntervalSinceNow:arc4random()%1000];
	promotion.maleRatio = 1;
	promotion.femaleRatio = 3 + arc4random()%6;
	promotion.host = [self mockParseHostUser];
	promotion.event = [self mockParseEvent];
	return promotion;
}

- (THLParseUser *)mockParseUserOfType:(THLParseUserType)type {
	THLParseUser *user = [THLParseUser object];
	user.objectId = [self randomObjectId];
	user.type = type;
	user.fbEmail = [GZInternet email];
	user.fbBirthday = [NSDate dateWithTimeIntervalSinceNow:-arc4random()%10000000];
	//	NSData *imageData = UIImagePNGRepresentation([UIImage randomImage]);
	//	user.image = [PFFile fileWithData:imageData];
	user.firstName = [GZNames firstName];
	user.lastName = [GZNames lastName];
	user.phoneNumber = [GZPhoneNumbers phoneNumber];
	user.sex = arc4random()%THLParseUserSex_Count;
	user.rating = [NSNumber randomIntBetweenMin:2 andMax:5];
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
	THLParseLocation *location = [THLParseLocation object];
	location.objectId = [self randomObjectId];
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

+ (NSArray *)mockParsePromotions:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParsePromotion]];
	}
	return items;
}

+ (NSArray *)mockParseHostUsers:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParseHostUser]];
	}
	return items;
}

+ (NSArray *)mockParseGuestUsers:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParseGuestUser]];
	}
	return items;
}

+ (NSArray *)mockParseAdminUsers:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParseAdminUser]];
	}
	return items;
}


+ (NSArray *)mockParseEvents:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParseEvent]];
	}
	return items;
}

+ (NSArray *)mockParseLocations:(NSInteger)count {
	THLTestParseModelMockFactory *factory = [self new];
	NSMutableArray *items = [NSMutableArray new];
	for (int i = 0; i < count; i++) {
		[items addObject:[factory mockParseLocation]];
	}
	return items;
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
@end
