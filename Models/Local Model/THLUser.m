//
//  THLUser.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLUser.h"

@implementation THLUser

- (NSString *)fullName {
	return [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (BOOL)updateWith:(THLEntity *)newEntity {
	BOOL didUpdate = NO;
	if ([self shouldUpdateWith:newEntity]) {
		THLUser *newUser = (THLUser *)newEntity;
		if (![self.firstName isEqualToString:newUser.firstName]) {
			self.firstName = newUser.firstName;
			didUpdate = YES;
		}

		if (![self.lastName isEqualToString:newUser.lastName]) {
			self.lastName = newUser.lastName;
			didUpdate = YES;
		}

		if (![self.phoneNumber isEqualToString:newUser.phoneNumber]) {
			self.phoneNumber = newUser.phoneNumber;
			didUpdate = YES;
		}

		if (![self.firstName isEqualToString:newUser.firstName]) {
			self.firstName = newUser.firstName;
			didUpdate = YES;
		}
	}
	return didUpdate;
}

- (BOOL)isEquivalentTo:(THLEntity *)cmpEntity {
	if ([super isEquivalentTo:cmpEntity]) {
		BOOL equivalent = YES;
		THLUser *cmpUser = (THLUser *)cmpEntity;
		if (![self.firstName isEqualToString:cmpUser.firstName]) {
			equivalent = NO;
		}

		if (![self.lastName isEqualToString:cmpUser.lastName]) {
			equivalent = NO;
		}

		if (![self.phoneNumber isEqualToString:cmpUser.phoneNumber]) {
			equivalent = NO;
		}

		if (![self.firstName isEqualToString:cmpUser.firstName]) {
			equivalent = NO;
		}

		return equivalent;
	}
	return NO;
}
@end
