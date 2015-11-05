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

NSString *const kTHLFBSDKIdKey					= @"id";
NSString *const kTHLFBSDKAboutKey				= @"about";
NSString *const kTHLFBSDKAddressKey				= @"address";
NSString *const kTHLFBSDKAge_rangeKey			= @"age_range";
NSString *const kTHLFBSDKBioKey					= @"bio";
NSString *const kTHLFBSDKBirthdayKey			= @"birthday";
NSString *const kTHLFBSDKCurrencyKey			= @"currency";
NSString *const kTHLFBSDKFirst_nameKey			= @"first_name";
NSString *const kTHLFBSDKGenderKey				= @"gender";
NSString *const kTHLFBSDKLast_nameKey			= @"last_name";
NSString *const kTHLFBSDKHometownKey			= @"hometown";
NSString *const kTHLFBSDKLocationKey			= @"location";
NSString *const kTHLFBSDKLocaleKey				= @"locale";
NSString *const kTHLFBSDKName_formatKey			= @"name_format";
NSString *const kTHLFBSDKFullNameKey			= @"name";
NSString *const kTHLFBSDKRelationship_statusKey = @"relationship_status";
NSString *const kTHLFBSDKVerifiedKey			= @"verified";
NSString *const kTHLFBSDKCoverKey				= @"cover";
NSString *const kTHLFBSDKEmailKey				= @"email";

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
