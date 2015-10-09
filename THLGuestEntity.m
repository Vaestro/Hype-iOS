//
//  THLGuestEntity.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 10/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestEntity.h"
#import "APContact.h"
#import "THLUserEntity.h"

@implementation THLGuestEntity
@synthesize objectId = _objectId;

- (instancetype)initWithContact:(APContact *)contact {
	if (self = [super init]) {
		_firstName = [contact.firstName copy];
		_lastName = [contact.lastName copy];
		_phoneNumber = [[contact.phones first] copy];
		_type = THLGuestEntityTypeLocalContact;
		_objectId = [NSString stringWithFormat:@"contact%lu", (unsigned long)self.phoneNumber.hash];
	}
	return self;
}

- (instancetype)initWithUser:(THLUserEntity *)user {
	if (self = [super init]) {
		_firstName = [user.firstName copy];
		_lastName = [user.lastName copy];
		_phoneNumber = [user.phoneNumber copy];
		_type = THLGuestEntityTypeRemoteUser;
		_objectId = [user.objectId copy];
	}
	return self;
}

+ (instancetype)fromContact:(APContact *)contact {
	THLGuestEntity *entity = [[THLGuestEntity alloc] initWithContact:contact];
	return entity;
}

+ (instancetype)fromUser:(THLUserEntity *)user {
	THLGuestEntity *entity = [[THLGuestEntity alloc] initWithUser:user];
	return entity;
}

- (NSString *)fullName {
	return [[NSString stringWithFormat:@"%@ %@", _firstName, _lastName] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
