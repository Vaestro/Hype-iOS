//
//  THLParseLogin.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLParseLogin.h"
#import "PFFacebookUtils.h"
#import "BFTask.h"



@implementation THLParseLogin
+ (BFTask *)loginWithFacebook {
	return [PFFacebookUtils logInWithPermissionsInBackground:[self facebookLoginPermissions]];
}

+ (NSArray *)facebookLoginPermissions {
	return @[@"user_location",
			 @"user_photos",
			 @"user_birthday",
			 @"email",
			 @"public_profile",
			 @"user_friends"];
}

@end
