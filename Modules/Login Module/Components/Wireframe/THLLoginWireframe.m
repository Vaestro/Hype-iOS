//
//  THLLoginWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/16/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLLoginWireframe.h"
#import "THLLoginInteractor.h"
#import "THLLoginPresenter.h"
#import "THLLoginDataManager.h"
#import "THLOnboardingViewController.h"
#import "THLLoginViewController.h"
#import "THLNumberVerificationModuleInterface.h"
#import "THLFacebookPictureModuleInterface.h"
#import "THLUser.h"
#import "Intercom/intercom.h"


@interface THLLoginWireframe()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UIViewController *topViewController;

@property (nonatomic, strong) THLLoginDataManager *dataManager;
@property (nonatomic, strong) THLLoginInteractor *interactor;
@property (nonatomic, strong) THLLoginPresenter *presenter;
@property (nonatomic, strong) THLOnboardingViewController *onboardingView;
@property (nonatomic, strong) THLLoginViewController *loginView;
@property (nonatomic, strong) UINavigationController *navigationController;
@end

@implementation THLLoginWireframe
- (instancetype)initWithLoginService:(id<THLLoginServiceInterface>)loginService
						 userManager:(THLUserManager *)userManager
			numberVerificationModule:(id<THLNumberVerificationModuleInterface>)numberVerificationModule
			   facebookPictureModule:(id<THLFacebookPictureModuleInterface>)facebookPictureModule {
	if (self = [super init]) {
		_loginService = loginService;
		_userManager = userManager;
		_numberVerificationModule = numberVerificationModule;
		_facebookPictureModule = facebookPictureModule;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLLoginDataManager alloc] initWithLoginService:_loginService];
	_interactor = [[THLLoginInteractor alloc] initWithDataManager:_dataManager userManager:_userManager];
	_presenter = [[THLLoginPresenter alloc] initWithWireframe:self interactor:_interactor];
	_onboardingView = [[THLOnboardingViewController alloc] initWithNibName:nil bundle:nil];
    _loginView = [[THLLoginViewController alloc] initWithNibName:nil bundle:nil];
}

#pragma mark - Interface
- (id<THLLoginModuleInterface>)moduleInterface {
	return _presenter;
}

- (void)presentLoginInterfaceOnNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    [_presenter configureLoginView:_loginView];
    [_navigationController addChildViewController:_loginView];
}


- (void)presentOnboardingInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureOnboardingView:_onboardingView];
    UIViewController *baseViewController = [UIViewController new];
    _window.rootViewController = baseViewController;
	[_window makeKeyAndVisible];
    [baseViewController presentViewController:_onboardingView animated:NO completion:nil];
}

- (void)presentUserVerificationInterfaceInWindow:(UIWindow *)window {
    _window = window;
    [_interactor setUser:[THLUser currentUser]];
    [_presenter configureOnboardingView:_onboardingView];
    _topViewController = _onboardingView;
    UIViewController *baseViewController = [UIViewController new];
    _window.rootViewController = baseViewController;
    [baseViewController presentViewController:_onboardingView animated:NO completion:nil];
    [_window makeKeyAndVisible];
    [_presenter reroute];
}


- (void)presentLoginInterfaceOnViewController:(UIViewController *)viewController {
    _viewController = viewController;
    [_presenter configureLoginView:_loginView];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_loginView];
    [_viewController presentViewController:navigationController animated:YES completion:NULL];
    _topViewController = _loginView;

}

- (void)dismissInterface {
    [_loginView.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)finishLogin {
    WEAKSELF();
    [_loginView.navigationController dismissViewControllerAnimated:YES completion:^{
        [WSELF.presenter.moduleDelegate loginModule:WSELF.presenter didLoginUser:nil];
    }];
}

- (void)finishOnboarding {
    WEAKSELF();
    [_onboardingView dismissViewControllerAnimated:NO completion:^{
        [WSELF.presenter.moduleDelegate loginModule:WSELF.presenter didLoginUser:nil];
    }];

}

- (void)skipLogin {
    WEAKSELF();
    [_onboardingView dismissViewControllerAnimated:NO completion:^{
        [WSELF.presenter.moduleDelegate skipUserLogin];
    }];
}

- (void)presentNumberVerificationInterface:(id<THLNumberVerificationModuleDelegate>)interfaceDelegate {
	[_numberVerificationModule setModuleDelegate:interfaceDelegate];
	[_numberVerificationModule presentNumberVerificationInterfaceInViewController:_topViewController];
}

- (void)presentFacebookPictureInterface:(id<THLFacebookPictureModuleDelegate>)interfaceDelegate {
	[_facebookPictureModule setModuleDelegate:interfaceDelegate];
	[_facebookPictureModule presentFacebookPictureInterfaceInWindow:_window];
}

- (void)dealloc {
    DLog(@"Destroyed %@", self);
}

@end
