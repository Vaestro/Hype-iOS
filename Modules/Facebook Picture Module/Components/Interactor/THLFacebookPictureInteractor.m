//
//  THLFacebookPictureInteractor.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLFacebookPictureInteractor.h"
#import "THLFacebookProfilePictureURLFetchService.h"
#import <SDWebImage/SDWebImageManager.h>

@interface THLFacebookPictureInteractor()

@end

@implementation THLFacebookPictureInteractor
- (instancetype)initWithFetchService:(THLFacebookProfilePictureURLFetchService *)service {
	if (self = [super init]) {
		_fetchService = service;
	}
	return self;
}

- (void)getProfileImage {
    WEAKSELF();
    STRONGSELF();
	[[self downloadProfileImage] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
		[SSELF.delegate interactor:SSELF didGetProfileImage:task.result error:task.error];
		return nil;
	}];
}

- (BFTask *)fetchProfileImageURL {
	return [_fetchService fetchCurrentProfilePictureURL];
}

- (BFTask *)downloadProfileImage {
    WEAKSELF();
    STRONGSELF();
	return [[self fetchProfileImageURL] continueWithSuccessBlock:^id(BFTask *task) {
		NSString *imageURL = task.result;
		return [SSELF downloadImageAtURL:[NSURL URLWithString:imageURL]];
	}];
}

- (BFTask *)downloadImageAtURL:(NSURL *)url {
	BFTaskCompletionSource *completionSource = [BFTaskCompletionSource taskCompletionSource];
	[[SDWebImageManager sharedManager] downloadImageWithURL:url
													options:0
												   progress:^(NSInteger receivedSize, NSInteger expectedSize) {

	} completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
		if (error) {
			[completionSource setError:error];
		} else {
			[completionSource setResult:image];
		}
	}];
	return completionSource.task;
}



@end
