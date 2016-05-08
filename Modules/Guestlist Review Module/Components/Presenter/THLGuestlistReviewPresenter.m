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
#import "THLGuestlistReviewHeaderView.h"
#import "THLMenuView.h"
#import "THLAppearanceConstants.h"
#import "Parse.h"

#import "THLViewDataSource.h"
#import "THLGuestlistInviteEntity.h"
#import "THLGuestlistReviewCellViewModel.h"
#import "THLGuestlistEntity.h"
#import "THLGuestEntity.h"
#import "THLEventEntity.h"
#import "THLLocationEntity.h"
#import "THLConfirmationView.h"
#import "THLUserManager.h"
#import "THLHostEntity.h"
#import "THLChannelService.h"
#import "THLUser.h"
#import "THLParseQueryFactory.h"
#import "THLGuestlist.h"
#import "THLGuestlistTicketEntity.h"

#import "THLGuestlistTicketView.h"

@interface THLGuestlistReviewPresenter()
<
THLGuestlistReviewInteractorDelegate
>
@property (nonatomic, weak) id<THLGuestlistReviewView> view;
@property (nonatomic, strong) THLGuestlistTicketView *ticketView;
@property (nonatomic, strong) THLMenuView *menuView;
@property (nonatomic, strong) THLConfirmationView *confirmationView;

@property (nonatomic) BOOL refreshing;
@property (nonatomic) BOOL showInstruction;
@property (nonatomic) THLGuestlistReviewerStatus reviewerStatus;
@property (nonatomic) THLActivityStatus activityStatus;
@property (nonatomic, strong) RACCommand *responseCommand;

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
//Present guestlist for Guest
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity withGuestlistInvite:(THLGuestlistInviteEntity *)guestlistInviteEntity inController:(UIViewController *)controller andShowInstruction:(BOOL)showInstruction {
    _interactor.guestlistEntity = guestlistEntity;
    _showInstruction = showInstruction;
    _guestlistInviteEntity = guestlistInviteEntity;
    _guestlistEntity = _guestlistInviteEntity.guestlist;
    [self updateGuestReviewStatus];
    if ([_guestlistInviteEntity isPending]) {
        [_wireframe presentPartyViewInController:controller];
    } else {
        [_wireframe presentTicketViewInController:controller];
    }
}

//Present Guestlist for Host
- (void)presentGuestlistReviewInterfaceForGuestlist:(THLGuestlistEntity *)guestlistEntity inController:(UIViewController *)controller {
    _interactor.guestlistEntity = guestlistEntity;
    _guestlistEntity = guestlistEntity;
    [self updateHostReviewStatus];
    [_wireframe presentPartyViewInController:controller];
}

#pragma mark - View Configuration
- (void)configureTicketView:(THLGuestlistTicketView *)view {
    _ticketView = view;
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissAction];
        return [RACSignal empty];
    }];
    RACCommand *viewPartyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleViewPartyAction];
        return [RACSignal empty];
    }];
    RACCommand *viewEventDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleViewEventDetailsAction];
        return [RACSignal empty];
    }];
    
    [_ticketView setDismissCommand:dismissCommand];
    [_ticketView setViewPartyCommand:viewPartyCommand];
    [_ticketView setViewEventDetailsCommand:viewEventDetailsCommand];
    [_ticketView setQrCode:_guestlistInviteEntity.guestlistTicket.qrCode];
    [_ticketView setVenueName:_guestlistInviteEntity.guestlist.event.location.name];
    [_ticketView setEventDate:[NSString stringWithFormat:@"%@", _guestlistEntity.event.date.thl_weekdayString]];
    [_ticketView setArrivalMessage:[NSString stringWithFormat:@"Please arrive by %@", _guestlistEntity.event.date.thl_timeString]];
    [_ticketView setShowInstruction:_showInstruction];
}

- (void)configureView:(id<THLGuestlistReviewView>)view {
    _view = view;
    
    THLViewDataSource *dataSource = [_interactor generateDataSource];
    
    dataSource.dataTransformBlock = ^id(id item) {
        return [[THLGuestlistReviewCellViewModel alloc] initWithGuestlistInviteEntity:(THLGuestlistInviteEntity *)item];
    };
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDismissActionForPartyView];
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
    _responseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        THLConfirmationView *confirmationView = [THLConfirmationView new];
        [self configureResponseView:confirmationView];
        [WSELF handleResponseAction];
        return [RACSignal empty];
    }];
    RACCommand *refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleRefreshAction];
        return [RACSignal empty];
    }];
    
    [[RACObserve(self.view, viewAppeared) filter:^BOOL(NSNumber *b) {
        BOOL viewIsAppearing = [b boolValue];
        return viewIsAppearing == TRUE;
    }] subscribeNext:^(id x) {
        [_interactor updateGuestlistInvites];
    }];
    
    [RACObserve(self, refreshing) subscribeNext:^(NSNumber *b) {
        BOOL isRefreshing = [b boolValue];
        [WSELF.view setShowRefreshAnimation:isRefreshing];
    }];
    
    [RACObserve(self, reviewerStatus) subscribeNext:^(NSNumber *x) {
        [WSELF.view setReviewerStatus:x];
    }];
    
    [_view setDataSource:dataSource];
    [_view setAcceptCommand:acceptCommand];
    [_view setDeclineCommand:declineCommand];
    [_view setResponseCommand:_responseCommand];
    [_view setRefreshCommand:refreshCommand];
    
    THLMenuView *menuView = [THLMenuView new];
    [self configureMenuView:menuView];
    
    RACCommand *showMenuCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view showGuestlistMenuView:menuView];
        return [RACSignal empty];
    }];

    
    [_view setHeaderViewImage:_guestlistEntity.event.location.imageURL];
    NSString *firstName = _guestlistEntity.owner.firstName;
    NSString *lastName = [_guestlistEntity.owner.lastName substringToIndex:1];
    NSString *venueLocation = _guestlistEntity.event.location.name;
    [_view setTitle:[NSString stringWithFormat:@"%@ %@'s Party For %@", firstName, lastName, venueLocation]];
    [_view setDismissCommand:dismissCommand];
    [_view setShowMenuCommand:showMenuCommand];
    [_view setFormattedDate: [NSString stringWithFormat:@"%@, %@", _guestlistEntity.event.date.thl_weekdayString, _guestlistEntity.event.date.thl_timeString]];
    
    [_view setGuestlistReviewStatus: _guestlistEntity.reviewStatus];
    switch (_guestlistEntity.reviewStatus) {
        case THLStatusNone: {
            break;
        }
        case THLStatusPending: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Pending Approval"];
            break;
        }
        case THLStatusAccepted: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Approved"];
            
            break;
        }
        case THLStatusDeclined: {
            [_view setGuestlistReviewStatusTitle:@"Guestlist Declined"];
            break;
        }
        default: {
            break;
        }
    }
}

- (void)configureResponseView:(THLConfirmationView *)view {
    self.confirmationView = view;
    
    WEAKSELF();
    RACCommand *confirmationAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleAcceptAction];
        return [RACSignal empty];
    }];
    
    RACCommand *confirmationDeclineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleDeclineAction];
        return [RACSignal empty];
    }];
    
    RACCommand *viewDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        [_wireframe dismissInterface];
        return [RACSignal empty];
    }];
    
    RACCommand *confirmationDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.confirmationView dismiss];
        return [RACSignal empty];
    }];
    
    RACCommand *acceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF configureConfirmationView:WSELF.confirmationView title:@"Accept Invite"
                                 message:@"Are you sure you want to accept your invite?"
                           acceptCommand:confirmationAcceptCommand
                          declineCommand:WSELF.responseCommand
                          dismissCommand:confirmationDismissCommand];
        return [RACSignal empty];
    }];
    
    RACCommand *declineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF configureConfirmationView:WSELF.confirmationView
                                   title:@"Decline Invite"
                                 message:@"Are you sure you want to decline your invite?"
                           acceptCommand:confirmationDeclineCommand
                          declineCommand:WSELF.responseCommand
                          dismissCommand:viewDismissCommand];
        return [RACSignal empty];
    }];

    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:confirmationDismissCommand];
}

- (void)configureConfirmationView:(THLConfirmationView *)view
                            title:(NSString *)title
                          message:(NSString *)message
                    acceptCommand:(RACCommand *)acceptCommand
                   declineCommand:(RACCommand *)declineCommand
                   dismissCommand:(RACCommand *)dismissCommand {
    [view setConfirmationWithTitle:title message:message];
    [_confirmationView setAcceptCommand:acceptCommand];
    [_confirmationView setDeclineCommand:declineCommand];
    [_confirmationView setDismissCommand:dismissCommand];
}

// -----------------------------------------
#pragma mark - MenuView Configuration
// -----------------------------------------
- (void)configureMenuView:(THLMenuView *)menuView {
    self.menuView = menuView;
    
    if (self.reviewerStatus != THLGuestlistOwner && self.reviewerStatus != THLGuestlistCheckedInOwner && self.reviewerStatus != THLGuestlistOwnerPendingApproval) {
        [_menuView guestLayoutUpdate];
    }
    
    if (self.reviewerStatus == THLGuestlistOwner || self.reviewerStatus == THLGuestlistCheckedInOwner || self.reviewerStatus == THLGuestlistOwnerPendingApproval) {
        [_menuView partyLeadLayoutUpdate];
    }
    
    if (self.reviewerStatus == THLGuestlistActiveHost) {
        [_menuView hostLayoutUpdate];
    }
    
    WEAKSELF();
    RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        return [RACSignal empty];
    }];
    
    RACCommand *addGuestsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        [WSELF handleAddGuestsAction];
        return [RACSignal empty];
    }];
    
    RACCommand *leaveGuestlistCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        THLConfirmationView *confirmationView = [THLConfirmationView new];
        [self configureResponseView:confirmationView];
        [WSELF handleLeaveAction];
        return [RACSignal empty];
    }];
    
    RACCommand *showEventDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.view hideGuestlistMenuView:menuView];
        [WSELF handleViewEventDetailsForPartyAction];
        return [RACSignal empty];
    }];
    
    [_menuView setHostName:_guestlistEntity.event.host.firstName];
    [_menuView setHostImageURL:_guestlistEntity.event.host.imageURL];

    [_menuView setDismissCommand:dismissCommand];
    [_menuView setMenuAddGuestsCommand:addGuestsCommand];
    [_menuView setMenuLeaveGuestCommand:leaveGuestlistCommand];
    [_menuView setMenuEventDetailsCommand:showEventDetailsCommand];
}



//TODO: Create Configure Review Options
- (void)manageReviewer {
    if ([THLUserManager userIsGuest]) {
        [self updateGuestReviewStatus];
    } else {
        [self updateHostReviewStatus];
    }
}

- (void)updateGuestReviewStatus {
    if ([_guestlistInviteEntity isOwnerInvite] && [_guestlistInviteEntity isCheckedIn] ) {
        self.reviewerStatus = THLGuestlistCheckedInOwner;
    }
    else if ([_guestlistInviteEntity isOwnerInvite] && [_guestlistEntity isPending]) {
        self.reviewerStatus = THLGuestlistOwnerPendingApproval;
    }
    else if ([_guestlistInviteEntity isOwnerInvite]) {
        self.reviewerStatus = THLGuestlistOwner;
    }
    else if ([_guestlistInviteEntity isCheckedIn]) {
        self.reviewerStatus = THLGuestlistCheckedInGuest;
    }
    else if ([_guestlistInviteEntity isAccepted] && [_guestlistEntity isPending]) {
        self.reviewerStatus = THLGuestlistAttendingGuestPendingApproval;
    }
    else if ([_guestlistInviteEntity isAccepted]) {
        self.reviewerStatus = THLGuestlistAttendingGuest;
    }

    else if ([_guestlistInviteEntity isPending]) {
        self.reviewerStatus = THLGuestlistPendingGuest;
    }
    
    [_view setReviewerStatus:[NSNumber numberWithInt:self.reviewerStatus]];
    
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)updateHostReviewStatus {
    if ([_guestlistEntity isPending]) {
        self.reviewerStatus = THLGuestlistPendingHost;
    }
    else if ([_guestlistEntity isAccepted] || [_guestlistEntity doesNotRequireApproval]) {
        self.reviewerStatus = THLGuestlistActiveHost;
    }
    else if ([_guestlistEntity isDeclined]) {
        self.reviewerStatus = THLGuestlistDeclinedHost;
    }
    DLog(@"Status is now %ld", (long)self.reviewerStatus);
}

#pragma mark - Event Handling
- (void)handleViewPartyAction {
    [_wireframe presentPartyViewOnTicketView];
}
- (void)handleViewEventDetailsAction {
    [_wireframe presentDetailsForEvent:_guestlistEntity.event];
}

- (void)handleViewEventDetailsForPartyAction {
    [_wireframe presentDetailsForEventOnPartyView:_guestlistEntity.event];
}

- (void)handleDismissAction {
    [_wireframe dismissInterface];
}

- (void)handleDismissActionForPartyView {
    [_wireframe dismissPartyView];
}

- (void)handleRefreshAction {
    self.refreshing = YES;
    [_interactor updateGuestlistInvites];
}

- (void)handleResponseAction {
    NSString *ownerName = _guestlistInviteEntity.guestlist.owner.firstName;
    NSString *eventName =_guestlistInviteEntity.guestlist.event.location.name;
    NSString *eventTime =_guestlistInviteEntity.guestlist.event.date.thl_timeString;
    NSString *eventDate =_guestlistInviteEntity.guestlist.event.date.thl_weekdayString;
    
    switch (_reviewerStatus) {
        case THLGuestlistPendingGuest: {
            [_confirmationView setResponseFlowWithTitle:@"Respond Now"
                                                 message:[NSString stringWithFormat:@"%@ would like you to join their guestlist for %@, %@ at %@", ownerName, eventName, eventDate, eventTime]];
            [_view showResponseView:_confirmationView];

            break;
        }
        case THLGuestlistAttendingGuest: {
            [_interactor checkInForGuestlistInvite:_guestlistInviteEntity];
            break;
        }
        case THLGuestlistOwner: {
            [_interactor checkInForGuestlistInvite:_guestlistInviteEntity];
            break;
        }
        case THLGuestlistPendingHost: {
            [_confirmationView setResponseFlowWithTitle:@"Respond Now"
                                                 message:[NSString stringWithFormat:@"%@'s party would like to join to your guestlist for %@, %@ at %@", _guestlistEntity.owner.firstName, _guestlistEntity.event.location.name ,_guestlistEntity.event.date.thl_weekdayString, _guestlistEntity.event.date.thl_timeString]];
            [_view showResponseView:_confirmationView];

            break;
        }
        case THLGuestlistActiveHost: {

            break;
        }
        default: {
            break;
        }
    }
}

- (void)handleLeaveAction {
    
    NSString *ownerName = _guestlistInviteEntity.guestlist.owner.firstName;
    NSString *eventName =_guestlistInviteEntity.guestlist.event.location.name;
    
    WEAKSELF();
    RACCommand *confirmationAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF handleAcceptAction];
        return [RACSignal empty];
    }];

    RACCommand *confirmationDeclineCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [WSELF.confirmationView dismiss];
        return [RACSignal empty];
    }];

    RACCommand *viewDismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [_wireframe dismissPartyView];
        return [RACSignal empty];
    }];

    [_confirmationView setAcceptCommand:confirmationAcceptCommand];
    [_confirmationView setDeclineCommand:confirmationDeclineCommand];
    [_confirmationView setDismissCommand:viewDismissCommand];

    [_confirmationView setConfirmationWithTitle:@"Leave Guestlist"
                                         message:[NSString stringWithFormat:@"Are you sure you want to leave %@'s party for %@?", ownerName, eventName]];
    [_view showResponseView:_confirmationView];

}

- (void)handleAcceptAction {
    /**
     *  Guest Accept Action Options
     */
    if (_reviewerStatus == THLGuestlistAttendingGuest || _reviewerStatus == THLGuestlistAttendingGuestPendingApproval) {
        [_confirmationView setInProgressWithMessage:@"Leaving guestlist..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity
                              withResponse:THLStatusDeclined];
        [_interactor unSubscribeChannelsForUser:[THLUser currentUser] withGuestlist:_guestlistInviteEntity.guestlist];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"InviteDeclined"];

        [mixpanel.people increment:@"guestlist invites declined" by:@1];

        //_guestlistInviteEntity.guestlist.objectId
        //_
        // UNSUBCSRIBE
    }
    else if (_reviewerStatus == THLGuestlistPendingGuest) {
        [_confirmationView setInProgressWithMessage:@"Accepting your invite..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity
                              withResponse:THLStatusAccepted];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"InviteAccepted"];
        [mixpanel.people increment:@"guestlist invites accepted" by:@1];

    }
    /**
     *  Host Accept Action Options
     */
    else if (_reviewerStatus == THLGuestlistPendingHost) {
        [_confirmationView setInProgressWithMessage:@"Accepting guestlist..."];
        [_interactor updateGuestlist:_guestlistEntity
                    withReviewStatus:THLStatusAccepted];
    }
    else if (_reviewerStatus == THLGuestlistActiveHost) {
        self.activityStatus = THLActivityStatusSuccess;
//        [_interactor checkInGuests:_guestlistInviteEntity withResponse:THLStatusAccepted];
    }
}

- (void)handleDeclineAction {
    /**
     *  Guest Decline Action Options
     */
    if (_reviewerStatus == THLGuestlistAttendingGuest) {
        
    }
    else if (_reviewerStatus == THLGuestlistPendingGuest) {
        [_confirmationView setInProgressWithMessage:@"Declining your invite..."];
        [_interactor updateGuestlistInvite:_guestlistInviteEntity
                              withResponse:THLStatusDeclined];
        [_interactor unSubscribeChannelsForUser:[THLUser currentUser] withGuestlist:_guestlistInviteEntity.guestlist];
        Mixpanel *mixpanel = [Mixpanel sharedInstance];
        [mixpanel track:@"InviteDeclined"];
        [mixpanel.people increment:@"guestlist invites declined" by:@1];

    }
    /**
     *  Host Decline Action Options
     */
    else if (_reviewerStatus == THLGuestlistPendingHost) {
        [_confirmationView setInProgressWithMessage:@"Declining guestlist..."];
        [_interactor updateGuestlist:_guestlistEntity
                    withReviewStatus:THLStatusDeclined];
    }
    else if (_reviewerStatus == THLGuestlistActiveHost) {
        
    }
}

- (void)handleAddGuestsAction {
    [self.moduleDelegate guestlistReviewModule:self
                                         event:_guestlistInviteEntity.guestlist.event
                               withGuestlistId:_guestlistInviteEntity.guestlist.objectId
                                     andGuests:[_interactor guests]
presentGuestlistInvitationInterfaceOnController:(UIViewController *)self.view];
}

- (void)guestError {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"Only a party leader can perform that action");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
}


- (void)partyLeaderError {
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    
    NSString *message = NSStringWithFormat(@"A party leader can't leave their own guestlist");
    
    [self showAlertViewWithMessage:message withAction:[[NSArray alloc] initWithObjects:cancelAction, nil]];
    
}

- (void)showAlertViewWithMessage:(NSString *)message withAction:(NSArray<UIAlertAction *>*)actions {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    for(UIAlertAction *action in actions) {
        [alert addAction:action];
    }
    
    [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
}

#pragma mark - InteractorDelegate
- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInvites:(NSError *)error {
    self.refreshing = NO;
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteResponse:(NSError *)error to:(THLStatus)response {
    if (!error && response == THLStatusAccepted) {
         NSString *eventTime =_guestlistInviteEntity.guestlist.event.date.thl_timeString;
        if ([_guestlistEntity isPending]) {
            self.reviewerStatus = THLGuestlistAttendingGuestPendingApproval;
        } else {
            self.reviewerStatus = THLGuestlistAttendingGuest;
        }
        RACCommand *viewDismissAndShowTicketCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [_wireframe dismissPartyViewAndShowTicketView];
            return [RACSignal empty];
        }];
        [self.confirmationView setDismissCommand:viewDismissAndShowTicketCommand];
        
        [self.confirmationView setSuccessWithTitle:@"Accepted Invite"
                                            Message: NSStringWithFormat(@"You can view your ticket for this event in the 'My Events' tab and show your ticket at the door for entrance")];

    } else if (!error && response == THLStatusDeclined) {
        RACCommand *dismissCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            [_wireframe dismissPartyView];
            return [RACSignal empty];
        }];
        [self.confirmationView setDismissCommand:dismissCommand];
        [self.confirmationView setSuccessWithTitle:@"Declined Invite"
                                            Message:@"Your invite has been declined. If you would like to create your own guestlist for this event, you can do so in the event page."];

        
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistReviewStatus:(NSError *)error to:(THLStatus)reviewStatus {
    if (!error && reviewStatus == THLStatusAccepted) {
        self.reviewerStatus = THLGuestlistActiveHost;
        [self.confirmationView setSuccessWithTitle:@"Accepted Guestlist"
                                            Message:@"You have accepted this Guestlist. If your guests have any questions, they will contact you through chat."];
        [_view setGuestlistReviewStatus:reviewStatus];
        [_view setGuestlistReviewStatusTitle:@"Guestlist Accepted"];

    } else if (!error && reviewStatus == THLStatusDeclined) {
        self.reviewerStatus = THLGuestlistDeclinedHost;
        [self.confirmationView setSuccessWithTitle:@"Declined Guestlist"
                                            Message:@"You have declined this Guestlist."];
        [_view setGuestlistReviewStatus:reviewStatus];
        [_view setGuestlistReviewStatusTitle:@"Guestlist Declined"];
    } else {
        self.activityStatus = THLActivityStatusError;
    }
    NSLog(@"Status is now %ld", (long)self.reviewerStatus);
}

- (void)interactor:(THLGuestlistReviewInteractor *)interactor didUpdateGuestlistInviteCheckInStatus:(NSError *)error to:(BOOL)status {
    if (status) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Checked In"
                                                                       message:@"You have successfully checked in. The host has been notified"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
        _guestlistInviteEntity.checkInStatus = status;
        [self updateGuestReviewStatus];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Not checked In"
                                                                       message:@"You are not in range to check In"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [(UIViewController *)_view presentViewController:alert animated:YES completion:nil];
    }
}


- (void)dealloc {
    NSLog(@"Destroyed %@", self);
}
@end
