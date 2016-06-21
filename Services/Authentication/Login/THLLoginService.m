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
#import "THLUser.h"

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
                                  parameters:@{@"fields": @"id,first_name,last_name,name,gender,verified,email, picture.type(large)"}
                                  HTTPMethod:@"GET"];
    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [completionSource setResult:result];
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            [completionSource setError:error];
        }
    }];
    return completionSource.task;
}

- (void)saveFacebookUserInformation {
    WEAKSELF();
    [[self getFacebookUserDictionary] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        NSDictionary *userDictionary = task.result;
        THLUser *currentUser = [THLUser currentUser];
        currentUser.fbId = userDictionary[@"id"];
        currentUser.firstName = userDictionary[@"first_name"];
        currentUser.lastName = userDictionary[@"last_name"];
        currentUser.fbEmail = userDictionary[@"email"];
        currentUser.sex = ([userDictionary[@"gender"] isEqualToString:@"male"]) ? THLSexMale : THLSexFemale;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:userDictionary[@"picture"][@"data"][@"url"]]];
        PFFile *profilePicture = [PFFile fileWithName:@"profile_picture.png" data:imageData];
        [profilePicture save];
        currentUser.image = profilePicture;
        //TODO: Add Location and Birthday upon Facebook Approval
        //        [WSELF user].fbBirthday = [[[YLMoment alloc] initWithDateAsString:userDictionary[@"birthday"]] date];
        //        [WSELF user].location = userDictionary[@"location"];
        if (userDictionary[@"verified"]) {
            currentUser.fbVerified = TRUE;
        }
        else {
            currentUser.fbVerified = FALSE;
        }
        currentUser.type = THLUserTypeGuest;
        [[currentUser saveInBackground] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask<NSNumber *> *saveTask) {
            [WSELF.delegate loginServiceDidSaveUserFacebookInformation];
            return nil;
        }];
        return task;
    }];
    

}

- (void)createMixpanelAlias {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    THLUser *user = [THLUser currentUser];
    // mixpanel identify: must be called before
    // people properties can be set
    [mixpanel createAlias:user.objectId
            forDistinctID:mixpanel.distinctId];
    // You must call identify if you haven't already
    // (e.g., when your app launches).
    [mixpanel identify:mixpanel.distinctId];
    
    NSString *userSex;
    if (user.sex == THLSexMale) {
        userSex = @"Male";
    } else if (user.sex == THLSexFemale) {
        userSex = @"Female";
    }
    [mixpanel registerSuperPropertiesOnce:@{@"Gender": userSex}];
    [mixpanel.people set:@{@"$first_name": user.firstName,
                           @"$last_name": user.lastName,
                           @"$email": user.email,
                           @"$phone": user.phoneNumber,
                           @"$created": user.createdAt,
                           @"Gender": userSex
                           }];
}

- (void)createMixpanelPeopleProfile {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    THLUser *user = [THLUser currentUser];
    
    NSString *userSex;
    if (user.sex == THLSexMale) {
        userSex = @"Male";
    } else if (user.sex == THLSexFemale) {
        userSex = @"Female";
    }
    [mixpanel registerSuperPropertiesOnce:@{@"Gender": userSex}];
    [mixpanel.people set:@{@"$first_name": user.firstName,
                           @"$last_name": user.lastName,
                           @"$email": user.email,
                           @"$phone": user.phoneNumber,
                           @"$created": user.createdAt,
                           @"Gender": userSex
                           }];
}

- (BOOL)shouldLogin {
    return [THLUser currentUser] == nil;
}

- (BOOL)shouldAddFacebookInformation {
    return [THLUser currentUser].fbId == nil;
}

- (BOOL)shouldVerifyPhoneNumber {
    return [THLUser currentUser].phoneNumber == nil || [[THLUser currentUser].phoneNumber isEqualToString:@""];
}

- (BOOL)shouldVerifyEmail {
    return [THLUser currentUser].email == nil || [[THLUser currentUser].email isEqualToString:@""];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
