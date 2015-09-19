//
//  THLFacebookProfilePictureURLFetchService.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLFacebookProfilePictureURLFetchService.h"
#import "THLFacebookModule.h"

@implementation THLFacebookProfilePictureURLFetchService
- (BFTask *)fetchCurrentProfilePictureURL {
	return [[THLFacebookProfilePictureFactory taskForCurrentProfilePicture] continueWithSuccessBlock:^id(BFTask *task) {
		NSArray *pictureNodes = [self pictureNodes:task.result];
		NSString *pictureURL = [self pictureURL:[pictureNodes first]];
		if (pictureURL) {
			return pictureURL;
		} else {
			return [NSError errorWithDomain:@"com.Hypelist2point0.Services.Fetching.FacebookImageFetching" code:1 userInfo:nil];
		}
	}];
}

- (NSArray *)pictureNodes:(NSDictionary *)result {
	return result[@"data"];
}

- (NSString *)pictureURL:(NSDictionary *)pictureNode {
	return pictureNode[@"url"];
}
@end
