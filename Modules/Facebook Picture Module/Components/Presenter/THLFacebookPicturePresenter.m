//
//  THLFacebookPicturePresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLFacebookPicturePresenter.h"
#import "THLFacebookPictureWireframe.h"
#import "THLFacebookPictureInteractor.h"

@interface THLFacebookPicturePresenter()<THLFacebookPictureInteractorDelegate>
@end

@implementation THLFacebookPicturePresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLFacebookPictureWireframe *)wireframe
					   interactor:(THLFacebookPictureInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

- (void)presentFacebookPictureInterfaceInWindow:(UIWindow *)window {
	[_interactor getProfileImage];
}

#pragma mark - THLFacebookPictureInteractorDelegate
- (void)interactor:(THLFacebookPictureInteractor *)interactor didGetProfileImage:(UIImage *)image error:(NSError *)error {
	[self.moduleDelegate facebookPictureModule:self didSelectImage:image];
}
@end
