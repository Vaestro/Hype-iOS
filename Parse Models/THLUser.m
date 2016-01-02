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
@dynamic fbId;
@dynamic fbEmail;
@dynamic fbBirthday;
@dynamic image;
//@dynamic thumbnail;
@dynamic firstName;
@dynamic lastName;
@dynamic phoneNumber;
@dynamic type;
@dynamic sex;
@dynamic rating;
@dynamic fbVerified;
@dynamic location;
@dynamic credits;
@dynamic twilioNumber;

+ (void)load {
	[self registerSubclass];
}

- (NSString *)fullName {
	return @"";
}
@end
