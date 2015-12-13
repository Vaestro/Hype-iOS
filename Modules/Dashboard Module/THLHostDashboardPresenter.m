//
//  THLHostDashboardPresenter.m
//  TheHypelist
//
//  Created by Edgar Li on 12/3/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLHostDashboardPresenter.h"
#import "THLHostDashboardInteractor.h"
#import "THLHostDashboardWireframe.h"
#import "THLHostDashboardView.h"

#import "THLEventEntity.h"
#import "THLHostEntity.h"
#import "THLPromotionEntity.h"
#import "THLGuestlistEntity.h"

#import "THLViewDataSource.h"
#import "THLDashboardNotificationCell.h"
#import "THLHostDashboardNotificationCellViewModel.h"
#import "THLHostDashboardTicketCellViewModel.h"

@interface THLHostDashboardPresenter()
<
THLHostDashboardInteractorDelegate
>
@property (nonatomic, strong) id<THLHostDashboardView> view;

@property (nonatomic) BOOL refreshing;

@property (nonatomic, strong) THLEventEntity *eventEntity;
@property (nonatomic, strong) THLPromotionEntity *promotionEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;

@end

@implementation THLHostDashboardPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLHostDashboardWireframe *)wireframe
                       interactor:(THLHostDashboardInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

- (void)configureView:(id<THLHostDashboardView>)view {
    self.view = view;
    
    THLViewDataSource *dataSource = [_interactor getDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLHostDashboardNotificationCellViewModel alloc] initWithGuestlist:(THLGuestlistEntity *)item];
    };
    
    WEAKSELF();
    STRONGSELF();
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [SSELF handleIndexPathSelection:(NSIndexPath *)input];
        return [RACSignal empty];
    }];
    
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [SSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    [_view setDataSource:dataSource];
    [_view setSelectedIndexPathCommand:selectedIndexPathCommand];
    [_view setRefreshCommand:refreshCommand];
}

- (void)presentDashboardInterfaceInViewController:(UIViewController *)viewController {
    [_wireframe presentInterfaceInViewController:viewController];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlists];
}

- (void)handleIndexPathSelection:(NSIndexPath *)indexPath {
    THLGuestlistEntity *guestlistEntity = [[_view dataSource] untransformedItemAtIndexPath:indexPath];
    [self.moduleDelegate hostDashboardModule:self didClickToViewGuestlistReqeust:guestlistEntity];
}

#pragma mark - THLHostDashboardInteractorDelegate
- (void)interactor:(THLHostDashboardInteractor *)interactor didUpdateGuestlists:(NSError *)error {
    self.refreshing = NO;
}
@end