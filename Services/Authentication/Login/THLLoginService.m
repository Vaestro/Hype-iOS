//
//  THLLoginService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/26/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLLoginService.h"
#import "PFFacebookUtils.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SDWebImageManager.h"

@implementation THLLoginService
- (BFTask *)login {
	return [self loginWithFacebook];
}

- (BFTask *)loginWithFacebook {
	return [PFFacebookUtils logInInBackgroundWithReadPermissions:[self facebookLoginPermissions]];
}

- (NSArray *)facebookLoginPermissions {
	return @[@"user_location",
			 @"user_photos",
			 @"user_birthday",
			 @"email",
			 @"public_profile",
			 @"user_friends"];
}

- (BFTask *)getFacebookUserDictionary {
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me?fields=id,age_range,birthday,currency,first_name,gender,last_name,location,name_format,name,verified,cover,email" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (error) {
                 [completionSource setError:error];
             } else {
                 [completionSource setResult:result];
             }
         }];
    } else {
        [completionSource setError:[NSError errorWithDomain:@"com.THLHypeListFramework.Facebook.getUserDictionary: FBSDKAccessToken not found!" code:0 userInfo:nil]];
    }
    return completionSource.task;
}

@end
