//
//  THLEventHostingWireframe.m
//  TheHypelist
//
//  Created by Edgar Li on 11/9/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLEventHostingWireframe.h"

#import "THLEventHostingPresenter.h"
#import "THLEventHostingInteractor.h"
#import "THLEventHostingDataManager.h"
#import "THLEventHostingViewController.h"
#import "THLEventNavigationController.h"
#import "THLVenueDetailsView.h"

@interface THLEventHostingWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLEventHostingPresenter *presenter;
@property (nonatomic, strong) THLEventHostingInteractor *interactor;
@property (nonatomic, strong) THLEventHostingDataManager *dataManager;
@property (nonatomic, strong) THLEventHostingViewController *view;
@end

@implementation THLEventHostingWireframe
- (instancetype)initWithDataStore:(THLDataStore *)dataStore
                 guestlistService:(id<THLGuestlistServiceInterface>)guestlistService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory
                    entityMappper:(THLEntityMapper *)entityMapper {
    if (self = [super init]) {
        _dataStore = dataStore;
        _guestlistService = guestlistService;
        _viewDataSourceFactory = viewDataSourceFactory;
        _entityMapper = entityMapper;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLEventHostingDataManager alloc] initWithDataStore:_dataStore
                                                        guestlistService:_guestlistService
                                                                entityMapper:_entityMapper];
    _interactor = [[THLEventHostingInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLEventHostingViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLEventHostingPresenter alloc] initWithWireframe:self interactor:_interactor];
}

- (void)presentInterfaceInWindow:(UIWindow *)window {
    _window = window;
    [_presenter configureView:_view];
    THLEventNavigationController *eventNavController = [[THLEventNavigationController alloc] initWithRootViewController:_view];
    [_presenter configureNavigationBar:eventNavController.navigationBar];
    THLVenueDetailsView *venueDetailsView = [[THLVenueDetailsView alloc] init];
    [_presenter configureVenueDetailsView:venueDetailsView];
    [_window.rootViewController presentViewController:eventNavController animated:YES completion:NULL];
}

- (void)dismissInterface {
    [_view.navigationController dismissViewControllerAnimated:YES completion:^{
        [_presenter.moduleDelegate dismissEventHostingWireframe];
    }];
    
}

- (id<THLEventHostingModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
