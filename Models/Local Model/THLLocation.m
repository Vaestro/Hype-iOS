//
//  THLLocation.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLocation.h"

@implementation THLLocation
- (BOOL)isEquivalentTo:(THLEntity *)cmpEntity {
	if ([super isEquivalentTo:cmpEntity]) {
		BOOL equivalent = YES;
		THLLocation *cmpLocation = (THLLocation *)cmpEntity;

		if (![self.imageURL isEqual:cmpLocation.imageURL]) {
			equivalent = NO;
		}

		if (![self.name isEqualToString:cmpLocation.name]) {
			equivalent = NO;
		}

		if (![self.info isEqualToString:cmpLocation.info]) {
			equivalent = NO;
		}

		if (![self.city isEqualToString:cmpLocation.city]) {
			equivalent = NO;
		}

		if (![self.state isEqualToString:cmpLocation.state]) {
			equivalent = NO;
		}

		if (![self.zipcode isEqualToString:cmpLocation.zipcode]) {
			equivalent = NO;
		}

		if (self.latitude != cmpLocation.latitude) {
			equivalent = NO;
		}

		if (self.longitude != cmpLocation.longitude) {
			equivalent = NO;
		}

		return equivalent;
	}
	return NO;
}

- (NSString *)fullAddress {
	return @"FULL ADDRESS!";
}
@end
