//
//  THLDashboardPresenter.m
//  TheHypelist
//
//  Created by Edgar Li on 11/17/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLDashboardPresenter.h"
#import "THLDashboardInteractor.h"
#import "THLDashboardWireframe.h"
#import "THLDashboardViewController.h"

#import "THLGuestlistInviteEntity.h"
#import "THLEventEntity.h"
#import "THLHostEntity.h"
#import "THLGuestlistEntity.h"

#import "THLViewDataSource.h"
#import "THLDashboardNotificationCell.h"
#import "THLDashboardNotificationCellViewModel.h"
#import "THLDashboardTicketCellViewModel.h"

#import "THLUser.h"

@interface THLDashboardPresenter()
<
THLDashboardInteractorDelegate
>
@property (nonatomic, strong) THLDashboardViewController *view;
@property (nonatomic) BOOL refreshing;
@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic) NSNumber *unopenedInviteCount;
@end

@implementation THLDashboardPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLDashboardWireframe *)wireframe
                       interactor:(THLDashboardInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

- (void)configureView:(THLDashboardViewController *)view {
    self.view = view;
    WEAKSELF();
    STRONGSELF();

    THLViewDataSource *dataSource = [_interactor getDataSource];
    dataSource.dataTransformBlock = ^id(id item) {

        THLGuestlistInviteEntity *guestlistInvite = (THLGuestlistInviteEntity *)item;

        if (guestlistInvite.response == THLStatusPending) {
            return [[THLDashboardNotificationCellViewModel alloc] initWithGuestlistInvite:(THLGuestlistInviteEntity *)item];
        }
        if (guestlistInvite.response == THLStatusAccepted) {
            return [[THLDashboardTicketCellViewModel alloc] initWithGuestlistInvite:(THLGuestlistInviteEntity *)item];
        }
        return nil;
    };
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [_interactor updateGuestlistInvites];
    }];
    
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SSELF handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleNeedLoginAction];
        return [RACSignal empty];
    }];
                                
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [SSELF.view setShowRefreshAnimation:isRefreshing];
    }];

//    [[RACObserve(self, unopenedInviteCount) filter:^BOOL(NSNumber *value) {
//        return value != NULL;
//    }] subscribeNext:^(NSNumber *val) {
//        [SSELF.view.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", val]];
//    }];
    
    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setLoginCommand:loginCommand];
    [_view setRefreshCommand:refreshCommand];
}

- (void)presentDashboardInterfaceInNavigationController:(UINavigationController *)navigationController {
    [_wireframe presentInterfaceInNavigationController:navigationController];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlistInvites];
}

- (void)handleNeedLoginAction {
    [self.moduleDelegate userNeedsLoginOnViewController:(UIViewController *)_view];
}

- (void)updateTabBarBadgeValue {
    if (_unopenedInviteCount != nil) {
        [self.view.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@", _unopenedInviteCount]];
    } else {
        [self.view.navigationController.tabBarItem setBadgeValue:nil];
    }
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
    THLGuestlistInviteEntity *guestlistInviteEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
    [self.moduleDelegate dashboardModule:self didClickToViewGuestlist:guestlistInviteEntity.guestlist guestlistInvite:guestlistInviteEntity presentGuestlistReviewInterfaceOnController:_wireframe.view.view.window.rootViewController];
    if (!guestlistInviteEntity.didOpen) {
        [_interactor updateGuestlistInviteToOpened:guestlistInviteEntity];
    }
}

#pragma mark - THLDashboardInteractorDelegate
- (void)interactor:(THLDashboardInteractor *)interactor didUpdateGuestlistInvites:(BFTask *)task {
    self.refreshing = NO;
    _unopenedInviteCount = task.result;
    [self updateTabBarBadgeValue];
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
