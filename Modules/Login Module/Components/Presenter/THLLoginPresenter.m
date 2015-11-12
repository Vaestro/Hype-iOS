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
@property (nonatomic, weak) id<THLLoginView> view;
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

- (void)presentLoginModuleInterfaceInWindow:(UIWindow *)window {
	[_wireframe presentInterfaceInWindow:window];
}

- (void)configureView:(id<THLLoginView>)view {
    _view = view;
    
    WEAKSELF();
	RACCommand *loginCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self.interactor, shouldLogin) signalBlock:^RACSignal *(id input) {
		[WSELF handleUserLoginAction];
		return [RACSignal empty];
	}];
    [RACObserve(self, activityStatus) subscribeNext:^(NSNumber *x) {
        [WSELF.view setShowActivityIndicator:x];
    }];
    
    [_view setLoginText:NSLocalizedString(@"Login with Facebook", @"Facebook login")];
	[_view setLoginCommand:loginCommand];
}

#pragma mark - Action Handling
- (void)handleError:(NSError *)error {
    self.activityStatus = THLActivityStatusError;
	DLog(@"Error: %@", error);
	[self reroute];
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
