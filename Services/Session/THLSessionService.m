//
//  THLSessionService.m
//  Hypelist2point0
//
//  Created by Paul Dariye on 10/14/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLSessionService.h"
#import "THLUser.h"
#import "PFFacebookUtils.h"
#import "FBSDKCoreKit.h"

@implementation THLSessionService : NSObject


//- (BFTask *)checkUserSessionValidity {
//    return [self sendRequest];
//}

//- (BFTask *)sendRequest {
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
//
//    BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
//
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//
//        if (!error) {
//            [completionSource setResult:result];
//        }else if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
//            NSLog(@"facebook session invalidated");
//            [PFFacebookUtils unlinkUserInBackground:[THLUser currentUser]];
//        }else {
//            NSLog(@"Error: %@", error);
//            [completionSource setError:error];
//        }
//
//    }];
//    return completionSource.task;
//}

- (BOOL)isUserCached {
    return [THLUser currentUser] || [self isFacebookLinkedWithUser];
}

- (BOOL)isFacebookLinkedWithUser {
    return [PFFacebookUtils isLinkedWithUser:[THLUser currentUser]];
}

- (void)logUserOut{
    [THLUser logOut];
}

- (BFTask *)makeCurrentInstallation {
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    if (![[currentInstallation objectForKey:@"User"] isEqual:[THLUser currentUser]]) {
        [currentInstallation setObject:[THLUser currentUser] forKey:@"User"];
        return [currentInstallation saveInBackground];
    }
    return [BFTask taskWithResult:nil];
}

@end
