//
//  THLHostDashboardWireframe.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardWireframe.h"
#import "THLHostDashboardPresenter.h"
#import "THLHostDashboardInteractor.h"
#import "THLHostDashboardDataManager.h"
#import "THLHostDashboardViewController.h"

@interface THLHostDashboardWireframe()
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) THLHostDashboardInteractor *interactor;
@property (nonatomic, strong) THLHostDashboardDataManager *dataManager;
@property (nonatomic, strong) THLHostDashboardViewController *view;
@property (nonatomic, strong) THLHostDashboardPresenter *presenter;
@end

@implementation THLHostDashboardWireframe
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
    _dataManager = [[THLHostDashboardDataManager alloc] initWithGuestlistService:_guestlistService
                                                               entityMappper:_entityMapper
                                                                   dataStore:_dataStore];
    _interactor = [[THLHostDashboardInteractor alloc] initWithDataManager:_dataManager
                                                viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLHostDashboardViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLHostDashboardPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInterfaceInNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    [_presenter configureView:_view];
    [_navigationController addChildViewController:_view];
}

- (id<THLHostDashboardModuleInterface>)moduleInterface {
    return _presenter;
}

@end