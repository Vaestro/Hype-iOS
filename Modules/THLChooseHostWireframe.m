//
//  THLChooseHostWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 9/23/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLChooseHostWireframe.h"
#import "THLChooseHostDataManager.h"
#import "THLChooseHostInteractor.h"
#import "THLChooseHostPresenter.h"
#import "THLChooseHostViewController.h"

@interface THLChooseHostWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLChooseHostPresenter *presenter;
@property (nonatomic, strong) THLChooseHostInteractor *interactor;
@property (nonatomic, strong) THLChooseHostViewController *view;
@property (nonatomic, strong) THLChooseHostDataManager *dataManager;
@end

@implementation THLChooseHostWireframe
- (instancetype)initWithEventService:(THLParseEventService *)eventService {
	if (self = [super init]) {
		_eventService = eventService;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLChooseHostDataManager alloc] initWithEventService:_eventService];
	_interactor = [[THLChooseHostInteractor alloc] initWithDataManager:_dataManager];
	_presenter = [[THLChooseHostPresenter alloc] initWithWireframe:self interactor:_interactor];
	_view = [[THLChooseHostViewController alloc] initWithNibName:nil bundle:nil];
}


- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	[_window.rootViewController presentViewController:_view animated:YES completion:NULL];
}

- (void)dismissInterface {
	[_view dismissViewControllerAnimated:YES completion:NULL];
}

- (id<THLChooseHostModuleInterface>)moduleInterface {
	return _presenter;
}
@end
