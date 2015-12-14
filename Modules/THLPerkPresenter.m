//
//  THLPerkPresenter.m
//  TheHypelist
//
//  Created by Daniel Aksenov on 11/25/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLPerkPresenter.h"
#import "THLPerksView.h"
#import "THLPerkWireframe.h"
#import "THLPerkInteractor.h"
#import "THLViewDataSource.h"
#import "THLPerkStoreItemEntity.h"
#import "THLPerksCellViewModel.h"
#import "THLUser.h"


@interface THLPerkPresenter()<THLPerkInteractorDelegate>
@property (nonatomic, weak) id<THLPerksView> view;
@property (nonatomic) BOOL refreshing;
@end


@implementation THLPerkPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLPerkWireframe *)wireframe
                       interactor:(THLPerkInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

#pragma mark - Module Interface
- (void)presentPerkInterfaceInWindow:(UIWindow *)window {
    [_wireframe presentPerkInterfaceInWindow:window];
}

- (void)configureView:(id<THLPerksView>)view {
    _view = view;
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [_interactor refreshUserCredits];
    }];
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLPerksCellViewModel alloc] initWithPerkStoreItem:(THLPerkStoreItemEntity *)item];
    };
    
    WEAKSELF();
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
        
    }];

    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];

    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
    [_view setDismissCommand:dismissCommand];
    THLUser *currentUser = [THLUser currentUser];
    [_view setCurrentUserCredit:currentUser.credits];

}
    
    
- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
    THLPerkStoreItemEntity *perkStoreItemEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
    [self.moduleDelegate perkModule:self userDidSelectPerkStoreItemEntity:perkStoreItemEntity presentPerkDetailInterfaceOnController:(UIViewController *)_view];
}
    
- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updatePerks];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

#pragma mark - InteractorDelegate
- (void)interactor:(THLPerkInteractor *)interactor didUpdatePerks:(NSError *)error {
    self.refreshing = NO;
}
@end
