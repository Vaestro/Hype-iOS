//
//  THLMessageListWireframe.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListWireframe.h"
#import "THLMessageListDataManager.h"
#import "THLMessageListInteractor.h"
#import "THLMessageListPresenter.h"
#import "THLMessageListViewController.h"

@interface THLMessageListWireframe()
@property (nonatomic, strong) UINavigationController *navigationController;

@property (nonatomic, strong) THLMessageListInteractor *interactor;
@property (nonatomic, strong) THLMessageListDataManager *dataManager;
@property (nonatomic, strong) THLMessageListViewController *view;
@property (nonatomic, strong) THLMessageListPresenter *presenter;
@end

@implementation THLMessageListWireframe

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
    _dataManager = [[THLMessageListDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper eventService:_eventService];
    _interactor = [[THLMessageListInteractor alloc] initWithDataManager:_dataManager];
    _view = [[THLMessageListViewController alloc] initWithNibName:nil bundle:nil];
    _presenter = [[THLMessageListPresenter alloc] initWithInteractor:_interactor wireframe:self];
}

#pragma mark - Interface
- (id<THLMessageListModuleInterface>)moduleInterface {
    return _presenter;
}

- (void)presentInNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    [_presenter configureView:_view];
    [_navigationController addChildViewController:_view];
}

@end
