//
//  THLUser.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//
#import "THLUser.h"
#import <objc/runtime.h>



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

- (BOOL)isNewUser {
	return (self.phoneNumber.length == 0 || self.imageURL == nil);
}


@end
