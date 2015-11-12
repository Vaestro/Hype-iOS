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
#import "THLGuestlistEntity.h"
#import "THLGuestEntity.h"
#import "THLPromotionEntity.h"
#import "THLEventEntity.h"
#import "THLUser.h"

@interface THLGuestlistReviewPresenter()
<
THLGuestlistReviewInteractorDelegate
>
@property (nonatomic, weak) id<THLGuestlistReviewView> view;

@property (nonatomic) BOOL refreshing;
@property (nonatomic) THLGuestlistReviewerStatus reviewerStatus;
@property (nonatomic) THLActivityStatus activityStatus;

@property (nonatomic, strong) THLGuestlistInviteEntity *guestlistInviteEntity;
@property (nonatomic, strong) THLGuestlistEntity *guestlistEntity;
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
    [self updateGuestReviewStatus];
    [_wireframe presentInterfaceInController:controller];
}

- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity inController:(UIViewController *)controller {
    _interactor.guestlistEntity = guestlistEntity;
    _guestlistEntity = guestlistEntity;
    [self updateHostReviewStatus];
    [_wireframe presentInterfaceInController:controller];
}

- (void)configureView:(id<THLGuestlistReviewView>)view {
    _view = view;
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLGuestlistReviewCellViewModel alloc] initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)item];
    };
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleAcceptAction];
        return [RACSignal empty];
    }];
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDeclineAction];
        return [RACSignal empty];
    }];
    RACCommand *decisionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDecisionAction];
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
    
    [RACObserve(self, activityStatus) subscribeNext:^(id _) {
        [WSELF.view setShowActivityIndicator:WSELF.activityStatus];
    }];
    
    [RACObserve(self, reviewerStatus) subscribeNext:^(NSNumber *x) {
        [WSELF.view setReviewerStatus:x];
    }];
    
    [_view setDataSource:dataSource];
    [_view setDismissCommand:dismissCommand];
    [_view setAcceptCommand:acceptCommand];
    [_view setDeclineCommand:declineCommand];
    [_view setDecisionCommand:decisionCommand];
    [_view setRefreshCommand:refreshCommand];

//    TODO: Index Path Logic for Check Ins
    //    RACCommand *selectedIndexPathCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    //        [self handleIndexPathSelection:(NSIndexPath *)input];
    //        return [RACSignal empty];
    //    }];
    //
    //    [view setSelectedIndexPathCommand:selectedIndexPathCommand];
}

//TODO: Create Configure Review Options
- (void)manageReviewer {
    if ([THLUser currentUser].type == THLUserTypeGuest) {
        [self updateGuestReviewStatus];
    } else {
        [self updateHostReviewStatus];
    }
}

- (void)updateGuestReviewStatus {
    if (_guestlistInviteEntity.response == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistReviewerStatusAttendingGuest;
    }
    else if (_guestlistInviteEntity.response == THLStatusPending) {
        self.reviewerStatus = THLGuestlistReviewerStatusPendingGuest;
    }
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)updateHostReviewStatus {
    if (_guestlistEntity.reviewStatus == THLStatusPending) {
        self.reviewerStatus = THLGuestlistReviewerStatusPendingHost;
    }
    else if (_guestlistEntity.reviewStatus == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistReviewerStatusActiveHost;
    }
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
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
    /**
     *  Guest Accept Action Options
     */
    if (_reviewerStatus == THLGuestlistReviewerStatusAttendingGuest) {
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusDeclined];
        [_wireframe dismissInterface];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusPendingGuest) {
        self.activityStatus = THLActivityStatusInProgress;
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
    /**
     *  Host Accept Action Options
     */
    else if (_reviewerStatus == THLGuestlistReviewerStatusPendingHost) {
        self.activityStatus = THLActivityStatusInProgress;
        [_interactor updateGuestlist:_guestlistEntity withReviewStatus:THLStatusAccepted];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusActiveHost) {
        self.activityStatus = THLActivityStatusInProgress;
//        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
}

- (void)handleDeclineAction {
    /**
     *  Guest Decline Action Options
     */
    if (_reviewerStatus == THLGuestlistReviewerStatusAttendingGuest) {
        [_view.popup dismiss:TRUE];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusPendingGuest) {
        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusDeclined];
    }
    /**
     *  Host Decline Action Options
     */
    else if (_reviewerStatus == THLGuestlistReviewerStatusPendingHost) {
        self.activityStatus = THLActivityStatusInProgress;
        [_interactor updateGuestlist:_guestlistEntity withReviewStatus:THLStatusDeclined];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusActiveHost) {
        self.activityStatus = THLActivityStatusInProgress;
        //        [_interactor updateGuestlistInvite:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
}

- (void)handleDecisionAction {
    NSString *ownerName = _guestlistInviteEntity.guestlist.owner.firstName;
    NSString *eventName =_guestlistInviteEntity.guestlist.promotion.event.title;
    NSString *promotionTime =_guestlistInviteEntity.guestlist.promotion.time.thl_timeString;
    NSString *promotionDate =_guestlistInviteEntity.guestlist.promotion.time.thl_weekdayString;

    if (_reviewerStatus == THLGuestlistReviewerStatusAttendingGuest) {
        [_view confirmActionWithMessage:[NSString stringWithFormat:@"Are you sure you want to leave %@'s party for %@?", ownerName, eventName] acceptTitle:@"YES" declineTitle:@"NO"];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusPendingGuest) {
        [_view confirmActionWithMessage:[NSString stringWithFormat:@"%@ would like you to join their guestlist for %@, %@ at %@", ownerName, eventName, promotionDate, promotionTime] acceptTitle:@"ACCEPT" declineTitle:@"DECLINE"];
    }
    
    if (_reviewerStatus == THLGuestlistReviewerStatusPendingHost) {
        [_view confirmActionWithMessage:[NSString stringWithFormat:@"%@'s party would like to join to your guestlist for %@, %@ at %@", ownerName, eventName,promotionDate, promotionTime] acceptTitle:@"ACCEPT" declineTitle:@"DECLINE"];
    }
    else if (_reviewerStatus == THLGuestlistReviewerStatusActiveHost) {
//        [_view confirmActionWithMessage:[NSString stringWithFormat:@"%@ would like you to join their guestlist for %@, %@ at %@", ownerName, eventName, promotionDate, promotionTime] acceptTitle:@"ACCEPT" declineTitle:@"DECLINE"];
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
    if (!error && response == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistReviewerStatusAttendingGuest;
        self.activityStatus = THLActivityStatusSuccess;
    } else if (!error && response == THLStatusDeclined) {
        self.activityStatus = THLActivityStatusNone;
        [_wireframe dismissInterface];
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistReviewStatus:(NSError *)error to:(THLStatus)reviewStatus {
    if (!error && reviewStatus == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistReviewerStatusActiveHost;
        self.activityStatus = THLActivityStatusSuccess;
    } else if (!error && reviewStatus == THLStatusDeclined) {
        self.activityStatus = THLActivityStatusNone;
        [_wireframe dismissInterface];
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
