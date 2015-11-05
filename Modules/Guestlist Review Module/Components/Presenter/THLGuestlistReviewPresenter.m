//
//  THLGuestlistReviewPresenter.m
//  Hypelist2point0
//
//  Created by Edgar Li on 10/31/15.
//  Copyright © 2015 Hypelist. All rights reserved.
//

#import "THLGuestlistReviewPresenter.h"
#import "THLGuestlistReviewWireframe.h"
#import "THLGuestlistReviewInteractor.h"
#import "THLGuestlistReviewView.h"

#import "THLViewDataSource.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistReviewCellViewModel.h"

@interface THLGuestlistReviewPresenter()
<
THLGuestlistReviewInteractorDelegate
>
@property (nonatomic, weak) id<THLGuestlistReviewView> view;
@property (nonatomic, copy) NSString *reviewer;
@property (nonatomic) THLGuestlistReviewerStatus reviewerStatus;
@property (nonatomic) BOOL refreshing;
@property (nonatomic) THLActivityStatus activityStatus;
@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@end

@implementation THLGuestlistReviewPresenter
@synthesize moduleDelegate;

- (instancetype)initWithWireframe:(THLGuestlistReviewWireframe *)wireframe
                       interactor:(THLGuestlistReviewInteractor *)interactor {
    if (self = [super init]) {
        _wireframe = wireframe;
        _interactor = interactor;
        _interactor.delegate = self;
    }
    return self;
}

#pragma mark - THLGuestlistReviewModuleInterface
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller {
    _interactor.guestlistEntity = guestlistEntity;
    _guestlistInviteEntity = guestlistInviteEntity;
    [self updateReviewStatus];
    [_wireframe presentInterfaceInController:controller];
}

- (void)configureView:(id<THLGuestlistReviewView>)view {
    WEAKSELF();
    _view = view;
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLGuestlistReviewCellViewModel alloc] initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)item];
    };
    
    [view setDataSource:dataSource];

    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleDismissAction];
        return [RACSignal empty];
    }];
    
    [view setDismissCommand:dismissCommand];
    
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleAcceptAction];
        return [RACSignal empty];
    }];
    
    [view setAcceptCommand:acceptCommand];
    
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleDeclineAction];
        return [RACSignal empty];
    }];
    
    [view setDeclineCommand:declineCommand];
    
    RACCommand *confirmCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self handleConfirmAction];
        return [RACSignal empty];
    }];
    
    [view setConfirmCommand:confirmCommand];
    
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    [view setRefreshCommand:refreshCommand];
    
    [RACObserve(WSELF, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [view setShowRefreshAnimation:isRefreshing];
    }];
    
    [RACObserve(WSELF, activityStatus) subscribeNext:^(id _) {
        [view setShowActivityIndicator:_activityStatus];
    }];
    
    [RACObserve(WSELF, reviewerStatus) subscribeNext:^(id _) {
        [view setReviewerStatus:_reviewerStatus];
    }];
    //    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //        [self handleIndexPathSelection:(NSIndexPath *)input];
    //        return [RACSignal empty];
    //    }];
    //
    //    [view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

//TODO: Create Configure Review Options
- (void)updateReviewStatus {
    WEAKSELF();
    if (_guestlistInviteEntity.response == THLStatusAccepted) {
        WSELF.reviewerStatus = THLGuestlistReviewerStatusAttendingGuest;
    }
}
#pragma mark - Event Handling

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlistInvites];
}

- (void)handleAcceptAction {
    self.activityStatus = THLActivityStatusInProgress;
    [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusAccepted];
}

- (void)handleDeclineAction {
    self.activityStatus = THLActivityStatusInProgress;
    [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusDeclined];
}

- (void)handleConfirmAction {
    if (_guestlistInviteEntity.response == THLStatusAccepted) {
        [_view confirmActionWithMessage:@"Are you sure you want to leave the Guestlist?"];
    }
    if (_guestlistInviteEntity.response == THLStatusPending) {
        [_view confirmActionWithMessage:@"Are you sure you want to decline your Invite?"];
    }
}

//- (void)handleAddGuestAction {
//    [self.moduleDelegate guestlistReviewModule:self promotion:_guestlistEntity.promotion presentGuestlistInvitationInterfaceOnController:(UIViewController *)_view];
//}
//
//- (void)handleAcceptGuestlistAction {
//    //    self.showActivityIndicator = YES;
//    [_interactor updateGuestlistReviewStatus:@"Accepted"];
//}
//
//- (void)handleDeclineGuestlistAction {
//    //    self.showActivityIndicator = YES;
//    [_interactor updateGuestlistReviewStatus:@"Declined"];
//}

#pragma mark - InteractorDelegate
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInvites:(NSError *)error {
    self.refreshing = NO;
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteResponse:(NSError *)error to:(THLStatus)response {
    WEAKSELF();
    if (!error && response == THLStatusAccepted) {
        [self updateReviewStatus];
        WSELF.activityStatus = THLActivityStatusNone;
    } else if (!error && response == THLStatusDeclined) {
        WSELF.activityStatus = THLActivityStatusNone;
        [_wireframe dismissInterface];
    }
}
@end
