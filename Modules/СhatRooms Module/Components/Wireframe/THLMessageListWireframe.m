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
#import "THLChatRoomViewController.h"

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
                     messageListService:(id<THLMessageListServiceInterface>)messageListService
            viewDataSourceFactory:(id<THLViewDataSourceFactoryInterface>)viewDataSourceFactory {
    if (self = [super init]) {
        _dataStore = dataStore;
        _entityMapper = entityMapper;
        _messageListService = messageListService;
        _viewDataSourceFactory = viewDataSourceFactory;
        [self buildModule];
    }
    return self;
}

- (void)buildModule {
    _dataManager = [[THLMessageListDataManager alloc] initWithDataStore:_dataStore entityMapper:_entityMapper messageList:_messageListService];
    _interactor = [[THLMessageListInteractor alloc] initWithDataManager:_dataManager viewDataSourceFactory:_viewDataSourceFactory];
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

- (void)presentChatInNavigationController:(UINavigationController *)navigationController {
    _navigationController = navigationController;
    THLChatRoomViewController * controller = [[THLChatRoomViewController alloc] initWithNibName:nil bundle:nil];
    //[_presenter configureView:controller];
    [_navigationController addChildViewController:controller];
}

@end
