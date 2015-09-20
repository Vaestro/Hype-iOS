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

//@class THLLoginInteractor;
//@class THLLoginPresenter;

@interface THLLoginWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLLoginInteractor *interactor;
@property (nonatomic, strong) THLLoginPresenter *presenter;
@property (nonatomic, strong) THLLoginViewController *view;

@end
@implementation THLLoginWireframe

- (instancetype)initWithLoginService:(id<THLUserLoginServiceInterface>)loginService {
	if (self = [super init]) {
		_loginService = loginService;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_interactor = [[THLLoginInteractor alloc] initWithLoginService:_loginService];
	_presenter = [[THLLoginPresenter alloc] initWithWireframe:self interactor:_interactor];
	_view = [[THLLoginViewController alloc] initWithNibName:nil bundle:nil];
}

- (id<THLLoginModuleInterface>)moduleInterface {
	return _presenter;
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	_window.rootViewController = _view;
	[_window makeKeyAndVisible];
}
@end
