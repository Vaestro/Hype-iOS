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
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
					 entityMapper:(THLEntityMapper *)entityMapper
					 eventService:(id<THLEventServiceInterface>)eventService
			viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
	if (self = [super init]) {
		_dataStore = dataStore;
		_entityMapper = entityMapper;
		_eventService = eventService;
		_viewDataSourceFactory = viewDataSourceFactory;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLEventDiscoveryDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper eventService:_eventService];
	_interactor = [[THLEventDiscoveryInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
	_view = [[THLEventDiscoveryViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLEventDiscoveryPresenter alloc] initWithWireframe:self interactor:_interactor];
}

#pragma mark - Interface
- (id<THLEventDiscoveryModuleInterface>)moduleInterface {
	return _presenter;
}

- (void)presentInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	_window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_view];
	[_window makeKeyAndVisible];
}
@end
