//
//  THLParseUser.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseUser.h"

@implementation THLParseUser
@dynamic fbId;
@dynamic fbEmail;
@dynamic fbBirthday;
@dynamic image;
@dynamic firstName;
@dynamic lastName;
@dynamic phoneNumber;
@dynamic type;
@dynamic sex;
@dynamic rating;

+ (void)load {
	[self registerSubclass];
}
@end
