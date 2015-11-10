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
    return [PFFacebookUtils logInInBackgroundWithReadPermissions:[self facebookLoginPermissions]];
}

//TODO:Add User Location and Birthday after getting approval from Facebook
//           @"user_location",
//			 @"user_birthday",
- (NSArray *)facebookLoginPermissions {
	return @[@"public_profile",
             @"user_photos",
             @"email",
			 @"user_friends"];
}

- (BFTask *)getFacebookUserDictionary {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:@{@"fields": @"id,first_name,last_name,name,gender,verified,email"}
                                  HTTPMethod:@"GET"];
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [completionSource setResult:result];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

@end
