//
//  THLMessageListPresenter.m
//  HypeUp
//
//  Created by Александр on 03.02.16.
//  Copyright © 2016 Hypelist. All rights reserved.
//

#import "THLMessageListPresenter.h"
#import "THLMessageListModuleDelegate.h"
#import "THLMessageListInteractor.h"
#import "THLMessageListWireframe.h"
#import "THLMessageListViewModel.h"
#import "THLViewDataSource.h"
#import "THLMessageListEntity.h"
#import "THLMessageListView.h"
#import "THLChatRoomViewController.h"
#import "THLChatListViewController.h"
#import "THLUser.h"

@interface THLMessageListPresenter ()<THLMessageListInteractorDelegate>

@property (nonatomic, weak) id<THLMessageListView> view;
@property (nonatomic) BOOL refreshing;

@end

@implementation THLMessageListPresenter
@synthesize moduleDelegate;

- (instancetype)initWithInteractor:(THLMessageListInteractor *)interactor
                         wireframe:(THLMessageListWireframe *)wireframe {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
        
    }
    return self;
}

#pragma mark - Module Interface
- (void)presentChatRoomInNavigationController:(UINavigationController *)navigationController {
    [_wireframe presentInNavigationController:navigationController];
}

- (void)interactor:(THLMessageListInteractor *)interactor didUpdateChannels:(NSError *)error {
    self.refreshing = NO;
}

- (void)configureView:(id<THLMessageListView>)view {
    _view = view;
    
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        //[_interactor refreshUserCredits];
    }];
    
    WEAKSELF();
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLMessageListViewModel alloc] initWithMessageList:(THLMessageListEntity *)item];
    };
    
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF checkIfUserLoggedInThenHandleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];

    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
    
}

- (void)checkIfUserLoggedInThenHandleIndexPathSelection:(NSIndexPath *)indexPath {
    if (![THLUser currentUser]) {
        [self handleLogInAction];
    } else {
        
        THLChatRoomViewController * chtvctrl = [[THLChatRoomViewController alloc] init];
        //THLChatListViewController * controller = [[THLChatListViewController alloc] init];

        THLMessageListEntity *messageListEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
        [self.moduleDelegate messageListModule:self userDidSelectMessageListItemEntity:messageListEntity presentChatRoomInterfaceOnController:chtvctrl];
        //[self.moduleDelegate perkModule:self userDidSelectPerkStoreItemEntity:perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)_view];
        //НАЖАТИЕ НА ЯЧЕЙКУ
    }
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateChannels];
}

- (void)handleLogInAction {
    //[self.moduleDelegate userNeedsLoginOnViewController:(UIViewController *)_view];
}




@end
