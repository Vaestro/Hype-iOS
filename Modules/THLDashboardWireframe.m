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
                           entityMappper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _guestlistService = guestlistService;
        _entityMapper = entityMapper;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLDashboardDataManager alloc] initWithGuestlistService:_guestlistService
                                                                entityMappper:_entityMapper];
    _interactor = [[THLDashboardInteractor alloc] initWithDataManager:_dataManager];
    _view = [[THLDashboardViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLDashboardPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInterfaceInViewController:(UIViewController *)viewController {
    _viewController = viewController;
    [_presenter configureView:_view];
    [_viewController.view addSubview:_view.view];
}

- (id<THLDashboardModuleInterface>)moduleInterface {
    return _presenter;
}

@end
