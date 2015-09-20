//
//  THLEventDiscoveryWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/23/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDiscoveryWireframe.h"

#import "THLEventDiscoveryInteractor.h"
#import "THLEventDiscoveryDataManager.h"
#import "THLEventDiscoveryPresenter.h"
#import "THLEventDiscoveryViewController.h"

@interface THLEventDiscoveryWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLEventDiscoveryInteractor *interactor;
@property (nonatomic, strong) THLEventDiscoveryDataManager *dataManager;
@property (nonatomic, strong) THLEventDiscoveryViewController *view;
@property (nonatomic, strong) THLEventDiscoveryPresenter *presenter;
@end

@implementation THLEventDiscoveryWireframe
- (instancetype)initWithDataStore:(THLEventDataStore *)dataStore
					 fetchService:(id<THLEventFetchServiceInterface>)fetchService
				 extensionManager:(THLExtensionManager *)extensionManager {
	if (self = [super init]) {
		_eventDataStore = dataStore;
		_eventFetchService = fetchService;
		_extensionManager = extensionManager;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLEventDiscoveryDataManager alloc] initWithDataStore:_eventDataStore fetchService:_eventFetchService];
	_interactor = [[THLEventDiscoveryInteractor alloc] initWithDataManager:_dataManager extensionManager:_extensionManager];
	_view = [[THLEventDiscoveryViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLEventDiscoveryPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_view];
	[_window makeKeyAndVisible];
}

- (id<THLEventDiscoveryModuleInterface>)moduleInterface {
	return _presenter;
}
@end
