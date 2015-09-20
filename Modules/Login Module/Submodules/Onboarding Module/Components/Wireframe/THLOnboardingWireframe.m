//
//  THLOnboardingWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLOnboardingWireframe.h"
#import "THLFacebookPictureModuleInterface.h"
#import "THLNumberVerificationModuleInterface.h"
#import "THLUser.h"
#import "THLOnboardingInteractor.h"


@interface THLOnboardingWireframe()
<
THLNumberVerificationModuleDelegate,
THLFacebookPictureModuleDelegate,
THLOnboardingInteractorDelegate
>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) THLUser *user;

@property (nonatomic, strong) THLOnboardingInteractor *interactor;
@end

@implementation THLOnboardingWireframe
@synthesize moduleDelegate;
- (instancetype)initWithFacebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule
					 numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule {
	if (self = [super init]) {
		_facebookPictureModule = facebookPictureModule;
		_facebookPictureModule.moduleDelegate = self;

		_numberVerificationModule = numberVerificationModule;
		_numberVerificationModule.moduleDelegate = self;

		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_interactor = [[THLOnboardingInteractor alloc] init];
	_interactor.delegate = self;
}

- (void)presentInterfaceForOnboardingUser:(THLUser *)user inWindow:(UIWindow *)window {
	_window = window;
	_user = user;
	[self presentNumberVerificationInterface];
}

- (id<THLOnboardingModuleInterface>)moduleInterface {
	return self;
}

- (void)presentNumberVerificationInterface {
	[_numberVerificationModule presentNumberVerificationInterfaceInWindow:_window];
}

- (void)presentFacebookPictureInterface {
	[_facebookPictureModule presentFacebookPictureInterfaceInWindow:_window];
}

- (void)finishOnboarding {
	[self.moduleDelegate onboardingModule:self didOnboardUser:_user];
}

#pragma mark - THLOnboardingInteractorDelegate
- (void)interactor:(THLOnboardingInteractor *)interactor didUpdateUser:(THLUser *)user withPhoneNumber:(NSString *)phoneNumber error:(NSError*)error {
	if (error) {
		[self presentNumberVerificationInterface];
	} else {
		[self presentFacebookPictureInterface];
	}
}

- (void)interactor:(THLOnboardingInteractor *)interactor didUpdateUser:(THLUser *)user withProfileImage:(UIImage *)profileImage error:(NSError *)error {
	if (error) {
		[self presentFacebookPictureInterface];
	} else {
		[self finishOnboarding];
	}
}

#pragma mark - THLNumberVerificationModuleDelegate
- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didFailToVerifyNumber:(NSError *)error {
	[self presentNumberVerificationInterface];
}

- (void)numberVerificationModule:(id<THLNumberVerificationModuleInterface>)module didVerifyNumber:(NSString *)number {
	[_interactor updateUser:_user withPhoneNumber:number];
}

#pragma mark - THLFacebookPictureModuleDelegate
- (void)facebookPictureModule:(id<THLFacebookPictureModuleInterface>)module didSelectImage:(UIImage *)image {
	[_interactor updateUser:_user withProfileImage:image];
}
@end
