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
#import "PFFacebookUtils.h"
#import "FBSDKCoreKit.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


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

+ (void)handleInvalidatedSession {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) {
            // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

+ (BFTask *)makeCurrentInstallation {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (![[currentInstallation objectForKey:@"User"] isEqual:[self currentUser]]) {
        [currentInstallation setObject:[self currentUser] forKey:@"User"];
        return [currentInstallation saveInBackground];
    }
    return [BFTask taskWithResult:nil];
}
@end
