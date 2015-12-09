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
#import "THLOnboardingView.h"
#import "THLLoginView.h"

#import "THLFacebookPictureModuleDelegate.h"
#import "THLNumberVerificationModuleDelegate.h"

@interface THLLoginPresenter()
<
THLLoginInteractorDelegate,
THLFacebookPictureModuleDelegate,
THLNumberVerificationModuleDelegate
>
@property (nonatomic, weak) id<THLOnboardingView> onboardingView;
@property (nonatomic, weak) id<THLLoginView> loginView;
@property (nonatomic) BOOL busy;
@property (nonatomic) THLActivityStatus activityStatus;
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

- (void)presentLoginModuleInterfaceWithOnboardingInWindow:(UIWindow *)window {
    [_wireframe presentOnboardingInterfaceInWindow:window];
}

- (void)presentLoginModuleInterfaceOnViewController:(UIViewController *)viewController {
    [_wireframe presentLoginInterfaceOnViewController:viewController];
}

- (void)configureOnboardingView:(id<THLOnboardingView>)onboardingView {
    _onboardingView = onboardingView;
    
    WEAKSELF();
    STRONGSELF();
	RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
		[WSELF handleUserLoginAction];
		return [RACSignal empty];
	}];
    RACCommand *skipCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleSkipAction];
        return [RACSignal empty];
    }];
    [RACObserve(self, activityStatus) subscribeNext:^(NSNumber *x) {
        [SSELF.onboardingView setShowActivityIndicator:x];
    }];
    
    [_onboardingView setSkipCommand:skipCommand];
    [_onboardingView setLoginText:NSLocalizedString(@"Login with Facebook", @"Facebook login")];
	[_onboardingView setLoginCommand:loginCommand];
}

- (void)configureLoginView:(id<THLLoginView>)loginView {
    _loginView = loginView;
    
    WEAKSELF();
    STRONGSELF();
    RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
        [WSELF handleUserLoginAction];
        return [RACSignal empty];
    }];
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF dismissInterface];
        return [RACSignal empty];
    }];
    [RACObserve(self, activityStatus) subscribeNext:^(NSNumber *x) {
        [SSELF.onboardingView setShowActivityIndicator:x];
    }];
    [_loginView setDismissCommand:dismissCommand];
    [_loginView setLoginCommand:loginCommand];
}

#pragma mark - Action Handling
- (void)handleError:(NSError *)error {
    self.activityStatus = THLActivityStatusError;
	DLog(@"Error: %@", error);
	[self reroute];
}

- (void)handleSkipAction {
    [self.moduleDelegate loginModule:self didLoginUser:nil];
}

- (void)handleUserLoginAction {
	[_interactor login];
}

- (void)handleLoginSuccess {
	[self reroute];
}

- (void)handleAddFacebookInformationSuccess {
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
    if ([_interactor shouldAddFacebookInformation]) {
        self.activityStatus = THLActivityStatusInProgress;
        [_interactor addFacebookInformation];
    }
    else if ([_interactor shouldVerifyPhoneNumber]) {
        self.activityStatus = THLActivityStatusNone;
		[self routeToNumberVerificationInterface];
	} else if ([_interactor shouldPickProfileImage]) {
        self.activityStatus = THLActivityStatusInProgress;
		[self routeToPickProfilePictureInterface];
	} else {
        self.activityStatus = THLActivityStatusNone;
        if (_onboardingView) {
            [self finishOnboardingInterface];
        } else {
            [_wireframe finishLogin];
        }
	}
}

- (void)routeToNumberVerificationInterface {
	[_wireframe presentNumberVerificationInterface:self];
}

- (void)routeToPickProfilePictureInterface {
	[_wireframe presentFacebookPictureInterface:self];
}

- (void)finishOnboardingInterface {
	[self.moduleDelegate loginModule:self didLoginUser:nil];
}

- (void)dismissInterface {
    [_wireframe dismissInterface];
}

#pragma mark - THLLoginInteractorDelegate
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(NSError *)error {
	if (error) {
		[self handleError:error];
	} else {
		[self handleLoginSuccess];
	}
}

- (void)interactor:(THLLoginInteractor *)interactor didAddFacebookInformation:(NSError *)error {
    if (error) {
        [self handleError:error];
    } else {
        [self handleAddFacebookInformationSuccess];
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

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}
@end
