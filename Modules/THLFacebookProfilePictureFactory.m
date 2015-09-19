//
//  THLFacebookProfilePictureFactory.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLFacebookProfilePictureFactory.h"
#import "BFTask.h"
#import "FBSDKCoreKit.h"

@implementation THLFacebookProfilePictureFactory
+ (BFTask *)taskForCurrentProfilePicture {
	// For more complex open graph stories, use `FBSDKShareAPI`
	// with `FBSDKShareOpenGraphContent`
	/* make the API call */
	FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
								  initWithGraphPath:@"/me/picture"
								  parameters:nil
								  HTTPMethod:@"GET"];
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
	[request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
										  id result,
										  NSError *error) {
		if (error) {
			[completionSource setError:error];
		} else {
			[completionSource setResult:result];
		}
	}];
	return completionSource.task;
}

@end
