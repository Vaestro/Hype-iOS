//
//  THLLoginPresenter.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginPresenter.h"
#import "THLLoginInteractor.h"
#import "THLLoginWireframe.h"
#import "THLLoginView.h"

#import "THLFacebookPictureModuleDelegate.h"
#import "THLNumberVerificationModuleDelegate.h"

@interface THLLoginPresenter()
<
THLLoginInteractorDelegate,
THLFacebookPictureModuleDelegate,
THLNumberVerificationModuleDelegate
>
@property (nonatomic) BOOL busy;
@end

@implementation THLLoginPresenter
@synthesize moduleDelegate;

#pragma mark - Interface
- (instancetype)initWithWireframe:(THLLoginWireframe *)wireframe
					   interactor:(THLLoginInteractor *)interactor {
	if (self = [super init]) {
		_wireframe = wireframe;
		_interactor = interactor;
		_interactor.delegate = self;
	}
	return self;
}

- (void)presentLoginModuleInterfaceInWindow:(UIWindow *)window {
	[_wireframe presentInterfaceInWindow:window];
}

- (void)configureView:(id<THLLoginView>)view {
	[view setLoginText:NSLocalizedString(@"Login with Facebook", @"Facebook login")];

	RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
		[self handleUserLoginAction];
		return [RACSignal empty];

	}];

	[view setLoginCommand:loginCommand];
}

#pragma mark - Action Handling
- (void)handleError:(NSError *)error {
	DLog(@"Error: %@", error);
	[self reroute];
}

- (void)handleUserLoginAction {
	[_interactor login];
}

- (void)handleLoginSuccess {
	[self reroute];
}

- (void)handleAddVerifiedNumberSuccess {
	[self reroute];
}

- (void)handleAddProfilePictureSuccess {
	[self reroute];
}


#pragma mark - Routing
- (void)reroute {
	if ([_interactor shouldVerifyPhoneNumber]) {
		[self routeToNumberVerificationInterface];
	} else if ([_interactor shouldPickProfileImage]) {
		[self routeToPickProfilePictureInterface];
	} else {
		[self finishLoginInterface];
	}
}

- (void)routeToNumberVerificationInterface {
	[_wireframe presentNumberVerificationInterface:self];
}

- (void)routeToPickProfilePictureInterface {
	[_wireframe presentFacebookPictureInterface:self];
}

- (void)finishLoginInterface {
	[self.moduleDelegate loginModule:self didLoginUser:nil];
}

#pragma mark - THLLoginInteractorDelegate
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self handleLoginSuccess];
	}
}

- (void)interactor:(THLLoginInteractor *)interactor didAddVerifiedPhoneNumber:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self handleAddVerifiedNumberSuccess];
	}
}

- (void)interactor:(THLLoginInteractor *)interactor didAddProfileImage:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self handleAddProfilePictureSuccess];
	}
}

#pragma mark - THLFacebookPictureModuleDelegate
- (void)facebookPictureModule:(id<THLFacebookPictureModuleInterface>)module didSelectImage:(UIImage *)image {
	[_interactor addProfileImage:image];
}

#pragma mark - THLNumberVerificationModuleDelegate
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didVerifyNumber:(NSString *)number {
	[_interactor addVerifiedPhoneNumber:number];
}

- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didFailToVerifyNumber:(NSError *)error {
	[self handleError:error];
}

@end
