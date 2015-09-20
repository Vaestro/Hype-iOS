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

@interface THLLoginPresenter()<THLLoginInteractorDelegate>
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

	RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		[self handleLoginAction];
		return [RACSignal empty];
	}];

	[view setLoginCommand:loginCommand];
}

#pragma mark - Logic
- (void)handleLoginAction {
	[_interactor login];
}

- (void)handleLoginError:(NSError *)error {
	DLog(@"Failed to login: %@", error);
}

- (void)handleLoginSuccess:(THLUser *)user {
	[self.moduleDelegate loginModule:self didLoginUser:user];
}

#pragma mark - THLLoginInteractorDelegate
- (void)interactor:(THLLoginInteractor *)interactor didLoginUser:(THLUser *)user error:(NSError *)error {
	if (error) {
		[self handleLoginError:error];
	} else {
		[self handleLoginSuccess:user];
	}
}
@end
