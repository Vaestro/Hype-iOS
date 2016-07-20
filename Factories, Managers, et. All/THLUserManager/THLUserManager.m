//
//  THLUserManager.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/29/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLUserManager.h"
#import "THLUser.h"
#import "PFFacebookUtils.h"
#import "FBSDKCoreKit.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation THLUserManager
- (instancetype)init {
	if (self = [super init]) {

	}
	return self;
}

#pragma mark - Properties
+ (THLUser *)currentUser {
	return [THLUser currentUser];
}

+ (BOOL)userLoggedIn {
	return self.currentUser != nil;
}

+ (THLUserType)userType {
    return [self currentUser].type;
}

+ (BOOL)userIsGuest {
    return self.userType == THLUserTypeGuest;
}

+ (BOOL)userIsHost {
    return self.userType == THLUserTypeHost;
}

+ (BOOL)isUserCached {
    return [self currentUser];
}

+ (BOOL)isUserProfileValid {
    if ([[self currentUser].phoneNumber isEqualToString:@""]
        || [[self currentUser].email isEqualToString:@""]
        || [self currentUser].email == nil
        || [self currentUser].phoneNumber == nil) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isFacebookLinkedWithUser {
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id"}];
    __block BOOL isLinked = FALSE;
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // handle successful response
            isLinked = [PFFacebookUtils isLinkedWithUser:[self currentUser]];
        } else if ([[error userInfo][@"error"][@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [PFFacebookUtils unlinkUserInBackground:[PFUser currentUser]];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    return isLinked;
}

+ (void)logUserOut{
    [THLUser logOut];
}

+ (void) logCrashlyticsUser {
    // You can call any combination of these three methods
    [CrashlyticsKit setUserIdentifier:[NSString stringWithFormat:@"%@", [self currentUser].objectId]];
    [CrashlyticsKit setUserEmail:[self currentUser].email];
    [CrashlyticsKit setUserName:[self currentUser].fullName];
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
