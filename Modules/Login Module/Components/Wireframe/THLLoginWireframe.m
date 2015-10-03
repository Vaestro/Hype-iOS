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
#import "THLLoginViewController.h"
#import "THLLoginDataManager.h"

#import "THLNumberVerificationModuleInterface.h"
#import "THLFacebookPictureModuleInterface.h"

@interface THLLoginWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLLoginDataManager *dataManager;
@property (nonatomic, strong) THLLoginInteractor *interactor;
@property (nonatomic, strong) THLLoginPresenter *presenter;
@property (nonatomic, strong) THLLoginViewController *view;
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
	_view = [[THLLoginViewController alloc] initWithNibName:nil bundle:nil];
}

#pragma mark - Interface
- (id<THLLoginModuleInterface>)moduleInterface {
	return _presenter;
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	_window.rootViewController = _view;
	[_window makeKeyAndVisible];
}

- (void)presentNumberVerificationInterface:(id<THLNumberVerificationModuleDelegate>)interfaceDelegate {
	[_numberVerificationModule setModuleDelegate:interfaceDelegate];
	[_numberVerificationModule presentNumberVerificationInterfaceInWindow:_window];
}

- (void)presentFacebookPictureInterface:(id<THLFacebookPictureModuleDelegate>)interfaceDelegate {
	[_facebookPictureModule setModuleDelegate:interfaceDelegate];
	[_facebookPictureModule presentFacebookPictureInterfaceInWindow:_window];
}

@end
