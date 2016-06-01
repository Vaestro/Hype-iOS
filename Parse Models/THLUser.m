//
//  THLUser.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/21/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//
#import "THLUser.h"
#import <objc/runtime.h>
#import "APContact.h"
#import "APName.h"
#import "APPhone.h"
#import "NBPhoneNumberUtil.h"


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
@dynamic stripeCustomerId;

+ (void)load {
	[self registerSubclass];
}

- (NSString *)fullName {
	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *)intPhoneNumberFormat {
    NBPhoneNumberUtil *phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError *anError = nil;
    NBPhoneNumber *myNumber = [phoneUtil parse:self.phoneNumber
                                 defaultRegion:@"US" error:&anError];
    
    return [NSString stringWithFormat:@"%@", [phoneUtil format:myNumber
                                                  numberFormat:NBEPhoneNumberFormatE164
                                                         error:&anError]];
}
@end
