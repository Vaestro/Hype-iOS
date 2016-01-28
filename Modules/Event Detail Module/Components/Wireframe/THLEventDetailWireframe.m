//
//  THLEventDetailWireframe.m
//  Hypelist2point0
//
//  Created by Phil Meyers IV on 8/25/15.
//  Copyright (c) 2015 Hypelist. All rights reserved.
//

#import "THLEventDetailWireframe.h"
#import "THLEventDetailInteractor.h"
#import "THLEventDetailDataManager.h"
#import "THLEventDetailViewController.h"
#import "THLEventDetailPresenter.h"
#import "THLEventNavigationController.h"

@interface THLEventDetailWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLEventDetailInteractor *interactor;
@property (nonatomic, strong) THLEventDetailDataManager *dataManager;
@property (nonatomic, strong) THLEventDetailViewController *view;
@property (nonatomic, strong) THLEventDetailPresenter *presenter;
@end

@implementation THLEventDetailWireframe
- (instancetype)initWithLocationService:(id<THLLocationServiceInterface>)locationService
                       guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
						  entityMappper:(THLEntityMapper *)entityMapper
                        databaseManager:(THLYapDatabaseManager *)databaseManager {
	if (self = [super init]) {
		_locationService = locationService;
        _guestlistService = guestlistService;
		_entityMapper = entityMapper;
        _databaseManager = databaseManager;
		[self buildModule];
	}
	return self;
}

- (void)buildModule {
	_dataManager = [[THLEventDetailDataManager alloc] initWithLocationService:_locationService
                                                             guestlistService:_guestlistService
																entityMappper:_entityMapper
                                                              databaseManager:_databaseManager];
	_interactor = [[THLEventDetailInteractor alloc] initWithDataManager:_dataManager];
	_view = [[THLEventDetailViewController alloc] initWithNibName:nil bundle:nil];
	_presenter = [[THLEventDetailPresenter alloc] initWithInteractor:_interactor wireframe:self];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
	_window = window;
	[_presenter configureView:_view];
	THLEventNavigationController *eventNavController = [[THLEventNavigationController alloc] initWithRootViewController:_view];
	[_presenter configureNavigationBar:eventNavController.navigationBar];
	[_window.rootViewController presentViewController:eventNavController animated:YES completion:NULL];
}

- (void)dismissInterface {
    [_view.navigationController dismissViewControllerAnimated:YES completion:^{
        [_presenter.moduleDelegate dismissEventDetailWireframe];
    }];
}

- (id<THLEventDetailModuleInterface>)moduleInterface {
	return _presenter;
}

//- (void)dealloc {
//    NSLog(@"Destroyed %@", self);
//}
@end
