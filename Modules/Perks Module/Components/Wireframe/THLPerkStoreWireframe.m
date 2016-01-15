//
//  THLPerkStoreWireframe.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/28/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkStoreWireframe.h"
#import "THLPerkStoreInteractor.h"
#import "THLPerkStoreDataManager.h"
#import "THLPerkStorePresenter.h"
#import "THLPerkStoreViewController.h"


@interface THLPerkStoreWireframe()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) THLPerkStoreInteractor *interactor;
@property (nonatomic, strong) THLPerkStoreDataManager *dataManager;
@property (nonatomic, strong) THLPerkStoreViewController *view;
@property (nonatomic, strong) THLPerkStorePresenter *presenter;
@end


@implementation THLPerkStoreWireframe

- (instancetype)initWithDataStore:(THLDataStore *)dataStore entityMapper:(THLEntityMapper *)entityMapper perkStoreItemService:(id<THLPerkStoreItemServiceInterface>)perkStoreItemService viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _perkStoreItemService = perkStoreItemService;
        _viewDataSourceFactory = viewDataSourceFactory;
        [self buildModule];
    }
    return self;

}

- (void)buildModule {
    _dataManager = [[THLPerkStoreDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper perkService:_perkStoreItemService];
    _interactor = [[THLPerkStoreInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
    _view = [[THLPerkStoreViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLPerkStorePresenter alloc] initWithWireframe:self interactor:_interactor];
}

#pragma mark - Interface
- (id<THLPerkStoreModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)presentPerkStoreInterfaceInWindow:(UIWindow *)window {
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

