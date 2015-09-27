//
//  THLLoginService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLoginService.h"
#import "PFFacebookUtils.h"

@implementation THLLoginService
- (BFTask *)login {
	return [self loginWithFacebook];
}

- (BFTask *)loginWithFacebook {
	return [PFFacebookUtils logInWithPermissionsInBackground:[self facebookLoginPermissions]];
}

- (NSArray *)facebookLoginPermissions {
	return @[@"user_location",
			 @"user_photos",
			 @"user_birthday",
			 @"email",
			 @"public_profile",
			 @"user_friends"];
}

@end
