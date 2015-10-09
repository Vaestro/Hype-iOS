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
		_firstName = contact.firstName;
		_lastName = contact.lastName;
		_phoneNumber = [contact.phones first];
		_type = THLGuestEntityTypeLocalContact;
		_objectId = [NSString stringWithFormat:@"contact%lu", (unsigned long)self.phoneNumber.hash];
	}
	return self;
}

- (instancetype)initWithUser:(THLUserEntity *)user {
	if (self = [super init]) {
		_firstName = user.firstName;
		_lastName = user.lastName;
		_phoneNumber = user.phoneNumber;
		_type = THLGuestEntityTypeRemoteUser;
		_objectId = user.objectId;
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


@end
