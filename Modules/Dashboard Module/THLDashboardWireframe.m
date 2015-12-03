//
//  THLDashboardWireframe.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardWireframe.h"
#import "THLDashboardPresenter.h"
#import "THLDashboardInteractor.h"
#import "THLDashboardDataManager.h"
#import "THLDashboardViewController.h"

@interface THLDashboardWireframe()
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, strong) THLDashboardInteractor *interactor;
@property (nonatomic, strong) THLDashboardDataManager *dataManager;
@property (nonatomic, strong) THLDashboardViewController *view;
@property (nonatomic, strong) THLDashboardPresenter *presenter;
@end

@implementation THLDashboardWireframe
- (instancetype)initWithGuestlistService:(id<THLGuestlistServiceInterface>)guestlistService
                           entityMappper:(THLEntityMapper *)entityMapper
                   viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
                               dataStore:(THLDataStore *)dataStore {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        _viewDataSourceFactory = viewDataSourceFactory;
        _dataStore = dataStore;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLDashboardDataManager alloc] initWithGuestlistService:_guestlistService
                                                                entityMappper:_entityMapper
                                                             dataStore:_dataStore];
    _interactor = [[THLDashboardInteractor alloc] initWithDataManager:_dataManager
                                                viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLDashboardViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLDashboardPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInterfaceInViewController:(UIViewController *)viewController {
    _viewController = viewController;
    [_presenter configureView:_view];
    [_viewController addChildViewController:_view];
    _view.view.bounds = _viewController.view.bounds;
    [_viewController.view addSubview:_view.view];
    [_view didMoveToParentViewController:_viewController];
}

- (id<THLDashboardModuleInterface>)moduleInterface {
    return _presenter;
}

@end
