//
//  THLPerkWireframe.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkWireframe.h"
#import "THLPerkInteractor.h"
#import "THLPerkDataManager.h"
#import "THLPerkPresenter.h"
#import "THLPerksViewController.h"


@interface THLPerkWireframe()
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) THLPerkInteractor *interactor;
@property (nonatomic, strong) THLPerkDataManager *dataManager;
@property (nonatomic, strong) THLPerksViewController *view;
@property (nonatomic, strong) THLPerkPresenter *presenter;
@end


@implementation THLPerkWireframe
- (instancetype) initWithDataStore:(THLDataStore *)dataStore entityMapper:(THLEntityMapper *)entityMapper perkItemStoreService:(id<THLPerkItemStoreServiceInterface>)perkItemStoreService viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _perkItemStoreService = perkItemStoreService;
        _viewDataSourceFactory = viewDataSourceFactory;
        [self buildModule];
    }
    return self;
}


- (void)buildModule {
    _dataManager = [[THLPerkDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper perkService:_perkItemStoreService];
    _interactor = [[THLPerkInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLPerksViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLPerkPresenter alloc] initWithWireframe:self interactor:_interactor];
}

#pragma mark - Interface
- (id<THLPerkModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)presentPerkInterfaceInWindow:(UIWindow *)window {
    _window = window;
    [_presenter configureView:_view];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:_view];
    
    [_window.rootViewController presentViewController:navVC animated:YES completion:NULL];
}

- (void)dismissInterface {
    [_view.navigationController dismissViewControllerAnimated:YES completion:^{
        [_presenter.moduleDelegate dismissPerkWireframe];
    }];
}


@end

